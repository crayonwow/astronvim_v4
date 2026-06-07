-- Postfix snippets for Go error handling, powered by Treesitter.
--
--   err.ife   →   if err != nil { return <zeros>, err }
--   err.r     →   if err != nil { return <zeros>, fmt.Errorf("<msg>: %w", err) }
--
-- Return-type zero values are inferred from the enclosing function signature
-- at expansion time. Works with named returns, unnamed returns, and func literals.
-- Unknown named types default to nil (correct for interfaces; user fixes structs).

local ls = require "luasnip"
local f = ls.function_node
local i = ls.insert_node
local tsf = require "luasnip.extras.treesitter_postfix"
local ts_postfix = tsf.treesitter_postfix
local tsnode_matcher = tsf.builtin.tsnode_matcher

-- ─── helpers ───────────────────────────────────────────────────────────────────

local NUMERIC = {
  int = true,
  int8 = true,
  int16 = true,
  int32 = true,
  int64 = true,
  uint = true,
  uint8 = true,
  uint16 = true,
  uint32 = true,
  uint64 = true,
  uintptr = true,
  float32 = true,
  float64 = true,
  complex64 = true,
  complex128 = true,
  byte = true,
  rune = true,
}

--- Return the Go zero value for `type_str`.
--- `err_var` is substituted for the built-in "error" type.
local function zero_value(type_str, err_var)
  type_str = vim.trim(type_str)
  if type_str == "error" then return err_var end
  if type_str == "string" then return '""' end
  if type_str == "bool" then return "false" end
  if NUMERIC[type_str] then return "0" end
  -- nil-able: pointer, slice, map, channel, func, bare interface
  if
    type_str:match "^%*"
    or type_str:match "^%["
    or type_str:match "^map%["
    or type_str:match "^chan[ <]"
    or type_str:match "^func%("
    or type_str == "interface{}"
    or type_str == "any"
  then
    return "nil"
  end
  return "nil"
end

--- Walk up the treesitter tree to the nearest enclosing function node.
local function get_enclosing_func(node)
  local cur = node
  while cur do
    local nt = cur:type()
    if nt == "function_declaration" or nt == "method_declaration" or nt == "func_literal" then return cur end
    cur = cur:parent()
  end
end

--- Collect return-type strings from a function node's `result` field.
local function get_return_types(func_node, bufnr)
  if not func_node then return {} end
  local result_nodes = func_node:field "result"
  if not result_nodes or #result_nodes == 0 then return {} end

  local result = result_nodes[1]
  local types = {}

  if result:type() == "parameter_list" then
    for child in result:iter_children() do
      if child:type() == "parameter_declaration" then
        local tf = child:field "type"
        if tf and #tf > 0 then table.insert(types, vim.treesitter.get_node_text(tf[1], bufnr)) end
      end
    end
  else
    -- single unnamed return type, e.g. `func foo() error`
    table.insert(types, vim.treesitter.get_node_text(result, bufnr))
  end

  return types
end

--- Return types of the function surrounding the current cursor.
local function return_types_at_cursor()
  local bufnr = vim.api.nvim_get_current_buf()
  local node = vim.treesitter.get_node { buf = bufnr }
  return get_return_types(get_enclosing_func(node), bufnr)
end

-- ─── snippets ──────────────────────────────────────────────────────────────────

local match_err_node = tsnode_matcher.find_topmost_types { "identifier", "selector_expression" }

return {

  -- ── .ife ─────────────────────────────────────────────────────────────────────
  ts_postfix({ trig = ".ife", reparseBuffer = "live", matchTSNode = match_err_node }, {
    f(function(_, snip)
      local err_var = snip.env.LS_TSMATCH[1]
      local types = return_types_at_cursor()
      local returns = {}
      for _, type_str in ipairs(types) do
        table.insert(returns, zero_value(type_str, err_var))
      end
      local ret = table.concat(returns, ", ")
      if ret == "" then return { "if " .. err_var .. " != nil {", "\treturn", "}" } end
      return { "if " .. err_var .. " != nil {", "\treturn " .. ret, "}" }
    end, {}),
  }),

  -- ── .r (fmt.Errorf wrap) ──────────────────────────────────────────────────────
  ts_postfix({ trig = ".r", reparseBuffer = "live", matchTSNode = match_err_node }, {
    f(function(_, snip)
      local err_var = snip.env.LS_TSMATCH[1]
      local types = return_types_at_cursor()
      local non_err = {}
      for _, type_str in ipairs(types) do
        if type_str ~= "error" then table.insert(non_err, zero_value(type_str, err_var)) end
      end
      local ret_prefix = "if " .. err_var .. " != nil {\n\treturn "
      if #non_err > 0 then ret_prefix = ret_prefix .. table.concat(non_err, ", ") .. ", " end
      return ret_prefix .. 'fmt.Errorf("'
    end, {}),
    i(1, "msg"),
    f(function(_, snip)
      local err_var = snip.env.LS_TSMATCH[1]
      return ': %w", ' .. err_var .. ")\n}"
    end, {}),
  }),
}

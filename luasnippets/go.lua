local ls = require "luasnip"
local f = ls.function_node
local i = ls.insert_node
local tsf = require "luasnip.extras.treesitter_postfix"
local ts_postfix = tsf.treesitter_postfix
local tsnode_matcher = tsf.builtin.tsnode_matcher

-- local s = ls.snippet
-- local sn = ls.snippet_node
-- local t = ls.text_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local l = require("luasnip.extras").lambda
-- local rep = require("luasnip.extras").rep
-- local p = require("luasnip.extras").partial
-- local m = require("luasnip.extras").match
-- local n = require("luasnip.extras").nonempty
-- local dl = require("luasnip.extras").dynamic_lambda
-- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local types = require("luasnip.util.types")
-- local conds = require("luasnip.extras.conditions")
-- local conds_expand = require("luasnip.extras.conditions.expand")

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

local function get_enclosing_func(node)
  local cur = node
  while cur do
    local nt = cur:type()
    if nt == "function_declaration" or nt == "method_declaration" or nt == "func_literal" then return cur end
    cur = cur:parent()
  end
end

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

local function return_types_at_cursor()
  local bufnr = vim.api.nvim_get_current_buf()
  local node = vim.treesitter.get_node { buf = bufnr }
  return get_return_types(get_enclosing_func(node), bufnr)
end

local match_err_node = tsnode_matcher.find_topmost_types { "identifier", "selector_expression" }

return {
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

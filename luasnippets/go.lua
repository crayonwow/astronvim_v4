local ls = require "luasnip"
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local s = ls.snippet

return {
  s(
    "w",
    fmt('fmt.Errorf("{}: %w", {})', {
      i(1, "failed"),
      i(2, "err"),
    })
  ),
}

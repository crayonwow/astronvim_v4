---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"

    opts.debug = true
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- go
      null_ls.builtins.formatting.gofumpt,
      null_ls.builtins.formatting.golines.with {
        args = { "--max-len=120" },
      },
      null_ls.builtins.formatting.goimports_reviser,
      null_ls.builtins.formatting.goimports,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.rustywind,
      null_ls.builtins.formatting.sqlfluff.with {
        extra_args = { "--dialect", "postgres" },
      },
      null_ls.builtins.diagnostics.sqlfluff.with {
        extra_args = { "--dialect", "postgres" },
      },
    })
  end,
}

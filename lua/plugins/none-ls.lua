-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- go
      null_ls.builtins.formatting.gofumpt,
      null_ls.builtins.formatting.goimports_reviser.with {
        args = { "-company-prefixes", "bitbucket.manperi.com", "$FILENAME" },
      },
      null_ls.builtins.formatting.golines,
      --
      -- lua
      null_ls.builtins.formatting.stylua,
      -- python
      -- null_ls.builtins.formatting.autopep8,
      -- rust
      null_ls.builtins.formatting.rustywind,

      null_ls.builtins.diagnostics.sqlfluff.with {
        extra_args = { "--dialect", "mysql" }, -- change to your dialect
      },
    }
    return config -- return final config table
  end,
}

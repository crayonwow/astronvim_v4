---@type LazySpec
return {
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      handlers = {
        -- Suppress automatic registration so none-ls.lua can register with custom args
        sqlfluff = function() end,
        golines = function() end,
        golangci_lint = function() end,
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require "null-ls"
      local h = require "null-ls.helpers"
      local u = require "null-ls.utils"
      opts.debug = true
      opts.sources = require("astrocore").list_insert_unique(opts.sources, {
        -- go
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.golines.with {
          args = { "--max-len", "500" },
        },
        null_ls.builtins.diagnostics.golangci_lint.with {
          cwd = h.cache.by_bufnr(function(params) return u.root_pattern ".golangci.yml"(params.bufname) end),
        },
        -- null_ls.builtins.formatting.goimports_reviser {
        --   args = { "-imports-order", "bitbucket.manperi.com", "$FILENAME" },
        -- },
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
  },
}

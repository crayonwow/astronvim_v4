-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function() require("lsp_signature").setup() end,
  -- },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = false,
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },
  -- You can disable default plugins as follows:
  -- { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },

  -- my plugins
  {
    "tpope/vim-surround",
    event = "BufRead",
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "fredrikaverpil/neotest-golang", -- Installation
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-golang" {
            go_test_args = {
              "-v",
              "-race",
              "-count=1",
              "-timeout=30s",
              "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
            },
          }, -- Apply configuration
        },
        -- See all config options with :h neotest.Config
        discovery = {
          -- Drastically improve performance in ginormous projects by
          -- only AST-parsing the currently opened buffer.
          enabled = true,
          -- Number of workers to parse files concurrently.
          -- A value of 0 automatically assigns number based on CPU.
          -- Set to 1 if experiencing lag.
          concurrent = 1,
        },
        running = {
          -- Run tests concurrently when an adapter provides multiple commands to run.
          concurrent = true,
        },
        summary = {
          -- Enable/disable animation of icons.
          enabled = true,
          animated = true,
        },
      }
    end,
    keys = {
      { "<Leader>t", mode = { "n" }, desc = "Test" },
    },
  },
  -- TODO:
  -- {
  --   "edolphin-ydf/goimpl.nvim",
  --   keys = {
  --     {
  --       "<Leader>im",
  --       mode = { "n" },
  --       function() require("telescope").extensions.goimpl.goimpl {} end,
  --       desc = "Go Impl",
  --     },
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-lua/popup.nvim",
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   config = function() require("telescope").load_extension "goimpl" end,
  -- },
  {
    "leoluz/nvim-dap-go",
    opts = {},
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "jay-babu/mason-nvim-dap.nvim",
        optional = true,
        opts = function(_, opts)
          opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "delve" })
        end,
      },
    },
    config = function()
      require("dap-go").setup {
        dap_configurations = {
          {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
            port = 38697,
            host = "localhost",
          },
        },
        delve = {
          -- the path to the executable dlv which will be used for debugging.
          -- by default, this is the "dlv" executable on your PATH.
          path = "dlv",
          -- time to wait for delve to initialize the debug session.
          -- default to 20 seconds
          initialize_timeout_sec = 20,
          -- a string that defines the port to start delve debugger.
          -- default to string "${port}" which instructs nvim-dap
          -- to start the process in a random available port
          port = 38697,
          -- additional args to pass to dlv
          args = {},
          -- the build flags that are passed to delve.
          -- defaults to empty string, but can be used to provide flags
          -- such as "-tags=unit" to make sure the test suite is
          -- compiled during debugging, for example.
          -- passing build flags using args is ineffective, as those are
          -- ignored by delve in dap mode.
          build_flags = "",
          -- whether the dlv process to be created detached or not. there is
          -- an issue on Windows where this needs to be set to false
          -- otherwise the dlv server creation will fail.
          detached = true,
          -- the current working directory to run dlv from, if other than
          -- the current working directory.
          cwd = nil,
        },
      }
    end,
    keys = {
      { "<Leader>d", mode = { "n" } },
    },
  },
  -- enables ssh yank
  {
    "ibhagwan/smartyank.nvim",
    enabled = true,
    config = function()
      require("smartyank").setup {
        highlight = {
          enabled = false, -- highlight yanked text
        },
      }
    end,
  },
  {
    "andythigpen/nvim-coverage",
    enabled = true,
    config = function() require("coverage").setup {} end,
  },
}

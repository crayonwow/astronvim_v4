-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
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
          require "neotest-golang", -- Registration
        },
      }
    end,
    opts = {
      -- See all config options with :h neotest.Config
      discovery = {
        -- Drastically improve performance in ginormous projects by
        -- only AST-parsing the currently opened buffer.
        enabled = false,
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
        animated = false,
      },
    },
    keys = {
      { "<Leader>t", mode = { "n" }, desc = "Test" },
    },
  },
  {
    "edolphin-ydf/goimpl.nvim",
    keys = {
      {
        "<Leader>im",
        mode = { "n" },
        function() require("telescope").extensions.goimpl.goimpl {} end,
        desc = "Go Impl",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function() require("telescope").load_extension "goimpl" end,
  },
  { "goolord/alpha-nvim", enabled = true },
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
    "tpope/vim-dadbod",
    specs = {
      {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = { "tpope/vim-dadbod" },
        event = "VeryLazy",
      },
      {
        "hrsh7th/nvim-cmp",
        optional = true,
        dependencies = {
          {
            "kristijanhusak/vim-dadbod-completion",
            dependencies = {
              "AstroNvim/astrocore",
              opts = {
                autocmds = {
                  dadbod_cmp = {
                    {
                      event = "FileType",
                      desc = "dadbod completion",
                      pattern = { "sql", "mysql", "plsql" },
                      callback = function()
                        require("cmp").setup.buffer { sources = { { name = "vim-dadbod-completion" } } }
                      end,
                    },
                  },
                },
              },
            },
          },
        },
      },
    },
    cmd = "DBUI",
  },
}

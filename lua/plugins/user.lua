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
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup {
        -- your neotest config here
        adapters = {
          require "neotest-go" {
            runner = "testify",
            experimental = {
              test_table = true,
            },
            args = { "-count=1", "-timeout=30s", "-race" },
          },
          require "neotest-rust",
          require "neotest-python",
        },
      }
    end,
    dependencies = {
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
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
  { "goolord/alpha-nvim", enabled = false },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
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
  },
}

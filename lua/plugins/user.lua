---@type LazySpec
return {
  "nickkadutskyi/jb.nvim",
  {
    "folke/snacks.nvim",
    opts = { dashboard = { enabled = false } },
  },
  {
    "tpope/vim-surround",
    event = "BufRead",
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
  {
    "mistweaverco/kulala.nvim",
    keys = {
      { "<leader>es", desc = "Send request" },
      { "<leader>ea", desc = "Send all requests" },
      { "<leader>eb", desc = "Open scratchpad" },
    },
    ft = { "http", "rest" },
    opts = {
      global_keymaps = true,
      global_keymaps_prefix = "<leader>e",
      kulala_keymaps_prefix = "",
    },
  },
}

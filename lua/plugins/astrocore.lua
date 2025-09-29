-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

local function getMaps()
  local utils = require "astrocore"
  local is_available = utils.is_available
  local get_icon = require("astroui").get_icon

  local maps = {
    n = {
      ["<Leader>a"] = { ":noa w!<cr>", desc = "Save file without formating" },
      ["<Leader>t"] = { desc = "Test" },
      ["<Leader>i"] = { desc = "Utils" },
      ["<Leader>T"] = { desc = get_icon("Terminal", 1, true) .. "Terminal" },
      ["<Leader>tn"] = { function() require("neotest").run.run() end, desc = "Nearest" },
      ["<Leader>tt"] = { function() require("neotest").summary.toggle() end, desc = "Toggle" },
      ["<Leader>to"] = {
        function() require("neotest").output.open { enter = true, auto_close = true, short = true } end,
        desc = "Results",
      },
      ["<C-n>"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
      ["<Leader>e"] = false,
      ["<Leader>o"] = false,
      ["<Leader>tu"] = false,
      ["<Leader>tp"] = false,
      ["<Leader>th"] = false,
      ["<Leader>tf"] = false,
      ["<Leader>tv"] = false,
      gi = { function() require("snacks").picker.lsp_implementations() end, desc = "GoTo implementations" },
      gr = { function() require("snacks").picker.lsp_references() end, desc = "GoTo references" },
      gI = false,
      ["<Leader>td"] = { function() require("dap-go").debug_test() end, desc = "Debug nearest" },
      ["<Leader>tc"] = {
        function() require("coverage").toggle() end,
        desc = "Toggle coverage",
      },
      ["<Leader>tl"] = {
        function() require("coverage").load(false) end,
        desc = "Load coverage",
      },
    },
    t = {},
  }

  if is_available "toggleterm.nvim" then
    maps.n["<Leader>T"] = { desc = " Terminal" }
    if vim.fn.executable "lazygit" == 1 then
      maps.n["<Leader>Tl"] = { function() utils.toggle_term_cmd "lazygit" end, desc = "ToggleTerm lazygit" }
    end
    if vim.fn.executable "node" == 1 then
      maps.n["<Leader>Tn"] = { function() utils.toggle_term_cmd "node" end, desc = "ToggleTerm node" }
    end
    if vim.fn.executable "gdu" == 1 then
      maps.n["<Leader>Tu"] = { function() utils.toggle_term_cmd "gdu" end, desc = "ToggleTerm gdu" }
    end
    if vim.fn.executable "btm" == 1 then
      maps.n["<Leader>Tt"] = { function() utils.toggle_term_cmd "btm" end, desc = "ToggleTerm btm" }
    end
    local python = vim.fn.executable "python" == 1 and "python" or vim.fn.executable "python3" == 1 and "python3"
    if python then
      maps.n["<Leader>Tp"] = { function() utils.toggle_term_cmd(python) end, desc = "ToggleTerm python" }
    end
    maps.n["<Leader>Tf"] = { "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" }
    maps.n["<Leader>Th"] = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal split" }
    maps.n["<Leader>Tv"] = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical split" }
  end
  return maps
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = getMaps(),
  },
}

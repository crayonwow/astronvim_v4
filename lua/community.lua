---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.zig" },
  { import = "astrocommunity.pack.full-dadbod" },

  { import = "astrocommunity.test.neotest" },
  { import = "astrocommunity.test.nvim-coverage" },
  { import = "astrocommunity.lsp.lsp-signature-nvim" },
  { import = "astrocommunity.git.blame-nvim" },

  { import = "astrocommunity.recipes.neo-tree-dark" },
  { import = "astrocommunity.recipes.picker-nvchad-theme" },
  { import = "astrocommunity.recipes.heirline-vscode-winbar" },
  { import = "astrocommunity.recipes.disable-borders" },
  { import = "astrocommunity.recipes.telescope-nvim-snacks" },

  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.colorscheme.rose-pine" },
  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  { import = "astrocommunity.colorscheme.nord-nvim" },
  { import = "astrocommunity.colorscheme.github-nvim-theme" },
  { import = "astrocommunity.colorscheme.lackluster-nvim" },
}

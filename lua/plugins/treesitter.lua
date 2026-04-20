---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      highlight = true,
      indent = true,
      auto_install = true,
      ensure_installed = {
        "lua",
        "vim",
        "go",
        "gomod",
        "gosum",
        "rust",
        "python",
        "yaml",
        "dockerfile",
      },
    },
  },
}

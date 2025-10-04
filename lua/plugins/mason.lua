-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        "biome",
        "delve",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "fixjson",
        "go-debug-adapter",
        "gofumpt",
        "goimports-reviser",
        "golangci-lint",
        "golines",
        "gomodifytags",
        "gopls",
        "helm-ls",
        "impl",
        "json-to-struct",
        "kube-linter",
        "lua-language-server",
        "prettier",
        "sqlfluff",
        "templ",
        "terraform-ls",
        "typescript-language-server",
        "yaml-language-server",
      },
    },
  },
}

---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "biome",
        "delve",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "fixjson",
        "go-debug-adapter",
        "gofumpt",
        "goimports-reviser",
        -- "golangci-lint",
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
        "tree-sitter-cli",
        "typescript-language-server",
        "yaml-language-server",
      },
    },
  },
}

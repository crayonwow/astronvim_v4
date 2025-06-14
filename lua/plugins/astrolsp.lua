-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      signature_help = true,
      autoformat = true, -- enable or disable auto formatting on start
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      --   -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
      },
      --   disabled = { -- disable formatting capabilities for the listed language servers
      --     -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
      --     -- "lua_ls",
      --   },
      timeout_ms = 4000, -- default format timeout
      --   -- filter = function(client) -- fully override the default formatting function
      --   --   return true
      --   -- end
    },
    -- enable servers that you already have installed without mason
    -- servers = {
    --   -- "pyright"
    -- },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
      gopls = {
        settings = {
          gopls = {
            experimentalPostfixCompletions = true,
            verboseOutput = true,
            buildFlags = { "-tags", "integration" },
            staticcheck = false, -- golangci-lint is used instead
            gofumpt = false, -- disabled to prevent conflicts with goimports-reviser
            linksInHover = false,
            -- hints = {
            --   assignVariableTypes = true,
            --   compositeLiteralFields = true,
            --   compositeLiteralTypes = true,
            --   constantValues = true,
            --   functionTypeParameters = true,
            --   parameterNames = true,
            --   rangeVariableTypes = true,
            -- },
            analyses = {
              appends = true,
              asmdecl = true,
              assign = true,
              atomic = true,
              bools = true,
              buildtag = true,
              cgocall = true,
              composites = true,
              copylocks = true,
              deepequalerrors = true,
              defers = true,
              directive = true,
              embed = true,
              errorsas = true,
              fieldalignment = false,
              httpresponse = true,
              ifaceassert = true,
              loopclosure = true,
              lostcancel = true,
              nilfunc = true,
              nilness = true,
              printf = true,
              shadow = true,
              shift = true,
              simplifycompositelit = true,
              simplifyrange = true,
              simplifyslice = true,
              slog = true,
              sortslice = true,
              stdmethods = true,
              stringintconv = true,
              structtag = true,
              tests = true,
              timeformat = true,
              unreachable = true,
              unsafeptr = true,
              unusedresult = true,
              fillreturns = true,
              nonewvars = true,
              noresultvalues = true,
              undeclaredname = true,
              fillstruct = true,
              infertypeargs = true,
              stubmethods = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
              unusedvariable = true,
            },
          },
        },
      },
    },
    -- customize how language servers are attached
    -- handlers = {
    --   -- ["textDocument/hover"] = vim.lsp.with(vim.lsphandlers.hover, {
    --   --   border = false,
    --   -- }),
    --   -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
    --   -- function(server, opts) require("lspconfig")[server].setup(opts) end
    --
    --   -- the key is the server that is being setup with `lspconfig`
    --   -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
    --   -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
    -- },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_document_highlight = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/documentHighlight",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "CursorHold", "CursorHoldI" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Document Highlighting",
          callback = function() vim.lsp.buf.document_highlight() end,
        },
        {
          event = { "CursorMoved", "CursorMovedI", "BufLeave" },
          desc = "Document Highlighting Clear",
          callback = function() vim.lsp.buf.clear_references() end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        -- gD = {
        --   function() vim.lsp.buf.declaration() end,
        --   desc = "Declaration of current symbol",
        --   cond = "textDocument/declaration",
        -- },
        -- ["<Leader>uY"] = {
        --   function() require("astrolsp.toggles").buffer_semantic_tokens() end,
        --   desc = "Toggle LSP semantic highlight (buffer)",
        --   cond = function(client) return client.server_capabilities.semanticTokensProvider and vim.lsp.semantic_tokens end,
        -- },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = "InsertEnter",
    opts = function(_, opts)
      local utils = require "astrocore"
      local is_available = utils.is_available
      local cmp = require "cmp"
      local snip_status_ok, luasnip = pcall(require, "luasnip")
      local copilot_avaliable = is_available "copilot.suggestion"
      local copilot_status_ok, copilot = pcall(require, "copilot.suggestion")

      if copilot_avaliable then
        opts.mapping["<C-a>"] = cmp.mapping(function()
          if copilot.is_visible() then copilot.next() end
        end)
        opts.mapping["<C-a>"] = cmp.mapping(function()
          if copilot.is_visible() then copilot.next() end
        end)
        opts.mapping["<C-s>"] = cmp.mapping(function()
          if copilot.is_visible() then copilot.prev() end
        end)
        opts.mapping["<C-j>"] = cmp.mapping(function()
          if copilot.is_visible() then copilot.accept_line() end
        end)
      end
      opts.mapping["<C-l>"] = cmp.mapping(function()
        if copilot_avaliable and copilot_status_ok and copilot.is_visible() then
          copilot.accept_word()
        elseif luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end)

      opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
        if copilot_avaliable and copilot_status_ok and copilot.is_visible() then
          copilot.accept()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" })

      if not snip_status_ok then return end

      opts.mapping["<C-h>"] = cmp.mapping(function()
        if luasnip.choice_active() then luasnip.change_choice(1) end
      end)

      opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" })

      opts.window = {}

      return opts
    end,
  },
}

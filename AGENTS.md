# AGENTS.md

## Framework

This is an **AstroNvim v6 template** built on `lazy.nvim`. Do not treat it as a from-scratch config.
AstroNvim provides the base plugin set, LSP scaffolding, keymaps, and UI. All user customization
extends AstroNvim's abstractions via `opts` merging.

Entry point: `init.lua` → bootstraps lazy.nvim → `require "lazy_setup"` → `require "polish"`.

## Directory layout

```
lua/
  lazy_setup.lua   # lazy.nvim setup; loads AstroNvim → community → plugins
  community.lua    # astrocommunity imports (packs, recipes, colorschemes)
  polish.lua       # post-setup hook — DISABLED (see below)
  plugins/         # one file per concern; all auto-loaded by lazy.nvim
```

No `after/`, `ftplugin/`, or `plugin/` directories exist. Everything routes through lazy.nvim specs.

## Plugin customization convention

Files in `lua/plugins/` reference the **exact upstream plugin name** (e.g. `"AstroNvim/astrocore"`)
so lazy.nvim deep-merges `opts` rather than defining a new plugin. Never change the plugin name
when extending an existing plugin — that creates a duplicate instead of a merge.

To add a new astrocommunity pack, add it to `lua/community.lua`, not `lua/plugins/`.

## `polish.lua` is always disabled

```lua
if true then return end  -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
```

This guard is intentional (AstroNvim template convention). Remove that line to activate the file.

## Treesitter parsers are configured via `astrocore`

`lua/plugins/treesitter.lua` sets `ensure_installed` through `AstroNvim/astrocore` opts, not
directly on `nvim-treesitter`. Follow the same pattern when adding parsers.

## Lua toolchain

| Tool | Config | Notes |
|------|--------|-------|
| StyLua | `.stylua.toml` | 120 col, 2-space indent, double quotes, no call parens |
| Selene | `selene.toml` + `neovim.yml` | `std = "neovim"`; `neovim.yml` is Selene stdlib config, not CI |

Run manually before committing:
```sh
stylua lua/
selene lua/
```

## No CI, no task runner, no tests

There are no GitHub Actions workflows, Makefile, or test suite for the config itself. Changes take
effect on the next Neovim launch (or `:Lazy reload <plugin>`).

## Machine-specific path

`lua/plugins/astrolsp.lua` hardcodes the elixir-ls binary path:
`/Users/s1kai/.local/share/nvim/mason/bin/elixir-ls`

Update this if working on a different machine.

## Leader keys

- `<Space>` = `mapleader`
- `,` = `maplocalleader`

Set in `lua/lazy_setup.lua` before lazy loads.

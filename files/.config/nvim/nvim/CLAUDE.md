# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a minimal Neovim configuration using Lua, built around lazy.nvim plugin manager with automatic bootstrapping. The configuration follows a modular structure separating core settings from plugin configurations.

**Entry Point**: `init.lua` - Minimal bootstrap that loads core modules from `lua/config/`

**Core Structure**:
- `lua/config/` - Core configuration modules (settings, keymaps, lazy.lua, autocommands)
- `lua/plugins/` - Individual plugin configurations with lazy-loading specifications
- Plugin definitions use return tables for lazy.nvim with `config` functions for setup

## User Design Philosophy

This configuration prioritizes:
1. **Minimal & Controlled** - User explicitly controls popups and interruptions
2. **Community Standard** - Uses widely-accepted, non-controversial keybindings  
3. **Value-Driven** - Only includes packages that add clear coding value

## Key Commands

**Code Formatting**:
```bash
stylua . --check          # Check Lua formatting
stylua .                  # Format all Lua files
```

**Plugin Management** (within Neovim):
- `:Lazy` - Open plugin manager UI
- `:Lazy sync` - Update all plugins
- `:Lazy clean` - Remove unused plugins

## Configuration Patterns

**Plugin Structure**: Each plugin file in `lua/plugins/` returns a table with lazy.nvim specification:
```lua
return {
  "plugin/repo",
  config = function()
    -- setup code
  end,
  -- lazy loading options
}
```

**Keymaps**: Leader key is `<space>`. Core mappings in `lua/config/keymaps.lua`, plugin-specific mappings in respective plugin configs.

**Settings**: Editor options centralized in `lua/config/settings.lua` using `vim.opt.*` API.

## Key Integrations

- **Telescope**: Primary file finder/searcher with `<leader>s*` keybindings (sf=files, sg=grep, sn=nvim config, sy=symbols)
- **Oil.nvim**: File manager accessible with `-` key
- **Rose Pine**: Colorscheme with automatic theme switching (moon=dark, dawn=light)
- **Auto-dark-mode**: Automatically switches colorscheme based on macOS system appearance
- **LSP + Mason**: Language servers for TypeScript, Python, JSON, YAML, Go, Java with `gr*` keybindings (grn=rename, gra=action, grr=references)
- **Blink.cmp**: Completion engine with snippet support
- **Conform.nvim**: Code formatting with `<leader>f` and format-on-save
- **Gitsigns**: Git integration with line-level changes
- **Which-key**: Keymap discovery and hints
- **Hardtime**: Vim habits trainer for muscle memory
- **Guess-indent**: Auto-detection of indentation patterns

## Development Notes

- Self-bootstrapping setup - lazy.nvim installs automatically on first run
- Configuration changes require `:source %` or Neovim restart
- Plugin changes auto-detected by lazy.nvim
- Uses modern Lua APIs throughout (no Vimscript compatibility layer)
- Format-on-save enabled for supported filetypes
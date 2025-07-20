# Neovim Configuration

A minimal, modern Neovim configuration built with Lua and the lazy.nvim plugin manager.

## Overview

This configuration prioritizes simplicity, community standards, and value-driven plugin selection. It provides a solid foundation for development work while remaining lightweight and focused.

## Philosophy

- **Minimal & Controlled**: Explicit control over popups and interruptions
- **Community Standard**: Uses widely-accepted, non-controversial keybindings
- **Value-Driven**: Only includes plugins that add clear coding value

## Structure

```
.
├── init.lua              # Entry point - loads core modules
├── lua/
│   ├── config/          # Core configuration
│   │   ├── settings.lua # Editor options and preferences
│   │   ├── keymaps.lua  # Key mappings and shortcuts
│   │   ├── lazy.lua     # Plugin manager bootstrap
│   │   └── autocommands.lua
│   └── plugins/         # Plugin configurations
│       ├── telescope.lua    # File finder/searcher
│       ├── lsp.lua         # Language server setup
│       ├── completion.lua  # Code completion
│       ├── formatting.lua  # Code formatting
│       ├── rose-pine.lua   # Colorscheme
│       └── ...
├── lazy-lock.json       # Plugin version lockfile
└── stylua.toml         # Lua formatter config
```

## Key Features

### Core Functionality
- **Leader key**: `<space>`
- **Line numbers**: Relative numbering enabled
- **Smart indentation**: 4 spaces, auto-detection
- **Split navigation**: `<C-hjkl>` for window movement
- **Clipboard integration**: System clipboard sync
- **Undo persistence**: Persistent undo history

### Plugin Highlights
- **Telescope**: Fuzzy finder for files, grep, symbols (`<leader>s*`)
- **LSP + Mason**: Language server support with auto-install
- **nvim-cmp**: Intelligent code completion with snippets
- **Copilot**: AI-powered code suggestions
- **Treesitter**: Advanced syntax highlighting
- **Conform.nvim**: Code formatting with format-on-save
- **Rose Pine**: Beautiful colorscheme with auto dark/light mode
- **Gitsigns**: Git integration with line-level changes
- **Which-key**: Keymap discovery and hints

## Installation

1. Backup existing Neovim config:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. Clone this configuration:
   ```bash
   git clone <repo-url> ~/.config/nvim
   ```

3. Start Neovim - plugins will install automatically:
   ```bash
   nvim
   ```

## Key Bindings

### Leader Mappings (`<space>`)
- `<leader>s*` - Search (files, grep, symbols, nvim config)
- `<leader>f` - Format current buffer
- `<leader>gr*` - LSP actions (rename, references, actions)
- `<leader>t*` - Toggle options (numbers, wrap, spell, etc.)
- `<leader>w*` - Window operations (split, close, resize)
- `<leader>b*` - Buffer management (delete, next, previous)

### Navigation
- `<C-hjkl>` - Move between windows
- `[d` / `]d` - Previous/next diagnostic
- `-` - Open file manager

### Other
- `<Esc>` - Clear search highlights
- `<Esc><Esc>` - Exit terminal mode (in terminal)

## Plugin Management

- `:Lazy` - Open plugin manager UI
- `:Lazy sync` - Update all plugins
- `:Lazy clean` - Remove unused plugins

## Code Formatting

```bash
stylua . --check    # Check Lua formatting
stylua .           # Format all Lua files
```

## Customization

This configuration is designed to be easily customizable:

1. **Settings**: Modify `lua/config/settings.lua` for editor options
2. **Keymaps**: Add/modify mappings in `lua/config/keymaps.lua`
3. **Plugins**: Add new plugin files to `lua/plugins/`
4. **LSP**: Configure language servers in `lua/plugins/lsp.lua`

Each plugin configuration follows the lazy.nvim specification pattern:
```lua
return {
  "plugin/repo",
  config = function()
    -- setup code
  end,
  -- lazy loading options
}
```

## Requirements

- Neovim >= 0.9.0
- Git
- A Nerd Font (optional but recommended)
- Language servers will be installed automatically via Mason

## Notes

- Self-bootstrapping setup - lazy.nvim installs automatically
- Plugin changes are auto-detected by lazy.nvim
- Configuration changes require `:source %` or Neovim restart
- Uses modern Lua APIs throughout (no Vimscript)
- Format-on-save enabled for supported filetypes
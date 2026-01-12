# Zed Editor Specification

Configuration aligned with Neovim IDE spec: lean, agent-first, minimal chrome.

## Implementation Status

### Settings (`settings.json`)

| Feature | Status | Setting |
|---------|--------|---------|
| Rose Pine theme (system sync) | ✅ Done | `theme.mode: "system"` |
| Vim mode | ✅ Done | `vim_mode: true` |
| No AI completions/ghost text | ✅ Done | `edit_prediction_provider: "none"` |
| Manual completion trigger only | ✅ Done | `show_completions_on_input: false` |
| No inlay hints | ✅ Done | `inlay_hints.enabled: false` |
| Soft wrap globally | ✅ Done | `soft_wrap: "editor_width"` |
| Center cursor on search | ✅ Done | `center_on_match: true` |
| Relative line numbers | ✅ Done | `relative_line_numbers: "enabled"` |
| Scroll offset 10 lines | ✅ Done | `vertical_scroll_margin: 10` |
| No breadcrumbs | ✅ Done | `toolbar.breadcrumbs: false` |
| Terminal button hidden | ✅ Done | `terminal.button: false` |
| Git inline blame disabled | ✅ Done | `git.inline_blame.enabled: false` |
| Format on save | ✅ Done | `format_on_save: "on"` |
| Python LSP (ty) | ✅ Done | `languages.Python.language_servers: ["ty", ...]` |

### Keybindings (`keymap.json`)

| Keybind | Action | Status |
|---------|--------|--------|
| `d`/`x`/`c` | Black hole register (don't overwrite clipboard) | ✅ Done |
| `<leader>x` | Close buffer | ✅ Done |
| `<leader>q` | Close all items in pane | ✅ Done |
| `<leader>o` | Close inactive tabs/panes | ✅ Done |
| `<leader>r` | Rename symbol | ✅ Done |
| `<leader>a` | Code actions | ✅ Done |
| `<leader>F` | Format | ✅ Done |
| `<leader>d` | Diagnostics panel | ✅ Done |
| `]d` / `[d` | Next/prev diagnostic | ✅ Done |
| `<leader>ff` | File finder | ✅ Done |
| `<leader>fg` | Project search | ✅ Done |
| `<leader>fb` | Buffer/tab switcher | ✅ Done |
| `<leader>sr` | Select all matches | ✅ Done |
| `]q` / `[q` | Next/prev search match | ✅ Done |
| `<leader>gg` | Open lazygit | ✅ Done |

### Tasks (`tasks.json`)

| Task | Status |
|------|--------|
| lazygit | ✅ Done |

---

## Neovim Sync Changes

Changes made to keep Neovim config in sync:

| Change | File |
|--------|------|
| Switched Python LSP from `pyright` to `ty` | `lsp.lua` |
| Format on save already enabled | `formatting.lua` |

**Note**: `ty` must be installed separately via `mise` or `pipx`:
```bash
# via mise
mise use -g ty

# or via pipx  
pipx install ty
```

---

## Features Not Available in Zed

| Neovim Feature | Zed Limitation |
|----------------|----------------|
| Persistent undo (`undofile`) | Not supported |
| Todo highlighting (TODO, FIXME) | No built-in support |
| render-markdown.nvim prettification | Basic preview only |
| which-key discovery | Use command palette |
| Smooth scroll animation customization | Native scrolling |

---

## Files Modified

- `.config/zed/settings.json` — core settings
- `.config/zed/keymap.json` — keybindings with leader maps + black hole register
- `.config/zed/tasks.json` — lazygit task (new)
- `.config/nvim/lua/plugins/lsp.lua` — switched to ty for Python

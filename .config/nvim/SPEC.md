# Neovim IDE Specification

A minimal, agent-aware Neovim configuration designed for use alongside coding agent TUIs (Amp Code, Claude Code).

## Philosophy

- **Lean and fast**: Only bring in what's absolutely needed. IDE should get out of the way.
- **Agent-first workflow**: Neovim handles editing; agents handle AI-powered tasks.
- **Passive awareness**: Trust external tools, don't fight for control.
- **Graceful degradation**: Errors shouldn't break the editor.

---

## Core Behavior

### Startup & Sessions
- Start fresh on every launch (no automatic session restore)
- Manual session save/load per project (on-demand)
- Startup budget: <400ms acceptable
- Graceful error handling: display errors but remain functional

### Buffer & Window Management
- Single-buffer focus with fast switching (primary mode)
- Vertical (side-by-side) splits only, max 2 splits
- Ephemeral splits: close after use
- Aggressive buffer cleanup: close unused buffers automatically
- Keybinds for buffer/window management:
  - `<leader>x` — close buffer
  - `<leader>q` — close window
  - `<leader>o` — only this window

### File Handling
- **Large files** (>1MB): Disable treesitter, LSP for performance
- **Binary files**: Show "binary file" message, don't attempt to render
- **Undo**: Persistent across sessions (`undofile = true`), reasonable depth

---

## Agent Integration

### External Change Handling
- **Passive awareness**: Auto-reload files changed externally (trust the agent)
- No conflict detection or merge prompts
- If buffer has unsaved changes and agent modifies file: do nothing (let agent handle)
- Review workflow handled externally via `git diff`

### AI Completion
- **No in-editor AI** (no Copilot, Codeium, ghost text)
- AI interactions contained to agent TUIs
- LSP completions only, manual trigger (`<C-Space>`)

---

## Language Support

### Languages
- TypeScript/JavaScript
- Python
- SQL (with LSP)
- Markdown
- HTML/CSS (no Emmet)
- YAML/JSON
- Lua (for Neovim config)

### Tool Management (Hybrid Approach)
- **Mason**: LSP servers (version rarely matters)
  - Auto-install on startup
  - Explicit list of servers to install
- **mise**: Formatters and linters (version affects output, reproducibility matters)
  - Prompt user to install when missing tool detected
  - Project-specific versions via `.tool-versions` or `mise.toml`

### Project Configuration
- Auto-detect standard config files (`.eslintrc`, `pyproject.toml`, `biome.json`, etc.)
- Use appropriate tool per project automatically
- No per-project Neovim overrides needed

### LSP Servers (Mason)
| Language | Server |
|----------|--------|
| TypeScript/JavaScript | ts_ls |
| Python | pyright |
| JSON | jsonls |
| YAML | yamlls |
| SQL | sqlls or sqls |
| Lua | lua_ls |

### Formatters/Linters (mise)
| Tool | Languages |
|------|-----------|
| prettierd | JS, TS, HTML, CSS, JSON, YAML, MD |
| ruff | Python |
| stylua | Lua |
| biome | JS, TS (when project uses it) |
| eslint | JS, TS (when project uses it) |

---

## Completion

### Behavior
- **Manual trigger only** (`<C-Space>`)
- No auto-popup (`autocomplete = false`)
- Ghost text enabled for preview
- No snippets in completion menu

### Sources (priority order)
1. LSP
2. Path
3. Buffer

### Keybindings
- `<C-Space>` — trigger completion
- `<C-n>` / `<C-p>` — navigate items
- `<C-y>` — confirm selection
- `<C-e>` — abort

---

## Diagnostics

### Display
- `virtual_text = false` (no inline text at end of lines)
- Underline squiggles enabled (error/warning indicators)
- Float on cursor hold (show diagnostic when paused on line)
- Diagnostics count in statusline

### Navigation
- `[d` / `]d` — previous/next diagnostic
- Unified diagnostics panel (all errors from LSP, linters combined)
- Access via keybind (e.g., `<leader>d`)

---

## Navigation

### File Navigation
- **Neo-tree**: Tree navigator for visual hierarchy
- **Telescope**: Fuzzy finder for fast file jumping
- Both are primary tools (no preference, use situationally)

### Quickfix Navigation
- `]q` / `[q` — next/previous quickfix item
- Project-wide search populates quickfix

### Search & Replace
- Project-wide search/replace via Telescope + Spectre (or similar)
- In-editor, not delegated to agents

### No Bookmarking
- Marks/harpoon not needed
- Rely on fuzzy finding and tree navigation

---

## Git Integration

### Visual Indicators
- Gitsigns for sign column diff indicators only
- No hunk staging or inline blame needed

### Operations
- **lazygit** for all git operations:
  - Merge/rebase conflict resolution (VSCode-style accept current/incoming/both)
  - Staging, commits, log browsing
  - Interactive rebase
- Launch lazygit from Neovim via keybind (e.g., `<leader>gg`)

---

## User Interface

### Colorscheme
- **Rose Pine** (definitive choice)
- Variants: dawn (light), moon (dark)
- Sync with system theme via auto-dark-mode

### Statusline
Display:
- Git branch
- File path
- LSP status (active/inactive)
- Diagnostics count (errors, warnings)
- Cursor position (line:column)

Implementation: lualine.nvim or mini.statusline (lean)

### Chrome
- No breadcrumbs/winbar
- No toast notifications (nvim-notify disabled)
- Silent LSP progress (fidget.nvim for subtle statusline indication, or remove)
- Sign column always visible

### Scrolling & Motion
- Smooth scrolling (animated)
- Center cursor line on jump (search, `gg`, `G`)

---

## Terminal

- **No in-editor terminal**
- Use external terminal pane (Ghostty)
- Neovim's `:terminal` not used

---

## Keybindings

### Leader
- `<Space>` as leader and local leader

### Philosophy
- Learn and internalize vim motions (still learning)
- which-key for comprehensive discoverability
- which-key should show both custom and built-in vim motions

### Window/Buffer
| Keybind | Action |
|---------|--------|
| `<C-h/j/k/l>` | Navigate windows |
| `<leader>x` | Close buffer |
| `<leader>q` | Close window |
| `<leader>o` | Only this window |

### LSP
| Keybind | Action |
|---------|--------|
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover documentation |
| `<leader>r` | Rename |
| `<leader>a` | Code action |
| `<leader>F` | Format |

### Diagnostics
| Keybind | Action |
|---------|--------|
| `[d` / `]d` | Previous/next diagnostic |
| `<leader>d` | Open diagnostics panel |

### Git
| Keybind | Action |
|---------|--------|
| `<leader>gg` | Open lazygit |

### Quickfix
| Keybind | Action |
|---------|--------|
| `]q` / `[q` | Next/previous quickfix |

### Search
| Keybind | Action |
|---------|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>sr` | Search and replace (project-wide) |

---

## Editing Behavior

### Clipboard
- System clipboard integration
- **Only yank (`y`) syncs to clipboard**
- Delete (`d`, `x`, `c`) uses black hole register (doesn't overwrite clipboard)

### Indentation
- Auto-detect tabs vs spaces per file (guess-indent)
- Default: 4 spaces

### Pairs & Comments
- Autopairs enabled (auto-close brackets, quotes)
- Native commenting (Neovim 0.10+): `gcc`, `gc` + motion

### Text Display
- Relative line numbers
- Soft wrap for long lines (no hard wrap)
- No spell checking
- Scroll offset: 10 lines

### Mouse
- Enabled as backup input method

---

## Markdown

### Editing
- Raw editing (no live preview by default)
- Soft wrap enabled

### Prettification (render-markdown.nvim)
- In-buffer styling:
  - Tables aligned and styled
  - Headers visually distinct
  - Checkboxes rendered
  - Code blocks highlighted
- Toggle between raw and prettified mode

### Mermaid Diagrams
- Edit mode: Syntax-highlighted code only
- Preview mode: Browser preview via markdown-preview.nvim
- Keybind to launch browser preview (e.g., `<leader>mp`)

---

## Additional Features

### Todo Highlighting
- Keep todo-comments.nvim
- Highlight `TODO:`, `FIXME:`, `HACK:`, etc.

### Neovim Config Editing
- Lua LSP (lua_ls) active for `.config/nvim/**/*.lua`
- Auto-reload config on save

---

## Plugins Summary

### Keep (from current config)
- lazy.nvim (plugin manager)
- neo-tree.nvim (file tree)
- telescope.nvim (fuzzy finder)
- gitsigns.nvim (git indicators only)
- rose-pine (colorscheme)
- auto-dark-mode.nvim (theme sync)
- which-key.nvim (keybind discovery)
- guess-indent.nvim (indent detection)
- nvim-autopairs (bracket pairing)
- todo-comments.nvim (todo highlighting)
- treesitter (syntax highlighting)
- mason.nvim + mason-lspconfig (LSP server management)
- nvim-lspconfig (LSP configuration)
- conform.nvim (formatting)
- lualine.nvim or mini.statusline (statusline)
- fidget.nvim (LSP progress, subtle)

### Add
- lazygit.nvim (git operations)
- render-markdown.nvim (markdown prettification)
- markdown-preview.nvim (browser preview for mermaid)
- nvim-spectre (project-wide search/replace)
- Smooth scrolling plugin (neoscroll.nvim or similar)
- SQL LSP support (sqlls or sqls)

### Remove/Reduce
- nvim-cmp: Simplify to LSP + path + buffer only, remove snippets
- LuaSnip: Remove (no snippets)
- dap.nvim: Remove (aspirational, not used)
- fidget.nvim: Keep minimal or remove if statusline sufficient
- comment.nvim: Remove (use native Neovim 0.10+ commenting)
- mini-ai.lua: Evaluate if needed
- mini.lua: Evaluate what's used

### Commit to Dotfiles
- `lazy-lock.json` (plugin version pinning)

---

## Non-Goals

- In-editor AI completion (Copilot, Codeium)
- DAP debugging (use agent interaction + print debugging)
- In-editor terminal
- Multi-cursor editing
- Complex session management
- Emmet expansion
- Spell checking
- Breadcrumbs/winbar
- Toast notifications

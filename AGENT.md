# AGENT.md

This file provides coding assistance guidance for this dotfiles repository.

## Commands

### Dotfiles Management
- Install: `./install.sh` (uses GNU Stow to create symlinks from repo root)
- Uninstall: `./uninstall.sh` (removes symlinks, restores backups)
- Manual: `cd .. && stow dotfiles` (create) / `stow -D dotfiles` (remove)
- Package Management: `brew bundle` (install from Brewfile), `brew bundle dump --force` (update Brewfile)

### Testing/Validation
- Check symlinks: `ls -la ~/ | grep ' -> '` and `ls -la ~/.config/ | grep ' -> '`
- No formal test suite - validation is manual inspection of symlinks

## Architecture

**Structure**: Dotfiles repo with GNU Stow-based installation
- Dotfiles stored directly in repo root (no nested directories)
- `.config/`: Contains Neovim config with modular Lua setup  
- `install.sh`: Uses GNU Stow for symlink management
- `Brewfile`: Package management via Homebrew
- Backup system: Creates timestamped backup directory before symlinking

**Key Components**: Shell config (.zshrc), Neovim setup, Git config, development tools (gh, docker, ripgrep, fd)

## Code Style

**Shell Scripts**: Use bash with `set -e`, colored output, comprehensive error handling
**File Organization**: Mirror home directory structure in files/, use .config/ for XDG-compliant configs
**Symlinking**: Individual file links (not directory links), preserve exact paths, always backup existing files

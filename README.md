# Dotfiles

My personal dotfiles with optimized performance and safe symlinking.

## Installation

To install these dotfiles:

```bash
git clone https://github.com/sagarvxyz/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

This creates symlinks from the `files/` directory to your home directory, backing up any existing files.

### Options

- `./install.sh --dry-run` - Preview changes without making them
- `./uninstall.sh` - Remove all symlinks and restore backups
- `./restore.sh <file>` - Restore a specific file from backup

### Examples

```bash
# Preview installation
./install.sh --dry-run

# Install dotfiles
./install.sh

# Restore just .zshrc from backup
./restore.sh .zshrc

# Restore nvim config from specific backup
./restore.sh .config/nvim ~/.dotfiles_backup_20240120123456
```

## Included Configurations

- **Shell**: Zsh with lazy-loaded NVM and completions
- **Editor**: Neovim config with modular Lua setup
- **Terminal**: Ghostty and Zed configurations
- **Git**: Global gitconfig and gitignore
- **Amp Code**: CLI settings and command allowlist

## Performance Features

- **Fast shell startup**: NVM and completions are lazy-loaded
- **Smart compinit**: Only regenerates cache when needed
- **Minimal blocking**: Heavy tools load on first use

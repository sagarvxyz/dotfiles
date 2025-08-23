# Dotfiles

My personal dotfiles managed with GNU Stow for simple symlink management.

## Installation

To install these dotfiles:

```bash
git clone https://github.com/sagarvxyz/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
brew bundle  # Install dependencies including stow
./install.sh
```

This uses GNU Stow to create symlinks from the repo root to your home directory, backing up any existing files.

### Options

- `./install.sh` - Install dotfiles with automatic backup
- `./uninstall.sh` - Remove all symlinks and restore backups
- `cd .. && stow dotfiles` - Manual stow 
- `cd .. && stow -D dotfiles` - Manual unstow

### Examples

```bash
# Install dotfiles
./install.sh

# Uninstall and restore backups
./uninstall.sh

# Manual stow operations
cd ~/.dotfiles/..
stow dotfiles        # Create symlinks
stow -D dotfiles     # Remove symlinks
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

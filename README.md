# Personal Dotfiles

Personal dotfiles managed with GNU Stow.

## Installation

```bash
git clone https://github.com/sagarvxyz/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
brew bundle  # Install dependencies including stow
./install.sh
```

## Management

- `./install.sh` - Install dotfiles with automatic backup
- `./uninstall.sh` - Remove all symlinks and restore backups

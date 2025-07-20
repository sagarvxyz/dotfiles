# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository containing shell configurations, Neovim setup, and development environment preferences. The repository uses symlinks for installation and Homebrew for package management.

## Installation

### Quick Start
```bash
# Clone the repository
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles

# Install dotfiles (creates symlinks)
./install.sh

# Install packages via Homebrew
brew bundle
```

### Uninstallation
```bash
# Remove symlinks and restore backups
./uninstall.sh
```

## Architecture

### Configuration Structure
- **files/**: Contains all dotfiles that will be symlinked to home directory
  - **Shell Configuration**: `.zshrc` contains PATH setup, git aliases, and NVM configuration
  - **Neovim Configuration**: Located in `files/.config/nvim/` with a modular Lua-based setup:
    - `init.lua`: Entry point that loads config modules
    - `lua/config/`: Core configuration (keymaps, settings, autocommands, lazy.nvim)
    - `lua/plugins/`: Individual plugin configurations
- **install.sh**: Creates symlinks for all files in `files/` directory
- **uninstall.sh**: Removes symlinks and restores backups
- **Package Management**: `Brewfile` defines all CLI tools and applications to install

### Symlink Behavior
- Creates individual file symlinks (not directory symlinks)
- Preserves exact file paths from `files/` to home directory
- Backs up existing files before creating symlinks
- Only replaces managed files, preserves other files in directories

### Key Tools and Dependencies
- **Package Manager**: Homebrew (managed via Brewfile)
- **Version Manager**: mise (for multiple language runtimes)
- **Editor**: Neovim with lazy.nvim plugin manager
- **Terminal**: Ghostty with custom configuration
- **Development Tools**: GitHub CLI, Docker, ripgrep, fd

## Common Commands

### Dotfiles Management
```bash
# Install dotfiles (create symlinks)
./install.sh

# Uninstall dotfiles (remove symlinks, restore backups)
./uninstall.sh

# Check symlink status
ls -la ~/ | grep ' -> '
ls -la ~/.config/ | grep ' -> '
```

### Package Management
```bash
# Install all packages defined in Brewfile
brew bundle

# Update Brewfile with currently installed packages
brew bundle dump --force
```

### Neovim Plugin Management
Neovim uses lazy.nvim as the plugin manager. Plugins are automatically installed on first launch.

### Git Aliases (from .zshrc)
- `gl` - git pull --prune
- `gc` - git commit
- `gca` - git commit -a
- `gco` - git checkout
- `gb` - git branch
- `gs` - git status -sb
- `gac` - git add -A && git commit -m
- `gz` - git undo
- `gbp` - git branch-prune

## Development Environment
- Uses NVM for Node.js version management
- PATH includes Homebrew binaries and local bin directories
- Supports local environment overrides via `.localrc` and `.zshenv`
#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Installing dotfiles using GNU Stow...${NC}"

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo -e "${RED}Error: GNU Stow is not installed${NC}"
    echo -e "${YELLOW}Install it with: brew install stow${NC}"
    exit 1
fi

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create backup directory if files would be overwritten
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d%H%M%S)"

# Check for conflicts and backup existing files
echo -e "${BLUE}Checking for conflicts...${NC}"
CONFLICTS=false

# List of dotfiles to stow (exclude git, scripts, and other repo files)
DOTFILES=(.bashrc .gitconfig .gitignore_global .zprofile .zshrc Brewfile)

# List of .config subdirectories to individually symlink
CONFIG_DIRS=(nvim ghostty zed)

for dotfile in "${DOTFILES[@]}"; do
    target_path="$HOME/$dotfile"
    
    if [[ -e "$target_path" && ! -L "$target_path" ]]; then
        if [[ "$CONFLICTS" == "false" ]]; then
            mkdir -p "$BACKUP_DIR"
            echo -e "${YELLOW}Backing up existing files to $BACKUP_DIR${NC}"
            CONFLICTS=true
        fi
        
        # Create backup directory structure  
        mkdir -p "$(dirname "$BACKUP_DIR/$dotfile")"
        cp -R "$target_path" "$BACKUP_DIR/$dotfile"
        echo -e "${YELLOW}  Backed up: $target_path${NC}"
        rm -rf "$target_path"
    fi
done

# Handle .config directory specially - create individual symlinks
mkdir -p "$HOME/.config"
for config_dir in "${CONFIG_DIRS[@]}"; do
    target_path="$HOME/.config/$config_dir"
    source_path="$DOTFILES_DIR/.config/$config_dir"
    
    if [[ -e "$target_path" && ! -L "$target_path" ]]; then
        if [[ "$CONFLICTS" == "false" ]]; then
            mkdir -p "$BACKUP_DIR"
            echo -e "${YELLOW}Backing up existing files to $BACKUP_DIR${NC}"
            CONFLICTS=true
        fi
        
        mkdir -p "$BACKUP_DIR/.config"
        cp -R "$target_path" "$BACKUP_DIR/.config/$config_dir"
        echo -e "${YELLOW}  Backed up: $target_path${NC}"
        rm -rf "$target_path"
    fi
    
    ln -s "$source_path" "$target_path"
    echo -e "${GREEN}  Linked: ~/.config/$config_dir -> $source_path${NC}"
done

# Use stow to create symlinks for non-.config files
cd "$(dirname "$DOTFILES_DIR")"
stow "$(basename "$DOTFILES_DIR")" --ignore='\.git' --ignore='\.DS_Store' --ignore='README\.md' --ignore='AGENT\.md' --ignore='install\.sh' --ignore='uninstall\.sh' --ignore='\.config'

echo -e "${GREEN}Dotfiles installation complete!${NC}"
if [[ "$CONFLICTS" == "true" ]]; then
    echo -e "${BLUE}Original files backed up to: $BACKUP_DIR${NC}"
fi

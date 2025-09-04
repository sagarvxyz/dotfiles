#!/bin/bash
set -e

echo -e "Installing dotfiles using GNU Stow..."

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo -e "Error: GNU Stow is not installed"
    echo -e "Install it with: brew install stow"
    exit 1
fi

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create backup directory if files would be overwritten
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d%H%M%S)"

# Check for conflicts and backup existing files
echo -e "Checking for conflicts..."
CONFLICTS=false

# List of dotfiles to stow (exclude git, scripts, and other repo files)
DOTFILES=(.bashrc .gitconfig .gitignore_global .zprofile .zshrc Brewfile)

# List of .config subdirectories to individually symlink
CONFIG_DIRS=(nvim ghostty mise amp zed)

# List of individual .config files to symlink
CONFIG_FILES=(starship.toml)

for dotfile in "${DOTFILES[@]}"; do
    target_path="$HOME/$dotfile"

    if [[ -e "$target_path" && ! -L "$target_path" ]]; then
        if [[ "$CONFLICTS" == "false" ]]; then
            mkdir -p "$BACKUP_DIR"
            echo -e "Backing up existing files to $BACKUP_DIR"
            CONFLICTS=true
        fi

        # Create backup directory structure
        mkdir -p "$(dirname "$BACKUP_DIR/$dotfile")"
        cp -R "$target_path" "$BACKUP_DIR/$dotfile"
        echo -e "  Backed up: $target_path"
        rm -rf "$target_path"
    fi
done

# Handle .config directory specially - create individual symlinks
mkdir -p "$HOME/.config"
for config_dir in "${CONFIG_DIRS[@]}"; do
    target_path="$HOME/.config/$config_dir"
    source_path="$DOTFILES_DIR/.config/$config_dir"

    # Check if symlink already exists and points to correct location
    if [[ -L "$target_path" && "$(readlink "$target_path")" == "$source_path" ]]; then
        echo -e "  Already linked: ~/.config/$config_dir -> $source_path"
        continue
    fi

    if [[ -e "$target_path" && ! -L "$target_path" ]]; then
        if [[ "$CONFLICTS" == "false" ]]; then
            mkdir -p "$BACKUP_DIR"
            echo -e "Backing up existing files to $BACKUP_DIR"
            CONFLICTS=true
        fi

        mkdir -p "$BACKUP_DIR/.config"
        cp -R "$target_path" "$BACKUP_DIR/.config/$config_dir"
        echo -e "  Backed up: $target_path"
        rm -rf "$target_path"
    elif [[ -L "$target_path" ]]; then
        # Remove existing symlink if it points to wrong location
        rm "$target_path"
    fi

    ln -s "$source_path" "$target_path"
    echo -e "  Linked: ~/.config/$config_dir -> $source_path"
done

# Handle individual .config files
for config_file in "${CONFIG_FILES[@]}"; do
    target_path="$HOME/.config/$config_file"
    source_path="$DOTFILES_DIR/.config/$config_file"

    # Check if symlink already exists and points to correct location
    if [[ -L "$target_path" && "$(readlink "$target_path")" == "$source_path" ]]; then
        echo -e "  Already linked: ~/.config/$config_file -> $source_path"
        continue
    fi

    if [[ -e "$target_path" && ! -L "$target_path" ]]; then
        if [[ "$CONFLICTS" == "false" ]]; then
            mkdir -p "$BACKUP_DIR"
            echo -e "Backing up existing files to $BACKUP_DIR"
            CONFLICTS=true
        fi

        mkdir -p "$BACKUP_DIR/.config"
        cp "$target_path" "$BACKUP_DIR/.config/$config_file"
        echo -e "  Backed up: $target_path"
        rm "$target_path"
    elif [[ -L "$target_path" ]]; then
        # Remove existing symlink if it points to wrong location
        rm "$target_path"
    fi

    ln -s "$source_path" "$target_path"
    echo -e "  Linked: ~/.config/$config_file -> $source_path"
done

# Use stow to create symlinks for non-.config files
cd "$(dirname "$DOTFILES_DIR")"
stow "$(basename "$DOTFILES_DIR")" --ignore='\.git' --ignore='\.DS_Store' --ignore='README\.md' --ignore='AGENT\.md' --ignore='install\.sh' --ignore='uninstall\.sh' --ignore='\.config'

echo -e "Dotfiles installation complete!"
if [[ "$CONFLICTS" == "true" ]]; then
    echo -e "Original files backed up to: $BACKUP_DIR"
fi

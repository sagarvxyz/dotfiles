#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES_DIR="$DOTFILES_DIR/files"

echo -e "${BLUE}Uninstalling dotfiles...${NC}"
echo -e "${BLUE}Dotfiles directory: $DOTFILES_DIR${NC}"
echo -e "${BLUE}Target directory: $HOME${NC}"
echo

# --- Define the backup directory pattern ---
# We need to find the most recent backup directory created by the install script.
# The install script creates a directory like ~/.dotfiles_backup_YYYYMMDDHHMMSS
BACKUP_DIR_PATTERN="$HOME/.dotfiles_backup_*"
LATEST_BACKUP_DIR=""

# Find the most recent backup directory
LATEST_BACKUP_DIR=$(ls -d -t $BACKUP_DIR_PATTERN 2>/dev/null | head -n1 || true)

if [[ -z "$LATEST_BACKUP_DIR" ]]; then
    echo -e "${YELLOW}Warning: No centralized dotfiles backup directory found (${BACKUP_DIR_PATTERN}).${NC}"
    echo -e "${YELLOW}Automatic restoration of original files may not be possible.${NC}"
fi

# Function to remove symlink and restore original file from centralized backup
remove_symlink_and_restore() {
    local home_target_path="$1"       # Path in $HOME (e.g., $HOME/.bashrc, $HOME/.config/nvim)
    local source_dotfile_path="$2"    # Path in $DOTFILES_DIR/files (e.g., $DOTFILES_DIR/files/.bashrc)
    local backup_relative_path="$3"   # Path relative to $HOME for backup (e.g., .bashrc, .config/nvim)

    echo -e "${BLUE}Processing: ${NC}$home_target_path"

    if [[ -L "$home_target_path" ]]; then # Check if it's a symlink
        local link_target
        link_target=$(readlink "$home_target_path")

        # Verify if the symlink points to our dotfiles
        if [[ "$link_target" == "$source_dotfile_path" ]]; then
            echo -e "${YELLOW}  Removing symlink: ${NC}$home_target_path"
            rm "$home_target_path"

            # Attempt to restore the original file from the centralized backup
            local original_backup_file="$LATEST_BACKUP_DIR/$backup_relative_path"
            if [[ -f "$original_backup_file" || -d "$original_backup_file" ]]; then # Check if backup exists (file or dir)
                echo -e "${GREEN}  Restoring original: ${NC}$original_backup_file ${GREEN}-> ${NC}$home_target_path"
                # Ensure parent directories for restoration exist
                mkdir -p "$(dirname "$home_target_path")"
                mv "$original_backup_file" "$home_target_path"
            else
                echo -e "${BLUE}  No original backup found for ${NC}$home_target_path ${BLUE}in ${NC}$LATEST_BACKUP_DIR"
            fi
        else
            echo -e "${YELLOW}  Skipping: ${NC}$home_target_path ${YELLOW}points to different location (${link_target})${NC}"
        fi
    elif [[ -e "$home_target_path" ]]; then # It exists but is not a symlink (or not our symlink)
        echo -e "${YELLOW}  Skipping: ${NC}$home_target_path ${YELLOW}exists but is not a symlink created by this script.${NC}"
    else
        echo -e "${BLUE}  File does not exist: ${NC}$home_target_path${NC}"
    fi
}

# Check if files directory exists (required to know what symlinks *should* exist)
if [[ ! -d "$FILES_DIR" ]]; then
    echo -e "${RED}Error: 'files/' directory not found in $DOTFILES_DIR.${NC}"
    echo -e "${YELLOW}Cannot determine which symlinks to remove without the source 'files/' structure.${NC}"
    echo -e "${YELLOW}If you wish to proceed, you'll need to manually remove symlinks and restore backups.${NC}"
    exit 1
fi

echo -e "\n${BLUE}--- Discovering and removing symlinks ---${NC}"

# 1. Handle .config directory first
CONFIG_SOURCE_DIR="$FILES_DIR/.config"
if [[ -d "$CONFIG_SOURCE_DIR" ]]; then
    echo -e "\n${BLUE}Processing .config symlinks...${NC}"
    find "$CONFIG_SOURCE_DIR" -mindepth 1 -maxdepth 1 | while read -r source_item; do
        item_name="$(basename "$source_item")"
        home_target_path="$HOME/.config/$item_name"
        backup_relative_path=".config/$item_name" # Path used in centralized backup
        remove_symlink_and_restore "$home_target_path" "$source_item" "$backup_relative_path"
    done
else
    echo -e "${YELLOW}No .config directory found in $FILES_DIR. Skipping .config symlinks.${NC}"
fi

# 2. Handle other files and folders in the main 'files' directory
echo -e "\n${BLUE}Processing other dotfile symlinks...${NC}"
find "$FILES_DIR" -mindepth 1 -maxdepth 1 ! -name ".config" | while read -r source_item; do
    item_name="$(basename "$source_item")"
    home_target_path="$HOME/$item_name"
    backup_relative_path="$item_name" # Path used in centralized backup
    remove_symlink_and_restore "$home_target_path" "$source_item" "$backup_relative_path"
done

# Clean up empty directories that might have been created by symlinks
# This list should broadly cover common dotfile locations. Be cautious with adding too many!
echo -e "\n${BLUE}--- Cleaning up empty directories ---${NC}"
cleanup_dirs=(
    "$HOME/.config"
    "$HOME/.config/nvim/lua/plugins"
    "$HOME/.config/nvim/lua/config"
    "$HOME/.config/nvim/lua"
    "$HOME/.config/nvim"
    "$HOME/.config/ghostty"
    # Add any other specific empty directories your dotfiles might create or expect to be empty
)

for dir in "${cleanup_dirs[@]}"; do
    if [[ -d "$dir" && -z "$(ls -A "$dir" 2>/dev/null)" ]]; then
        echo -e "${YELLOW}  Removing empty directory: ${NC}$dir"
        rmdir "$dir" 2>/dev/null || true # rmdir only removes empty directories
    fi
done

echo -e "\n${GREEN}Uninstallation complete!${NC}"
if [[ -n "$LATEST_BACKUP_DIR" ]]; then
    echo -e "${BLUE}Backed-up original files were restored from: ${NC}$LATEST_BACKUP_DIR"
    echo -e "${YELLOW}Consider removing this backup directory if you're sure you don't need it: ${NC}rm -rf \"$LATEST_BACKUP_DIR\"${NC}"
else
    echo -e "${YELLOW}No backup directory was found, so no files were automatically restored.${NC}"
fi
echo -e "\n${BLUE}To reinstall, run:${NC}"
echo "  ./install.sh"

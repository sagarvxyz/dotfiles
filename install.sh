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
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d%H%M%S)" # Centralized, timestamped backup folder

# Check if files directory exists
if [[ ! -d "$FILES_DIR" ]]; then
    echo -e "${RED}Error: files/ directory not found in $DOTFILES_DIR${NC}"
    exit 1
fi

echo -e "${BLUE}Installing dotfiles from $FILES_DIR${NC}"
echo -e "${BLUE}Target directory: $HOME${NC}"
echo -e "${BLUE}Backup directory: $BACKUP_DIR${NC}"
echo

# Create the centralized backup directory
mkdir -p "$BACKUP_DIR" || { echo -e "${RED}Error: Could not create backup directory $BACKUP_DIR${NC}"; exit 1; }

# Function to create a symlink and handle backups
create_symlink() {
    local source_path="$1"
    local dest_path="$2"
    local backup_relative_path="$3" # Path relative to HOME for backup within BACKUP_DIR

    echo -e "${BLUE}Processing: ${NC}$source_path ${BLUE}-> ${NC}$dest_path"

    # Check if the destination exists (file, directory, or symlink)
    if [[ -e "$dest_path" || -L "$dest_path" ]]; then
        echo -e "${YELLOW}  Existing item found at $dest_path. Backing up...${NC}"
        
        # Ensure parent directories exist in the backup location
        mkdir -p "$(dirname "$BACKUP_DIR/$backup_relative_path")" || { echo -e "${RED}Error: Could not create backup parent directory for $backup_relative_path${NC}"; exit 1; }

        # Move the existing item to the backup directory
        mv "$dest_path" "$BACKUP_DIR/$backup_relative_path" || { echo -e "${RED}Error: Could not move $dest_path to backup${NC}"; exit 1; }
        echo -e "${GREEN}  Backed up to: ${NC}$BACKUP_DIR/$backup_relative_path"
    fi

    # Ensure parent directories exist for the symlink destination
    mkdir -p "$(dirname "$dest_path")" || { echo -e "${RED}Error: Could not create destination parent directory for $dest_path${NC}"; exit 1; }

    # Create the symbolic link
    ln -sf "$source_path" "$dest_path" || { echo -e "${RED}Error: Could not create symlink from $source_path to $dest_path${NC}"; exit 1; }
    echo -e "${GREEN}  Symlinked: ${NC}$source_path ${GREEN}-> ${NC}$dest_path"
}

# --- Handle .config directory ---
echo -e "\n${BLUE}--- Processing .config directory ---${NC}"
CONFIG_SOURCE_DIR="$FILES_DIR/.config"
CONFIG_DEST_DIR="$HOME/.config"

if [[ -d "$CONFIG_SOURCE_DIR" ]]; then
    mkdir -p "$CONFIG_DEST_DIR" # Ensure .config in HOME exists
    find "$CONFIG_SOURCE_DIR" -mindepth 1 -maxdepth 1 | while read -r item; do
        item_name="$(basename "$item")"
        source_path="$item"
        destination_path="$CONFIG_DEST_DIR/$item_name"
        backup_relative_path=".config/$item_name" # Backup will be .dotfiles_backup/.config/item_name
        create_symlink "$source_path" "$destination_path" "$backup_relative_path"
    done
else
    echo -e "${YELLOW}No .config directory found in $FILES_DIR. Skipping.${NC}"
fi

# --- Handle other files and folders in the main 'files' directory ---
echo -e "\n${BLUE}--- Processing other files and folders in $FILES_DIR ---${NC}"
find "$FILES_DIR" -mindepth 1 -maxdepth 1 ! -name ".config" | while read -r item; do
    item_name="$(basename "$item")"
    
    source_path="$item"
    destination_path="$HOME/$item_name"
    backup_relative_path="$item_name" # Backup will be .dotfiles_backup/item_name
    create_symlink "$source_path" "$destination_path" "$backup_relative_path"
done

echo -e "\n${GREEN}Dotfiles installation complete!${NC}"
echo -e "${GREEN}All original files, if they existed, are backed up in: ${NC}$BACKUP_DIR"
echo -e "${BLUE}You can manually review or delete this backup folder if everything works as expected.${NC}"

#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Uninstalling dotfiles using GNU Stow...${NC}"

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo -e "${RED}Error: GNU Stow is not installed${NC}"
    exit 1
fi

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# List of .config subdirectories to individually remove (matches install.sh)
CONFIG_DIRS=(nvim ghostty mise amp zed)

# List of individual .config files to remove (matches install.sh)
CONFIG_FILES=(starship.toml)

# Remove individual .config directory symlinks
echo -e "${YELLOW}Removing individual .config symlinks...${NC}"
for config_dir in "${CONFIG_DIRS[@]}"; do
    target_path="$HOME/.config/$config_dir"
    if [[ -L "$target_path" ]]; then
        rm "$target_path"
        echo -e "${GREEN}  Removed: ~/.config/$config_dir${NC}"
    fi
done

# Remove individual .config file symlinks
for config_file in "${CONFIG_FILES[@]}"; do
    target_path="$HOME/.config/$config_file"
    if [[ -L "$target_path" ]]; then
        rm "$target_path"
        echo -e "${GREEN}  Removed: ~/.config/$config_file${NC}"
    fi
done

# Use stow to remove symlinks for non-.config files
cd "$(dirname "$DOTFILES_DIR")"
stow -D "$(basename "$DOTFILES_DIR")" --ignore='\.git' --ignore='\.DS_Store' --ignore='README\.md' --ignore='AGENT\.md' --ignore='install\.sh' --ignore='uninstall\.sh' --ignore='\.config'

# Find and restore from most recent backup
BACKUP_DIR_PATTERN="$HOME/.dotfiles_backup_*"
LATEST_BACKUP_DIR=$(ls -d -t $BACKUP_DIR_PATTERN 2>/dev/null | head -n1 || true)

if [[ -n "$LATEST_BACKUP_DIR" ]]; then
    echo -e "${YELLOW}Restoring files from backup: $LATEST_BACKUP_DIR${NC}"
    
    # Restore backed up files
    while IFS= read -r -d '' backup_file; do
        rel_path="${backup_file#$LATEST_BACKUP_DIR/}"
        target_path="$HOME/$rel_path"
        
        # Create parent directories if needed
        mkdir -p "$(dirname "$target_path")"
        
        # Restore the file
        cp -R "$backup_file" "$target_path"
        echo -e "${GREEN}  Restored: $target_path${NC}"
    done < <(find "$LATEST_BACKUP_DIR" -type f -print0)
    
    echo -e "${BLUE}You can remove the backup directory: rm -rf \"$LATEST_BACKUP_DIR\"${NC}"
fi

echo -e "${GREEN}Uninstallation complete!${NC}"

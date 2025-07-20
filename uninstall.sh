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

# Function to restore backup if it exists
restore_backup() {
    local file_path=$1
    local backup_pattern="${file_path}.backup-*"
    
    # Find the most recent backup
    local latest_backup
    latest_backup=$(ls -t $backup_pattern 2>/dev/null | head -n1 || true)
    
    if [[ -n "$latest_backup" && -f "$latest_backup" ]]; then
        echo -e "${GREEN}  Restoring backup: $latest_backup -> $file_path${NC}"
        mv "$latest_backup" "$file_path"
        return 0
    fi
    return 1
}

# Function to remove symlink and restore backup
remove_symlink() {
    local target_file=$1
    local source_file=$2
    
    if [[ -L "$target_file" ]]; then
        # Check if it's a symlink pointing to our dotfiles
        local link_target
        link_target=$(readlink "$target_file")
        if [[ "$link_target" == "$source_file" ]]; then
            echo -e "${YELLOW}  Removing symlink: $target_file${NC}"
            rm "$target_file"
            
            # Try to restore backup
            if ! restore_backup "$target_file"; then
                echo -e "${BLUE}    No backup found for $target_file${NC}"
            fi
        else
            echo -e "${YELLOW}  Skipping: $target_file points to different location ($link_target)${NC}"
        fi
    elif [[ -f "$target_file" ]]; then
        echo -e "${YELLOW}  Skipping: $target_file is not a symlink${NC}"
    else
        echo -e "${BLUE}  File does not exist: $target_file${NC}"
    fi
}

# Check if files directory exists
if [[ ! -d "$FILES_DIR" ]]; then
    echo -e "${RED}Error: files/ directory not found in $DOTFILES_DIR${NC}"
    echo -e "${YELLOW}Note: You can still manually remove symlinks and restore backups${NC}"
    exit 1
fi

total_files=0
removed_files=0

echo -e "${BLUE}Discovering symlinks to remove...${NC}"

# Use find to get all files in the files directory
while IFS= read -r -d '' source_file; do
    # Get relative path from files directory
    relative_path="${source_file#$FILES_DIR/}"
    target_file="$HOME/$relative_path"
    
    total_files=$((total_files + 1))
    
    echo -e "${BLUE}Processing: $relative_path${NC}"
    
    if [[ -f "$source_file" ]]; then
        remove_symlink "$target_file" "$source_file"
        if [[ ! -L "$target_file" ]]; then
            removed_files=$((removed_files + 1))
        fi
    fi
    
    echo
done < <(find "$FILES_DIR" -type f -print0)

# Clean up empty directories (but be careful not to remove important ones)
echo -e "${BLUE}Cleaning up empty directories...${NC}"
cleanup_dirs=(
    "$HOME/.config/nvim/lua/plugins"
    "$HOME/.config/nvim/lua/config"
    "$HOME/.config/nvim/lua"
    "$HOME/.config/ghostty"
)

for dir in "${cleanup_dirs[@]}"; do
    if [[ -d "$dir" && -z "$(ls -A "$dir" 2>/dev/null)" ]]; then
        echo -e "${YELLOW}  Removing empty directory: $dir${NC}"
        rmdir "$dir" 2>/dev/null || true
    fi
done

echo -e "${GREEN}Uninstallation complete!${NC}"
echo -e "${GREEN}Processed $total_files files${NC}"
echo
echo -e "${BLUE}Remaining backup files (if any):${NC}"
find "$HOME" -name "*.backup-*" -type f 2>/dev/null | head -10 || echo "  No backup files found"
echo
echo -e "${BLUE}To reinstall, run:${NC}"
echo "  ./install.sh"
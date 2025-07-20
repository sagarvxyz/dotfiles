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

# Check if files directory exists
if [[ ! -d "$FILES_DIR" ]]; then
    echo -e "${RED}Error: files/ directory not found in $DOTFILES_DIR${NC}"
    exit 1
fi

echo -e "${BLUE}Installing dotfiles from $FILES_DIR${NC}"
echo -e "${BLUE}Target directory: $HOME${NC}"
echo

# Function to create backup of existing file
backup_file() {
    local file_path=$1
    if [[ -f "$file_path" || -L "$file_path" ]]; then
        local backup_path="${file_path}.backup-$(date +%Y%m%d-%H%M%S)"
        echo -e "${YELLOW}  Backing up existing file to: $backup_path${NC}"
        mv "$file_path" "$backup_path"
    fi
}

# Function to create symlink for a file
create_symlink() {
    local source_file=$1
    local target_file=$2
    
    # Create parent directory if it doesn't exist
    local parent_dir=$(dirname "$target_file")
    if [[ ! -d "$parent_dir" ]]; then
        echo -e "${BLUE}  Creating directory: $parent_dir${NC}"
        mkdir -p "$parent_dir"
    fi
    
    # Backup existing file if it exists
    backup_file "$target_file"
    
    # Create symlink
    echo -e "${GREEN}  Linking: $target_file -> $source_file${NC}"
    ln -s "$source_file" "$target_file"
}

# Find all files in the files directory and create symlinks
total_files=0
linked_files=0

echo -e "${BLUE}Discovering files to link...${NC}"

# Use find to get all files (not directories) in the files directory
while IFS= read -r -d '' source_file; do
    # Get relative path from files directory
    relative_path="${source_file#$FILES_DIR/}"
    target_file="$HOME/$relative_path"
    
    total_files=$((total_files + 1))
    
    echo -e "${BLUE}Processing: $relative_path${NC}"
    
    # Check if source file exists and is a regular file
    if [[ -f "$source_file" ]]; then
        create_symlink "$source_file" "$target_file"
        linked_files=$((linked_files + 1))
    else
        echo -e "${YELLOW}  Skipping: not a regular file${NC}"
    fi
    
    echo
done < <(find "$FILES_DIR" -type f -print0)

echo -e "${GREEN}Installation complete!${NC}"
echo -e "${GREEN}Linked $linked_files out of $total_files files${NC}"
echo
echo -e "${BLUE}To verify your installation:${NC}"
echo "  ls -la ~/ | grep ' -> '"
echo "  ls -la ~/.config/ | grep ' -> '"
echo
echo -e "${BLUE}To uninstall, run:${NC}"
echo "  ./uninstall.sh"
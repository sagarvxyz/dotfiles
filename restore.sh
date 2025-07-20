#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse command line arguments
if [[ $# -eq 0 ]]; then
    echo -e "${RED}Usage: $0 <file_to_restore> [backup_directory]${NC}"
    echo -e "${BLUE}Examples:${NC}"
    echo "  $0 .zshrc"
    echo "  $0 .config/nvim ~/.dotfiles_backup_20240120123456"
    echo ""
    echo -e "${BLUE}Available backups:${NC}"
    ls -dt $HOME/.dotfiles_backup_* 2>/dev/null | head -5 || echo "  No backup directories found"
    exit 1
fi

TARGET_FILE="$1"
BACKUP_DIR="$2"

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES_DIR="$DOTFILES_DIR/files"

# Find the most recent backup directory if not specified
if [[ -z "$BACKUP_DIR" ]]; then
    BACKUP_DIR=$(ls -d -t $HOME/.dotfiles_backup_* 2>/dev/null | head -n1 || true)
    if [[ -z "$BACKUP_DIR" ]]; then
        echo -e "${RED}Error: No backup directory found and none specified${NC}"
        exit 1
    fi
    echo -e "${BLUE}Using most recent backup: $BACKUP_DIR${NC}"
fi

# Validate backup directory exists
if [[ ! -d "$BACKUP_DIR" ]]; then
    echo -e "${RED}Error: Backup directory does not exist: $BACKUP_DIR${NC}"
    exit 1
fi

echo -e "${BLUE}Restoring: $TARGET_FILE${NC}"
echo -e "${BLUE}From backup: $BACKUP_DIR${NC}"
echo

# Function to restore a single file
restore_file() {
    local target_file="$1"
    local home_path="$HOME/$target_file"
    local source_path="$FILES_DIR/$target_file"
    local backup_path="$BACKUP_DIR/$target_file"

    echo -e "${BLUE}Processing: ${NC}$target_file"

    # Check if this is currently a symlink to our dotfiles
    if [[ -L "$home_path" ]]; then
        local link_target
        link_target=$(readlink "$home_path")
        if [[ "$link_target" == "$source_path" ]]; then
            echo -e "${YELLOW}  Removing dotfiles symlink: ${NC}$home_path"
            rm "$home_path"
        else
            echo -e "${YELLOW}  Warning: $home_path is a symlink but not to our dotfiles${NC}"
            echo -e "${YELLOW}  Points to: $link_target${NC}"
            read -p "Remove anyway? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm "$home_path"
            else
                echo -e "${BLUE}  Skipping removal${NC}"
                return
            fi
        fi
    elif [[ -e "$home_path" ]]; then
        echo -e "${YELLOW}  Warning: $home_path exists but is not a symlink${NC}"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$home_path"
        else
            echo -e "${BLUE}  Skipping restoration${NC}"
            return
        fi
    fi

    # Restore from backup if it exists
    if [[ -e "$backup_path" ]]; then
        echo -e "${GREEN}  Restoring from backup: ${NC}$backup_path ${GREEN}-> ${NC}$home_path"
        # Ensure parent directories exist
        mkdir -p "$(dirname "$home_path")"
        mv "$backup_path" "$home_path"
        echo -e "${GREEN}  Restored successfully${NC}"
    else
        echo -e "${BLUE}  No backup found for $target_file${NC}"
    fi
}

# Check if files directory exists
if [[ ! -d "$FILES_DIR" ]]; then
    echo -e "${RED}Error: files/ directory not found in $DOTFILES_DIR${NC}"
    exit 1
fi

# Restore the specified file
restore_file "$TARGET_FILE"

echo -e "\n${GREEN}Restoration complete!${NC}"
echo -e "${BLUE}To reinstall dotfiles symlink for this file, run:${NC}"
echo "  ./install.sh"

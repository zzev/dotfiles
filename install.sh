#!/bin/bash

# Dotfiles installation script

DOTFILES_DIR="$HOME/Code/personal/dotfiles"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing dotfiles...${NC}"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo -e "${YELLOW}Backing up existing $target to $target.backup${NC}"
        mv "$target" "$target.backup"
    fi
    
    ln -sf "$source" "$target"
    echo -e "${GREEN}Created symlink: $target -> $source${NC}"
}

# Install vim configuration
if [ -d "$DOTFILES_DIR/vim" ]; then
    echo -e "${GREEN}Installing vim configuration...${NC}"
    
    # Create .vim directory if it doesn't exist
    mkdir -p "$HOME/.vim"
    
    # Symlink vimrc
    create_symlink "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
    
    # Symlink colors directory if it exists
    if [ -d "$DOTFILES_DIR/vim/colors" ]; then
        create_symlink "$DOTFILES_DIR/vim/colors" "$HOME/.vim/colors"
    fi
fi

# Install tmux configuration
if [ -f "$DOTFILES_DIR/tmux/.tmux.conf" ]; then
    echo -e "${GREEN}Installing tmux configuration...${NC}"
    create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
fi

# Install tmux session script
if [ -f "$DOTFILES_DIR/tmux/load_tmux.sh" ]; then
    echo -e "${GREEN}Installing tmux session management script...${NC}"

    # Create scripts directory if it doesn't exist
    mkdir -p "$HOME/scripts"

    # Copy the script instead of symlinking for executability
    cp "$DOTFILES_DIR/tmux/load_tmux.sh" "$HOME/scripts/"
    chmod +x "$HOME/scripts/load_tmux.sh"

    echo -e "${GREEN}Installed tmux script to ~/scripts/load_tmux.sh${NC}"
    echo -e "${YELLOW}Add this alias to your ~/.bashrc or ~/.zshrc:${NC}"
    echo -e "${YELLOW}alias tmux-load=\"~/scripts/load_tmux.sh\"${NC}"
fi

echo -e "${GREEN}Dotfiles installation complete!${NC}"
echo -e "${YELLOW}Note: You may need to restart your terminal or source your configs.${NC}"
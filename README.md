# Dotfiles

Personal dotfiles for vim and tmux with cross-platform compatibility. Features server detection, Dvorak-optimized tmux bindings, Vundle plugin management, and intelligent terminal adaptation for both local development and Ubuntu servers.

  - 🖥️ Cross-platform (macOS + Ubuntu server)
  - 🎹 Dvorak keyboard optimized tmux navigation
  - 🎨 Smart color scheme adaptation (true color vs 256-color)
  - 📦 Automated Vundle plugin management
  - 🔧 One-command installation with backups
  - 🖲️ Terminal capability detection (fonts, colors, SSH)
  - 📜 Session management script with intelligent fallbacks

## Installation

### 1. Clone and install dotfiles

Run the installation script to create symlinks to your home directory:

```bash
./install.sh
```

This will:
- Create symlinks for vim configuration (`~/.vimrc`)
- Create symlinks for tmux configuration (`~/.tmux.conf`)
- Backup any existing configuration files

### 2. Install Vim plugins with Vundle

After installing the dotfiles, you need to install Vundle and the vim plugins:

```bash
# Clone Vundle into the bundle directory
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install plugins
vim +PluginInstall +qall
```

**Alternative one-liner:**
```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && vim +PluginInstall +qall
```

## Structure

- `vim/` - Vim configuration files
- `tmux/` - Tmux configuration files
- `install.sh` - Installation script

## Tmux Key Bindings

- Prefix: `Ctrl+a` (instead of default `Ctrl+b`)
- Split panes: `|` (horizontal) and `-` (vertical)
- Reload config: `Prefix + y`
- Navigate panes: `r` (left), `t` (down), `n` (up), `s` (right) - Dvorak optimized
- Resize panes: `R`, `T`, `N`, `S` (repeatable)
- Window navigation: `Alt + 1-9` (direct window selection)

## Tmux Session Management Script

The repository includes `load_tmux.sh` - a convenient script for managing tmux sessions.

### Setup the alias in your shell:

**For bash (~/.bashrc):**
```bash
# Add this line to your ~/.bashrc
alias tmux-load="~/Code/personal/dotfiles/tmux/load_tmux.sh"
```

**For zsh (~/.zshrc):**
```bash
# Add this line to your ~/.zshrc
alias tmux-load="~/Code/personal/dotfiles/tmux/load_tmux.sh"
```

Then reload your shell: `source ~/.bashrc` or `source ~/.zshrc`

### Usage:
```bash
tmux-load              # Attach to 'main' session or first available
tmux-load work         # Attach to or create 'work' session
tmux-load --list       # List all available sessions
tmux-load --help       # Show help
```

**Features:**
- Auto-attaches to existing sessions or creates new ones
- Intelligent fallback (tries default → any session → create new)
- Lists available sessions with details
- Prevents nested tmux sessions

## Vim Plugins Included

The vim configuration uses Vundle and includes these plugins:
- **Vundle** - Plugin manager
- **ack.vim** - Text searching
- **ctrlp.vim** - Fuzzy file finder
- **ALE** - Asynchronous linting
- **tagbar** - Code outline viewer
- **vim-airline** - Status line enhancement
- **vim-bundler** - Ruby Bundler support
- **vim-fugitive** - Git integration
- **vim-rails** - Ruby on Rails support
- **bufexplorer** - Buffer navigation
- **ayu-vim** - Color theme
- **typescript-vim** - TypeScript syntax

## Environment-Specific Setup

### Ubuntu Server Setup
The vim configuration automatically detects server environments (SSH, no DISPLAY, etc.) and uses:
- Conservative 256-color support (no true colors)
- ASCII-only airline symbols (no powerline fonts needed)
- Server-friendly color schemes (desert, slate, darkblue)

**Ubuntu/Debian dependencies:**
```bash
# Install vim and git
sudo apt update
sudo apt install vim git curl

# Optional: Install ack for ack.vim plugin
sudo apt install ack-grep
```

### macOS/Local Terminal Setup
For better visual experience on local terminals:

**Font Requirements:**
```bash
# Install a powerline font (choose one)
brew install --cask font-monaco-for-powerline
# or
brew install --cask font-meslo-lg-nerd-font
# or
brew install --cask font-fira-code-nerd-font
```

**Terminal Color Support:**

**iTerm2 (recommended):**
- Preferences → Profiles → Colors → Color Presets → choose a 256-color theme
- Enable "Report terminal type as: xterm-256color"

**Terminal.app:**
- Preferences → Profiles → Advanced → Declare terminal as: xterm-256color

**Test color support:**
```bash
# Test 256 color support
curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash

# Check environment detection
echo "DISPLAY: $DISPLAY"
echo "SSH_CLIENT: $SSH_CLIENT"
echo "TERM: $TERM"
```

## Notes

After installation, you may need to:
- Restart your terminal
- Source your tmux config: `tmux source ~/.tmux.conf`
- Install any additional dependencies for vim plugins (e.g., `ack` command for ack.vim)
- Set your terminal font to a powerline-compatible font for proper icons

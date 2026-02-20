#!/bin/bash

# Dotfiles installation script
# This script creates symlinks from the home directory to the dotfiles repo
# If a file already exists, it will be renamed to filename.backup

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "Installing dotfiles from $DOTFILES_DIR"
echo ""

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"

    # Check if source file exists
    if [ ! -e "$source" ]; then
        echo "⚠️  Source file does not exist: $source"
        return 1
    fi

    # If target is already a symlink to the correct location, skip
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo "✓  Already linked: $target"
        return 0
    fi

    # Create parent directory if it doesn't exist
    local target_dir="$(dirname "$target")"
    if [ ! -d "$target_dir" ]; then
        echo "📁 Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi

    # If target exists (and is not a symlink to our file), back it up
    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup="${target}.backup_${TIMESTAMP}"
        echo "📦 Backing up existing file: $target -> $backup"
        mv "$target" "$backup"
    fi

    # Create the symlink
    echo "🔗 Linking: $target -> $source"
    ln -s "$source" "$target"
}

echo "=== Installing basic dotfiles ==="
echo ""

# Basic dotfiles in home directory
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
create_symlink "$DOTFILES_DIR/.spacemacs" "$HOME/.spacemacs"
create_symlink "$DOTFILES_DIR/.hyper.js" "$HOME/.hyper.js"
create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/.tmux.conf.local" "$HOME/.tmux.conf.local"

echo ""
echo "=== Installing Karabiner config ==="
echo ""

create_symlink "$DOTFILES_DIR/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

echo ""
echo "=== Installing oh-my-zsh theme ==="
echo ""

# Check if oh-my-zsh is installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    create_symlink "$DOTFILES_DIR/juan.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/juan.zsh-theme"
else
    echo "⚠️  oh-my-zsh not found. Skipping theme installation."
    echo "   Install oh-my-zsh first: https://ohmyz.sh"
fi

echo ""
echo "=== Installing Claude Code configs ==="
echo ""

create_symlink "$DOTFILES_DIR/.claude/global-settings.local.json" "$HOME/.claude/settings.local.json"
create_symlink "$DOTFILES_DIR/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

echo ""
echo "=== Optional configs (manual setup required) ==="
echo ""

echo "ℹ️  BetterTouchTool preset: $DOTFILES_DIR/Laptop.bttpreset"
echo "   Import manually in BetterTouchTool preferences"
echo ""
echo "ℹ️  Alfred preferences: $DOTFILES_DIR/Alfred.alfredpreferences"
echo "   Set as sync folder in Alfred preferences"
echo ""

echo "✅ Dotfiles installation complete!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Import BetterTouchTool preset if needed"
echo "3. Configure Alfred to use the preferences folder"

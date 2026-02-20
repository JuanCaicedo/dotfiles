#!/bin/bash
# Setup script for Claude Code configuration
# Creates symlinks from ~/.claude to dotfiles/.claude

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SOURCE_DIR="$DOTFILES_DIR/.claude"

echo "Setting up Claude Code configuration..."
echo "Dotfiles: $DOTFILES_DIR"
echo "Claude dir: $CLAUDE_DIR"
echo ""

# Create ~/.claude directory if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Files to symlink
FILES=(
  "CLAUDE.md"
  "settings.json"
  "settings.local.json"
  "global-settings.local.json"
  "statusline.sh"
)

for file in "${FILES[@]}"; do
  source="$SOURCE_DIR/$file"
  target="$CLAUDE_DIR/$file"

  # Skip if source doesn't exist
  if [ ! -e "$source" ]; then
    echo "⊘ Skipping $file (not in dotfiles)"
    continue
  fi

  # Check if target already exists
  if [ -e "$target" ] || [ -L "$target" ]; then
    # Check if it's already the correct symlink
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
      echo "✓ $file (already linked)"
      continue
    fi

    # Backup existing file
    backup="$target.backup.$(date +%Y%m%d-%H%M%S)"
    echo "⚠ Backing up existing $file to $backup"
    mv "$target" "$backup"
  fi

  # Create symlink
  ln -s "$source" "$target"
  echo "✓ Linked $file"
done

echo ""

# Symlink individual skills from dotfiles
echo "Setting up skills..."
SKILLS_SOURCE="$SOURCE_DIR/skills"
SKILLS_TARGET="$CLAUDE_DIR/skills"

# Ensure target skills directory exists
mkdir -p "$SKILLS_TARGET"

# Check if skills directory exists in dotfiles
if [ -d "$SKILLS_SOURCE" ]; then
  # Loop through each skill in dotfiles
  for skill_dir in "$SKILLS_SOURCE"/*; do
    if [ -d "$skill_dir" ]; then
      skill_name=$(basename "$skill_dir")

      # Skip .gitkeep or hidden files
      if [[ "$skill_name" == "."* ]]; then
        continue
      fi

      source="$SKILLS_SOURCE/$skill_name"
      target="$SKILLS_TARGET/$skill_name"

      # Check if already correctly symlinked
      if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo "✓ $skill_name (already linked)"
        continue
      fi

      # If target exists and is not our symlink
      if [ -e "$target" ] || [ -L "$target" ]; then
        # Backup existing skill
        backup="$target.backup.$(date +%Y%m%d-%H%M%S)"
        echo "⚠ Backing up existing skill: $skill_name → $backup"
        mv "$target" "$backup"
      fi

      # Create symlink
      ln -s "$source" "$target"
      echo "✓ Linked skill: $skill_name"
    fi
  done
else
  echo "⊘ No skills directory in dotfiles (skipping)"
fi

echo ""
echo "✅ Claude Code setup complete!"

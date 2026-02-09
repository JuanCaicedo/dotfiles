# Claude Code Configuration

This directory contains configuration files for Claude Code that are symlinked to `~/.claude/`.

## Files

- **settings.json** - Main Claude Code settings (hooks, plugins, statusLine)
- **statusline.sh** - Custom status line script showing git branch and directory
- **settings.local.json** - Local settings overrides
- **global-settings.local.json** - Global local settings
- **CLAUDE.md** - Project-specific instructions for Claude

## Setup

Run the setup script from the dotfiles root:

```bash
./setup-claude.sh
```

This will create symlinks from `~/.claude/` to these files.

## Status Line

The status line displays:
- Git branch (in cyan)
- Current directory name (in yellow)

Features:
- 100ms timeout on git commands
- Skips git check if no `.git` directory
- Optimized to prevent startup delays

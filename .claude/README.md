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

## Skills Management

Custom skills can be either:
- **Dotfiles skills**: Version controlled in `dotfiles/.claude/skills/`, symlinked to `~/.claude/skills/`
- **Local skills**: Created directly in `~/.claude/skills/`, not version controlled

### Adding a Skill to Dotfiles

1. Create the skill in `dotfiles/.claude/skills/your-skill-name/`
2. Add `SKILL.md` with skill definition
3. Commit to git
4. Run `./setup-claude.sh` to create symlink

### Creating a Local-Only Skill

1. Create directly in `~/.claude/skills/your-local-skill/`
2. Add `SKILL.md` with skill definition
3. This skill will NOT be in dotfiles (stays on this machine only)

### When to Use Each

**Dotfiles skills (shared):**
- General-purpose utilities (database helpers, project setup)
- Reusable across machines
- No sensitive data

**Local skills (machine-specific):**
- Project-specific workflows
- Machine-specific paths or configurations
- Skills containing API keys or secrets

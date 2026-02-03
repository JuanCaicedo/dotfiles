---
title: Setup Guide and Dependencies
category: dotfiles-knowledge
tags: [setup, installation, dependencies, macos]
created: 2026-02-03
---

# Setup Guide and Dependencies

## Required Software

These tools must be installed before the dotfiles are useful:

| Tool | Purpose | Install |
|------|---------|---------|
| oh-my-zsh | Zsh framework | [ohmyz.sh](https://ohmyz.sh) |
| NVM | Node.js version manager | [nvm-sh/nvm](https://github.com/nvm-sh/nvm) |
| RVM | Ruby version manager | [rvm.io](https://rvm.io) |
| rbenv | Ruby version manager (alternative) | `brew install rbenv` |
| Spacemacs | Emacs distribution | [spacemacs.org](https://www.spacemacs.org) |
| Karabiner-Elements | Keyboard remapping | `brew install karabiner-elements` |
| BetterTouchTool | Trackpad/Touch Bar | [folivora.ai](https://folivora.ai) |
| Hyper | Terminal emulator | [hyper.is](https://hyper.is) |
| tmux | Terminal multiplexer | `brew install tmux` |
| Alfred | Launcher | [alfredapp.com](https://www.alfredapp.com) |
| GPG | Commit signing | `brew install gnupg` |
| Git LFS | Large file storage | `brew install git-lfs` |
| Google Cloud SDK | GCP tools | [cloud.google.com/sdk](https://cloud.google.com/sdk) |
| Bun | JS package manager | [bun.sh](https://bun.sh) |
| iTerm2 | Terminal (shell integration) | [iterm2.com](https://iterm2.com) |
| Claude Code | AI coding assistant | [claude.com/claude-code](https://claude.com/claude-code) |

## Symlink Strategy

The repo does not include an install script. Files need to be manually
symlinked to their expected locations:

```
~/.zshrc          -> dotfiles/.zshrc
~/.zshenv         -> dotfiles/.zshenv
~/.gitconfig      -> dotfiles/.gitconfig
~/.gitignore_global -> dotfiles/.gitignore_global
~/.spacemacs      -> dotfiles/.spacemacs
~/.hyper.js       -> dotfiles/.hyper.js
~/.tmux.conf      -> dotfiles/.tmux.conf
~/.tmux.conf.local -> dotfiles/.tmux.conf.local
```

Karabiner expects its config at `~/.config/karabiner/karabiner.json`.

The zsh theme goes in `~/.oh-my-zsh/custom/themes/juan.zsh-theme`.

Claude Code global configs:

```
~/.claude/settings.json       -> dotfiles/.claude/settings.json
~/.claude/settings.local.json -> dotfiles/.claude/global-settings.local.json
~/.claude/CLAUDE.md           -> dotfiles/.claude/CLAUDE.md
```

Note: `global-settings.local.json` is named differently in the repo to avoid
conflicting with the project-level `settings.local.json`.

## Known Issues

1. **No install script** - Everything is manual symlinks. Consider adding a
   `Makefile` or `install.sh` in the future.

2. **Stale configurations** - With a 5.5-year gap between syncs, some configs
   may reference tools or paths that no longer exist.

3. **Credentials risk** - `.gitconfig` once had credentials committed and
   immediately removed. The git history still contains them.

4. **Tmux naming confusion** - The tmux config went through a rename cycle
   (`.tmuxconf` -> `.tmux.conf.local` -> `.tmux.conf`). The correct files
   are `.tmux.conf` (main) and `.tmux.conf.local` (overrides).

5. **Global gitignore blocks `.claude/` and `docs/`** - The repo has a
   `.gitignore` with negation rules (`!.claude/`, `!docs/`) to override
   the global gitignore. Without this, git won't track those directories.

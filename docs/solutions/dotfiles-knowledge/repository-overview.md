---
title: Dotfiles Repository Knowledge Base
category: dotfiles-knowledge
tags: [dotfiles, macos, zsh, spacemacs, tmux, karabiner, git, alfred]
created: 2026-02-03
author: Juan Caicedo
---

# Dotfiles Repository Knowledge Base

Personal macOS development environment managed by Juan Caicedo.

## What's Tracked

| Category | Tool | Config File | Lines |
|----------|------|-------------|-------|
| Shell | Zsh + oh-my-zsh | `.zshrc`, `.zshenv` | 274 |
| Shell Theme | Custom "juan" theme | `juan.zsh-theme` | 21 |
| Editor | Spacemacs | `.spacemacs` | 853 |
| Terminal Multiplexer | Tmux (gpakosz base) | `.tmux.conf`, `.tmux.conf.local` | ~1350 |
| Terminal Emulator | Hyper | `.hyper.js` | 163 |
| Version Control | Git | `.gitconfig`, `.gitignore_global` | 172 |
| Keyboard | Karabiner-Elements | `karabiner.json` | 155 |
| Touch Bar/Trackpad | BetterTouchTool | `Laptop.bttpreset`, `.btt_autoload_preset.json` | - |
| Launcher | Alfred | `Alfred.alfredpreferences/` | 82 files |
| AI Tools | Claude Code | `.claude/settings.local.json` | - |

## Shell Configuration (.zshrc)

### Custom Functions

- **`nvm_use()`** - Auto-loads `.nvmrc` when entering directories
- **`branch-name()`** - Returns current git branch name
- **`pp()` / `ppno()`** - Push current branch to origin (with/without verify)
- **`add-notes()` / `new-journal()`** - Note and journal management using `$NOTES_HOME`
- **`tabname()`** - Set terminal tab title
- **`killport()`** - Kill process on a given port
- **`vannabk()`** - Project-specific backup for Vanna Connect

### Notable Aliases

```
gits -> git status
g -> git
python -> python3
pip -> pip3
tmuk -> tmux (typo-friendly)
spacemacs -> emacsclient (daemon connect)
```

### Language Support

- **Node.js**: NVM with auto `.nvmrc` detection
- **Ruby**: RVM and rbenv
- **Python**: Aliased to Python 3
- **Go**: `$GOPATH` in PATH
- **Bun**: Package manager configured

## Git Configuration

### Key Aliases

```
co -> checkout       back -> checkout -
s -> status          d -> diff
a -> add             c -> commit -m
p -> push            l -> pull
main -> checkout main
clean-branches -> prune merged branches
glog -> graph log with colors
crawl -> traverse commits one-by-one
e -> show recently checked out branches
```

### Settings

- Credential helper: osxkeychain
- Core editor: vim
- GPG signing configured
- Git LFS enabled
- Difftool: SourceTree (opendiff)

## Keyboard Layout (Karabiner)

### Remappings

1. **Caps Lock** -> Left Command (when held) / no-op alone / Escape with Shift
2. **Tab** -> Left Control (when held) / Tab alone
3. **Cmd+Shift+Tab** -> Cmd+Escape

### Device-Specific

- **Apple keyboard**: Fn <-> Left Command swap, Right Command -> Right Option
- **HHKB keyboard**: Custom profile with LED control

## Spacemacs Layers

Programming: python, elixir, typescript (LSP), ruby, javascript, elm, clojure, shell-scripts

Markup: html, markdown, yaml, nginx, docker, sql, csv

Other: git, org, neotree, helm, osx, emoji, keyboard-layout (Dvorak Programmer)

## Tmux Configuration

Based on [gpakosz/.tmux](https://github.com/gpakosz/.tmux).

- Prefix: `Ctrl-B` + `Ctrl-U`
- Pane navigation: vim-style `hjkl`
- Split: `-` (vertical), `_` (horizontal)
- Mouse toggle: `m`
- History: 5000 lines
- Theme: dark gray (#080808) with light gray text

## Repository History

### Timeline

| Period | Activity |
|--------|----------|
| Jan 2018 | Started with `.spacemacs` only |
| May 2018 | Added shell configs (zshrc, zshenv, gitignore) |
| Sep-Oct 2018 | Only period using PRs; added Karabiner + BTT |
| Jan-Feb 2019 | Periodic bulk syncs |
| Aug 2020 | Major expansion: Hyper, tmux, gitconfig, zsh-theme, BTT preset |
| Feb 2026 | Large sync after 5.5-year gap; added Alfred; Caps Lock changes |

### Patterns

- `.spacemacs` was the most modified file historically (25+ commits)
- Commit style evolved from granular ("add graphql mode") to bulk ("sync files")
- Credentials were accidentally committed to `.gitconfig` once and immediately removed
- PRs were tried briefly (3 PRs in Oct 2018) then abandoned
- The `sync-dotfiles` branch has 3 commits not yet merged to master

### Branches

- **master**: Main branch, last commit Aug 2020
- **sync-dotfiles**: Current work, 3 commits ahead of master

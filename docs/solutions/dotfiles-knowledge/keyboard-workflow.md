---
title: Keyboard-Centric Workflow
category: dotfiles-knowledge
tags: [karabiner, keyboard, dvorak, spacemacs, tmux, vim]
created: 2026-02-03
---

# Keyboard-Centric Workflow

This repo reflects a heavily keyboard-optimized development setup.

## The Keyboard Stack

```
Layer 1: Karabiner-Elements  (OS-level key remapping)
Layer 2: Tmux                (terminal multiplexer keybindings)
Layer 3: Spacemacs/Vim       (editor keybindings)
Layer 4: Zsh aliases         (command shortcuts)
Layer 5: Git aliases         (git shortcuts)
```

## Design Philosophy

### Caps Lock as Command

Caps Lock is remapped to Left Command when held with another key. This keeps
hands on the home row for all Command shortcuts. Combined with Shift, it
produces Escape (useful for vim-style editing).

### Tab as Control

Tab acts as Left Control when held. This eliminates reaching for the corner
Control key, which is important for tmux prefix chords and Emacs bindings.

### Dvorak Programmer Layout

Spacemacs is configured with the `keyboard-layout` layer set to Dvorak
Programmer. This means standard vim keybindings (`hjkl`) are remapped to
their Dvorak equivalents.

### Vim-Style Navigation Everywhere

- **Spacemacs**: Native vim keybindings (evil mode)
- **Tmux**: `hjkl` pane navigation, vim copy mode
- **Git**: `vim` as core editor
- **Shell**: `vim` as `$EDITOR`

## Device-Specific Adaptations

Different physical keyboards get different mappings:

- **Apple internal**: Fn and Left Command are swapped (Fn is in a better position for Command)
- **HHKB**: Has its own Karabiner profile with LED control
- **Some devices ignored**: Vendor 1452 devices are excluded from remapping

## Gotchas

- The tmux prefix is `Ctrl-B` then `Ctrl-U` (non-standard). If Tab-as-Control is
  not working in Karabiner, tmux becomes difficult to use.
- Spacemacs Dvorak layout means standard vim tutorials won't match the keybindings.
- BetterTouchTool presets may conflict with Karabiner if both try to remap the same keys.

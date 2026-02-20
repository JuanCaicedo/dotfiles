---
title: Claude Code + tmux Window Status Integration
type: feat
date: 2026-02-03
status: completed
---

# Claude Code + tmux Window Status Integration

## Overview

Show Claude Code's state as a prefix on the tmux **window name** (the text in the status bar) so you can see at a glance which windows have Claude running, finished, or waiting for input — without switching to them.

| Claude State | Window Name Prefix | Clears When |
|---|---|---|
| Running / processing | `~` | Claude stops or asks a question |
| Finished (idle) | `*` | You switch to that window |
| Asking question / permission | `#` | You switch to that window |

Two systems cooperate:

1. **Claude Code hooks** (in `settings.json`) — prepend the prefix to the window name when Claude's state changes
2. **tmux window-focus hook** (in `.tmux.conf.local`) — strip the prefix when you switch to the window

## Implementation

### Claude Code hooks in `settings.json`

Each hook command:
- Guards on `$TMUX_PANE` being set (no-op outside tmux)
- Targets the correct window via `-t $TMUX_PANE` (works regardless of which window is focused)
- Strips any existing prefix with `sed 's/^[~*#]//'` before prepending the new one
- Uses `rename-window` which implicitly disables `automatic-rename` (prevents tmux from overwriting the prefix)

Hooks used:
- **`UserPromptSubmit`** — sets `~` when you send a prompt
- **`Stop`** — replaces with `*` when Claude finishes (also plays Glass sound)
- **`Notification`** — sets `#` with explicit matchers: `permission_prompt`, `idle_prompt`, `elicitation_dialog` (also plays Funk sound)
- **`PermissionRequest`** — sets `#` when a permission dialog appears
- **`SessionEnd`** — strips prefix and re-enables `automatic-rename` when exiting Claude

### tmux hook in `.tmux.conf.local`

```tmux
set-hook -g window-focus-in 'run-shell -b "name=$(tmux display-message -p \x27#{window_name}\x27); case \"$name\" in [~*#]*) tmux rename-window \"${name#[~*#]}\"; tmux set-option -w automatic-rename on ;; esac"'
```

Only acts when the window name starts with a prefix character — no-op for manually renamed windows.

### Compatibility with `rename-window` (prefix + ,)

- Manual rename while Claude is idle: works normally
- Manual rename while Claude is running: your name is preserved, prefix is prepended
- After switching to the window: prefix stripped, `automatic-rename` re-enabled

### Key findings during implementation

- `$TMUX_PANE` is available in Claude Code hook subprocesses (verified)
- `Notification` hook requires explicit matchers (`permission_prompt`, `idle_prompt`, `elicitation_dialog`) — empty matcher did not fire
- `PermissionRequest` is a separate hook from `Notification` and needed its own entry
- Pane title vs window name are separate tmux concepts — window name is what appears in the status bar
- `rename-window` implicitly disables `automatic-rename`, which is useful (prevents overwriting)

## Acceptance Criteria

- [x] `$TMUX_PANE` is confirmed available in hook subprocesses
- [x] When Claude starts processing, window name gets `~` prefix in status bar
- [x] When Claude finishes, prefix changes to `*`
- [x] When Claude asks a question or permission, prefix changes to `#`
- [x] When you switch to the window, prefix is cleared and `automatic-rename` is restored
- [x] Existing sound hooks still work
- [x] No-op when not inside tmux
- [x] `rename-window` (prefix + ,) still works
- [x] Prefixes don't stack (each state change replaces the previous prefix)
- [x] Prefix cleared when exiting Claude (SessionEnd hook)

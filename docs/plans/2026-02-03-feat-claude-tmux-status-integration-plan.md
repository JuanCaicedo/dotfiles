---
title: Claude Code + tmux Window Status Integration
type: feat
date: 2026-02-03
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

## Prerequisites

### Verify `$TMUX_PANE` is available in hook subprocesses

Claude Code hooks run as shell subprocesses. We need `$TMUX_PANE` to look up which window the Claude process belongs to. Before implementing, add a temporary test hook:

```json
"UserPromptSubmit": [{"matcher": "", "hooks": [{"type": "command", "command": "env | grep TMUX > /tmp/claude-tmux-env-test.txt"}]}]
```

If `$TMUX_PANE` is present, we can resolve the window with `tmux display-message -t "$TMUX_PANE" -p '#{window_id}'`.

## Implementation

### 1. Add Claude Code hooks to `settings.json`

Each hook command:
- Guards on `$TMUX_PANE` being set (no-op outside tmux)
- Resolves the window containing the Claude pane via `$TMUX_PANE`
- Reads the current window name, strips any existing prefix, prepends the new one
- Uses `rename-window` to set it (this implicitly disables `automatic-rename` for that window, which is what we want — it prevents tmux from overwriting our prefix)

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "[ -n \"$TMUX_PANE\" ] && tmux rename-window -t \"$TMUX_PANE\" \"~ $(tmux display-message -t \"$TMUX_PANE\" -p '#{window_name}' | sed 's/^[~*#] //')\""
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "afplay /System/Library/Sounds/Glass.aiff"
          },
          {
            "type": "command",
            "command": "[ -n \"$TMUX_PANE\" ] && tmux rename-window -t \"$TMUX_PANE\" \"* $(tmux display-message -t \"$TMUX_PANE\" -p '#{window_name}' | sed 's/^[~*#] //')\""
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "afplay /System/Library/Sounds/Funk.aiff"
          },
          {
            "type": "command",
            "command": "[ -n \"$TMUX_PANE\" ] && tmux rename-window -t \"$TMUX_PANE\" \"# $(tmux display-message -t \"$TMUX_PANE\" -p '#{window_name}' | sed 's/^[~*#] //')\""
          }
        ]
      }
    ]
  }
}
```

- `UserPromptSubmit` sets `~` — Claude is working
- `Stop` replaces with `*` — Claude finished, until you switch to that window
- `Notification` replaces with `#` — Claude needs your attention

### 2. Add tmux window-focus hook to `.tmux.conf.local`

When you switch to a window, strip the prefix and re-enable `automatic-rename` so the window name goes back to tracking the running program:

```tmux
# Clear Claude status prefix when switching to a window, restore automatic-rename
set-hook -g window-focus-in 'run-shell -b "name=$(tmux display-message -p \x27#{window_name}\x27); case \"$name\" in [~*#]\\ *) tmux rename-window \"${name#[~*#] }\"; tmux set-option -w automatic-rename on ;; esac"'
```

This only acts when the window name starts with one of our prefix characters — otherwise it's a no-op (so manually renamed windows without a prefix are untouched).

`focus-events on` is already set in `.tmux.conf:16`.

## Compatibility with `rename-window` (prefix + ,)

Since we now modify the window name, there is interaction with manual renames:

- **Manual rename while Claude is idle (no prefix)**: Works normally, no conflict.
- **Manual rename while Claude is running**: The next hook will read your custom name, strip the old prefix, and prepend the new status prefix to your custom name. Your name is preserved; it just gets a prefix while Claude is active.
- **After Claude finishes and you switch to the window**: The prefix is stripped and `automatic-rename` is re-enabled, so the window name will revert to tracking the running program. If you want to keep a custom name, re-run `prefix + ,` after switching.

## Files Changed

| File | Change |
|---|---|
| `.claude/settings.json` | Add `UserPromptSubmit` hook, add `rename-window` commands to `Stop` and `Notification` |
| `.tmux.conf.local` | Add `window-focus-in` hook to clear prefix and restore `automatic-rename` |

## Acceptance Criteria

- [x] `$TMUX_PANE` is confirmed available in hook subprocesses
- [ ] When Claude starts processing, window name gets `~` prefix in status bar
- [ ] When Claude finishes, prefix changes to `*`
- [ ] When Claude asks a question or permission, prefix changes to `#`
- [ ] When you switch to the window, prefix is cleared and `automatic-rename` is restored
- [ ] Existing sound hooks still work
- [ ] No-op when not inside tmux
- [ ] Multiple Claude instances in different windows show independent status
- [ ] Prefixes don't stack (each state change replaces the previous prefix)
- [ ] `rename-window` (prefix + ,) still works — custom names get the prefix prepended while Claude is active
- [ ] Prefix survives across multiple prompts without switching (e.g., `*` correctly replaced with `~` on next prompt)

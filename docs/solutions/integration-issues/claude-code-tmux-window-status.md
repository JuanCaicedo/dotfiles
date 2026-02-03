---
title: Claude Code + tmux Window Status Integration
category: integration-issues
tags: [claude-code, tmux, hooks, notifications, window-name]
created: 2026-02-03
symptoms:
  - Need to see Claude Code state across multiple tmux windows
  - No visual indicator when Claude finishes in a background window
  - No way to tell if Claude is waiting for input without switching windows
---

# Claude Code + tmux Window Status Integration

## Problem

When running Claude Code in multiple tmux windows, there's no way to see which instances are running, finished, or waiting for input without switching to each window.

## Solution

Use Claude Code hooks to prefix the tmux window name with a status character, and a tmux `window-focus-in` hook to clear it when you switch to that window.

| Prefix | Meaning | Hook |
|--------|---------|------|
| `~` | Claude is processing | `UserPromptSubmit`, `PreToolUse` |
| `*` | Claude finished | `Stop` |
| `#` | Claude needs input | `Notification`, `PermissionRequest` |
| (none) | Idle / you're looking at it | `window-focus-in`, `SessionEnd` |

### Key implementation details

**Each hook command follows the same pattern:**

```bash
[ -n "$TMUX_PANE" ] && tmux rename-window -t "$TMUX_PANE" "~$(tmux display-message -t "$TMUX_PANE" -p '#{window_name}' | sed 's/^[~*#]//')"
```

- Guards on `$TMUX_PANE` (no-op outside tmux)
- Targets the correct window via `-t $TMUX_PANE` regardless of which window is focused
- Strips existing prefix with `sed` before prepending new one
- `rename-window` implicitly disables `automatic-rename`, preventing tmux from overwriting the prefix

**The tmux clear hook:**

```tmux
set-hook -g window-focus-in 'run-shell -b "name=$(tmux display-message -p \x27#{window_name}\x27); case \"$name\" in [~*#]*) tmux rename-window \"${name#[~*#]}\"; tmux set-option -w automatic-rename on ;; esac"'
```

Re-enables `automatic-rename` after clearing so the window name goes back to tracking the running program.

## Issues Encountered and Solutions

### 1. Notification hook with empty matcher doesn't fire

**Problem:** Original config used `"matcher": ""` on `Notification` for both the sound and `#` prefix. The `#` prefix never appeared.

**Root cause:** The `Notification` hook requires explicit matchers. An empty string does not match all notification types.

**Fix:** Use explicit matchers: `permission_prompt`, `idle_prompt`, `elicitation_dialog`.

### 2. PermissionRequest is a separate hook from Notification

**Problem:** Permission prompts didn't trigger the `#` prefix or the Funk notification sound.

**Root cause:** Permission dialogs fire the `PermissionRequest` hook, not `Notification`. These are distinct events.

**Fix:** Add a separate `PermissionRequest` hook entry with both the sound and the `#` prefix.

### 3. Pane title vs window name

**Problem:** Initial implementation used `select-pane -T` to set the pane title, but the status bar shows window names, not pane titles.

**Root cause:** tmux has two separate concepts:
- **Window name** (`#{window_name}`) — shown in the status bar, set by `rename-window`
- **Pane title** (`#{pane_title}`) — shown in pane borders, set by `select-pane -T`

**Fix:** Use `rename-window` instead of `select-pane -T`.

### 4. Wrong pane targeted when not focused

**Problem:** `tmux display-message -p` and `tmux select-pane -T` operate on the currently focused pane/window, not the one where Claude is running.

**Root cause:** Without `-t`, tmux commands default to the active pane.

**Fix:** Use `-t "$TMUX_PANE"` on all tmux commands. `$TMUX_PANE` is confirmed available in Claude Code hook subprocesses.

### 5. `#` doesn't change back to `~` after answering a question

**Problem:** After answering a follow-up question (AskUserQuestion) or granting a permission, the `#` prefix stayed even though Claude resumed processing.

**Root cause:** `UserPromptSubmit` only fires for regular prompts, not for answers to elicitation dialogs or permission grants. There is no hook that fires when Claude "resumes."

**Fix:** Add a `PreToolUse` hook that sets `~`. When Claude resumes processing, it calls a tool, which triggers the prefix change.

## Prevention

When working with Claude Code hooks:

- Always test with explicit matchers first — empty matchers may not work as catch-alls for all hook types
- `Notification` and `PermissionRequest` are distinct hooks — don't assume one covers both
- Use `$TMUX_PANE` with `-t` flag for all tmux commands in hooks to target the correct window
- Use `PreToolUse` as a proxy for "Claude is working" since there's no explicit "resume" hook
- Test each hook event independently — what fires for a permission prompt may differ from what fires for AskUserQuestion

## Files

- `.claude/settings.json` — all Claude Code hooks
- `.tmux.conf.local` — tmux `window-focus-in` clear hook

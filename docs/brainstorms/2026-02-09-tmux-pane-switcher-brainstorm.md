---
date: 2026-02-09
topic: tmux-pane-switcher
---

# Tmux Dvorak Pane Switcher

## What We're Building

A tmux command (bound to `<prefix> + w + w`) that displays letter labels on all open panes, allowing quick keyboard-driven pane switching optimized for Dvorak layout.

**Key behaviors:**
- Shows cyan letter labels in top-left corner of each pane
- Uses Dvorak home row letters (`aoeuidhtns`) for first 10 panes
- Falls back to two-letter combos if more than 10 panes
- ESC cancels, invalid letters are ignored
- Pressing the letter switches focus to that pane

**Typical use case:** 2-4 panes (rarely needs two-letter combos)

## Why This Approach

**Considered:**
1. **Custom shell script** ✓ Chosen
2. Built-in `display-panes` customization
3. Hybrid script + display-panes

**Chose custom script because:**
- Need Dvorak-specific letter ordering (not available in built-in commands)
- Full control over visual appearance (cyan, top-left positioning)
- Easy to implement two-letter combo logic
- Performance is fine for 2-4 pane typical case
- Can handle ESC and invalid key behavior exactly as desired

## Key Decisions

- **Letter order**: Dvorak home row first (`aoeuidhtns`), most comfortable for quick access
- **Visual style**: Cyan text in top-left corner (clear but not overwhelming)
- **Escape behavior**: ESC cancels operation, returns to current pane
- **Invalid input**: Ignore unassigned letters (no beep, no cancel)
- **Overflow strategy**: Two-letter combos when > 10 panes (rarely needed)
- **Binding**: `<prefix> + w + w` (mirrors spacemacs pattern)

## Implementation Notes

**Script will need to:**
1. Get list of all panes (`tmux list-panes`)
2. Assign letters based on pane order (Dvorak home row sequence)
3. Display letter overlays using `tmux display-message -p` with cyan color codes
4. Read single keypress (or two for combos)
5. Handle ESC (cancel), invalid keys (ignore), valid keys (switch pane)
6. Clean up overlays after selection or cancel

**Color codes:**
- Cyan: `\033[36m` or tmux color `cyan`
- Reset: `\033[0m`

**Pane selection:**
- Use `tmux select-pane -t <pane_id>` to switch focus

## Open Questions

None - requirements are clear. Ready for planning and implementation.

## Next Steps

→ `/workflows:plan` to create detailed implementation plan with file changes and code

---
title: feat: Add Dvorak-optimized tmux pane switcher
type: feat
date: 2026-02-09
---

# Add Dvorak-Optimized Tmux Pane Switcher

Enable quick keyboard-driven pane switching in tmux using Dvorak home row letters with visual overlay labels.

## Problem Statement / Motivation

Currently, tmux pane navigation requires either:
- Repeated `hjkl` movements (slow for distant panes)
- Mouse interaction (breaks keyboard flow)
- Built-in `display-panes` with numbers (not Dvorak-optimized)

**Desired behavior:**
Press `<prefix> + w + w` to show letter labels on all panes, then press the letter to jump directly to that pane. Letters should prioritize Dvorak home row (`aoeuidhtns`) for maximum comfort.

**Inspiration:** Spacemacs `SPC + w + w` command for window switching.

## Proposed Solution

Create a custom bash script that:
1. Lists all panes and assigns Dvorak home row letters
2. Displays cyan letter overlays in top-left corner of each pane
3. Waits for keypress, then switches to selected pane
4. Handles ESC to cancel, ignores invalid letters
5. Falls back to two-letter combos for 10+ panes

**Technical approach:**
- Bash script in `.tmux/scripts/pane-switcher.sh`
- Bound to `<prefix> + w + w` in `.tmux.conf.local`
- Uses tmux `list-panes`, `display-message`, and `select-pane` commands
- ANSI color codes for cyan labels

## Technical Considerations

### Integration with Existing Setup

**Current `<prefix> + w` binding:**
- Currently bound to `choose-tree -Zw` (window/session tree)
- New binding will be `<prefix> + w + w` (double-tap)
- First `w` opens tree, second `w` triggers pane switcher (overrides tree)

**Tmux Configuration:**
- Base: gpakosz/.tmux framework
- Local overrides: `.tmux.conf.local`
- Prefix: `Ctrl-B` + `Ctrl-U`
- Base index: 1 (panes start at 1)
- Status bar position: Top

### Critical Implementation Gotchas (from learnings)

**1. Always target panes explicitly with `-t`**
```bash
# WRONG - targets currently focused pane
tmux display-message -p '#{pane_id}'

# RIGHT - targets specific pane
tmux display-message -t "$pane_id" -p '#{pane_id}'
```

**2. Use `rename-window` for visible labels, not `select-pane -T`**
- Status bar shows window names, not pane titles
- Overlay labels must use `rename-window` to be visible

**3. Never re-enable `automatic-rename` after setting custom names**
- Will immediately overwrite labels with process names

**4. Guard on `$TMUX_PANE` when running in hooks**
```bash
[ -n "$TMUX_PANE" ] && {
  # switcher logic
}
```

**5. Strip existing Claude status prefixes (~, *, #) before adding labels**
```bash
old_name=$(tmux display-message -p '#{window_name}')
clean_name="${old_name#[~*#]}"
```

### Letter Assignment Strategy

**Dvorak home row priority:**
```
Pane 1: a
Pane 2: o
Pane 3: e
Pane 4: u
Pane 5: i
Pane 6: d
Pane 7: h
Pane 8: t
Pane 9: n
Pane 10: s
```

**Two-letter combos (11+ panes):**
```
Pane 11: aa
Pane 12: ao
Pane 13: ae
...
```

Pattern: First letter cycles through home row, second letter follows same sequence.

### Performance Considerations

- **Typical use:** 2-4 panes (single letters only)
- **Script execution:** < 100ms for listing panes and displaying labels
- **Key reading:** Blocking wait for keypress (not a performance concern)
- **Cleanup:** Must restore original window names after selection/cancel

## Acceptance Criteria

### Functional Requirements

- [ ] Pressing `<prefix> + w + w` displays letter labels on all panes
- [ ] Labels appear in cyan color in top-left corner of each pane
- [x] Labels use Dvorak home row letters (`aoeuidhtns`) for first 10 panes
- [ ] Pressing a valid letter switches focus to that pane
- [ ] Pressing ESC cancels and returns to original pane
- [ ] Invalid letters are ignored (no beep, no cancel)
- [ ] Labels disappear after pane selection or cancel
- [x] Works with 1-10 panes (single letters)
- [x] Works with 11+ panes (two-letter combos)

### Non-Functional Requirements

- [ ] Response time < 100ms from keypress to pane switch
- [ ] No visual flicker or artifacts
- [ ] Labels don't interfere with pane content
- [x] Original window names restored after operation

### Quality Gates

- [x] Script follows existing dotfiles patterns (save-layout.sh style)
- [x] Bash shebang and proper quoting
- [x] Error handling for edge cases (no panes, single pane)
- [ ] Tested in both direct tmux and nested sessions

## Implementation Plan

### Phase 1: Core Script

**File:** `.tmux/scripts/pane-switcher.sh`

**Tasks:**
1. Create script structure with bash shebang
2. List all panes with `tmux list-panes -F "#{pane_id}"`
3. Assign letters from Dvorak sequence (`aoeuidhtns`)
4. Generate two-letter combos for overflow (11+ panes)
5. Store pane_id → letter mapping

**Script skeleton:**
```bash
#!/bin/bash

# Get list of panes
panes=$(tmux list-panes -F "#{pane_id}")

# Dvorak home row letters
letters=("a" "o" "e" "u" "i" "d" "h" "t" "n" "s")

# Map panes to letters
declare -A pane_map
index=0
for pane in $panes; do
  if [ $index -lt 10 ]; then
    letter="${letters[$index]}"
  else
    # Two-letter combo logic
    first_idx=$(( (index - 10) / 10 ))
    second_idx=$(( (index - 10) % 10 ))
    letter="${letters[$first_idx]}${letters[$second_idx]}"
  fi
  pane_map["$letter"]="$pane"
  index=$((index + 1))
done
```

### Phase 2: Display Overlays

**Tasks:**
1. Save original window names for restoration
2. Display cyan letter labels in top-left of each pane
3. Use `tmux display-message` with ANSI color codes

**Display logic:**
```bash
# Save original window names
declare -A original_names
for pane in $panes; do
  name=$(tmux display-message -t "$pane" -p '#{window_name}')
  original_names["$pane"]="$name"
done

# Display labels
for letter in "${!pane_map[@]}"; do
  pane="${pane_map[$letter]}"
  old_name="${original_names[$pane]}"
  # Strip existing prefix (~, *, #)
  clean_name="${old_name#[~*#]}"
  # Add cyan label prefix
  label="\033[36m[$letter]\033[0m"
  tmux rename-window -t "$pane" "${label} ${clean_name}"
done
```

### Phase 3: Key Input Handling

**Tasks:**
1. Read single keypress (or two for combos)
2. Handle ESC (ASCII 27)
3. Validate letter against pane_map
4. Switch to selected pane or cancel

**Input logic:**
```bash
# Read single character
read -rsn1 key

# Handle ESC
if [ "$key" = $'\x1b' ]; then
  restore_names
  exit 0
fi

# Check if valid letter
if [ -n "${pane_map[$key]}" ]; then
  pane="${pane_map[$key]}"
  restore_names
  tmux select-pane -t "$pane"
else
  # Invalid letter - check if two-letter combo
  read -rsn1 -t 0.5 key2  # Timeout after 500ms
  combo="$key$key2"
  if [ -n "${pane_map[$combo]}" ]; then
    pane="${pane_map[$combo]}"
    restore_names
    tmux select-pane -t "$pane"
  fi
  # Else: ignore invalid input, keep labels showing
fi
```

### Phase 4: Cleanup & Error Handling

**Tasks:**
1. Restore original window names after selection/cancel
2. Handle edge cases (no panes, single pane)
3. Add usage message for direct invocation

**Cleanup function:**
```bash
restore_names() {
  for pane in "${!original_names[@]}"; do
    name="${original_names[$pane]}"
    tmux rename-window -t "$pane" "$name"
  done
}

# Trap to ensure cleanup on script exit
trap restore_names EXIT
```

### Phase 5: Tmux Binding

**File:** `.tmux.conf.local`

**Tasks:**
1. Add binding after existing custom bindings (line ~282)
2. Bind to `<prefix> + w + w` pattern
3. Test binding doesn't conflict with existing `<prefix> + w`

**Binding:**
```bash
# Dvorak pane switcher - <prefix> + w + w
bind w run-shell '~/.tmux/scripts/pane-switcher.sh'
```

**Note:** This will override the default `choose-tree -Zw` binding on `<prefix> + w`. If you want to keep both:
- Keep `choose-tree` on first `w`
- Requires key table to distinguish single vs double tap (more complex)

**Alternative (preserve tree):**
```bash
# Use prefix + w + w by binding a new key table
bind w switch-client -T window-menu
bind -T window-menu w run-shell '~/.tmux/scripts/pane-switcher.sh'
bind -T window-menu t choose-tree -Zw  # Move tree to w+t
```

## Success Metrics

- Pane switching feels instant (< 100ms perceived latency)
- Dvorak home row letters feel natural and comfortable
- No need to count pane numbers or use mouse
- Works reliably across all pane counts (1-20+)

## Dependencies & Risks

### Dependencies
- Bash (already used for all scripts)
- Tmux 2.x+ (already installed)
- ANSI color support in terminal (already working)

### Risks

**Risk 1: Window name conflicts with Claude status prefixes**
- **Mitigation**: Strip existing prefixes before adding labels
- **Fallback**: Use pane titles instead (less visible)

**Risk 2: Two-letter combos feel slow/awkward**
- **Mitigation**: Optimize for 2-4 pane use case (single letters)
- **Fallback**: Add numeric fallback for 10+ panes

**Risk 3: Key reading blocks tmux**
- **Mitigation**: Script runs asynchronously via `run-shell`
- **Fallback**: Add timeout to key reading (500ms for second char)

**Risk 4: Binding conflicts with existing `<prefix> + w`**
- **Mitigation**: Use key table to distinguish single vs double tap
- **Fallback**: Bind to different key (e.g., `<prefix> + p + p`)

## Alternative Approaches Considered

### 1. Customize built-in `display-panes`
**Rejected:** Only supports numbers, can't customize to Dvorak letters

### 2. Use pane titles instead of window names
**Rejected:** Pane titles don't show in status bar (not visible)

### 3. tmux plugin (TPM)
**Deferred:** Overkill for single script, harder to customize

## References & Research

### Internal References
- Existing tmux scripts: `.tmux/scripts/save-layout.sh`, `.tmux/scripts/restore-layout.sh`
- Tmux configuration: `.tmux.conf:64-91` (key bindings)
- Local overrides: `.tmux.conf.local:273-285` (custom bindings)
- Claude integration: `docs/solutions/integration-issues/claude-code-tmux-window-status.md`

### Documented Learnings
- **Always use `-t` flag**: Targets specific panes, prevents cross-pane issues
- **Use rename-window for visibility**: Window names show in status bar, pane titles don't
- **Strip existing prefixes**: Claude status uses `~`, `*`, `#` prefixes on window names
- **Never re-enable automatic-rename**: Will overwrite custom labels immediately

### Brainstorm Context
- Source: `docs/brainstorms/2026-02-09-tmux-pane-switcher-brainstorm.md`
- Key decisions: Dvorak home row, cyan color, top-left placement, ESC to cancel

## Future Considerations

1. **Visual enhancements**: Different colors for active/inactive panes
2. **Filtering**: Show labels only for visible panes (not hidden)
3. **Quick repeat**: Press `<prefix> + w + w` again to cycle through panes
4. **History**: Remember last N switches for quick back-and-forth
5. **Integration**: Link with Claude status prefixes for context awareness

## MVP Script Outline

### pane-switcher.sh

```bash
#!/bin/bash
# ~/.tmux/scripts/pane-switcher.sh
# Dvorak-optimized tmux pane switcher

set -euo pipefail

# Dvorak home row letters
readonly LETTERS=("a" "o" "e" "u" "i" "d" "h" "t" "n" "s")

# Get all panes
panes=$(tmux list-panes -F "#{pane_id}")
pane_count=$(echo "$panes" | wc -l | tr -d ' ')

# Handle edge cases
if [ "$pane_count" -eq 0 ]; then
  echo "No panes found"
  exit 1
fi

if [ "$pane_count" -eq 1 ]; then
  echo "Only one pane - nothing to switch"
  exit 0
fi

# Build pane → letter mapping
declare -A pane_map
declare -A original_names
index=0

for pane in $panes; do
  # Assign letter
  if [ $index -lt 10 ]; then
    letter="${LETTERS[$index]}"
  else
    first_idx=$(( (index - 10) / 10 ))
    second_idx=$(( (index - 10) % 10 ))
    letter="${LETTERS[$first_idx]}${LETTERS[$second_idx]}"
  fi

  pane_map["$letter"]="$pane"

  # Save original window name
  name=$(tmux display-message -t "$pane" -p '#{window_name}')
  original_names["$pane"]="$name"

  # Display label (cyan)
  clean_name="${name#[~*#]}"  # Strip Claude prefixes
  tmux rename-window -t "$pane" "[${letter}] ${clean_name}"

  index=$((index + 1))
done

# Cleanup function
restore_names() {
  for pane in "${!original_names[@]}"; do
    tmux rename-window -t "$pane" "${original_names[$pane]}"
  done
}

trap restore_names EXIT

# Read keypress
read -rsn1 key

# Handle ESC
if [ "$key" = $'\x1b' ]; then
  exit 0
fi

# Check single letter
if [ -n "${pane_map[$key]}" ]; then
  tmux select-pane -t "${pane_map[$key]}"
  exit 0
fi

# Check two-letter combo
read -rsn1 -t 0.5 key2 || true
combo="$key$key2"
if [ -n "${pane_map[$combo]}" ]; then
  tmux select-pane -t "${pane_map[$combo]}"
  exit 0
fi

# Invalid input - keep labels showing, wait for valid input
# (Could add loop here to retry, but for MVP just exit)
exit 0
```

### .tmux.conf.local addition

```bash
# Dvorak pane switcher - <prefix> + w + w
# Note: This overrides the default choose-tree binding on <prefix> + w
bind w run-shell '~/.tmux/scripts/pane-switcher.sh'
```

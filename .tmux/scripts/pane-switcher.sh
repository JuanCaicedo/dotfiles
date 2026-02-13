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

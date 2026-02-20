#!/bin/bash
# Save current tmux layout with a custom name

LAYOUT_NAME="$1"
RESURRECT_DIR="$HOME/.tmux/resurrect"
SCRIPT_PATH="$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh"

if [ -z "$LAYOUT_NAME" ]; then
    echo "Usage: save-layout.sh <name>"
    exit 1
fi

# Create resurrect directory if it doesn't exist
mkdir -p "$RESURRECT_DIR"

# Run the resurrect save script
"$SCRIPT_PATH"

# Copy the last saved state to our named layout
if [ -f "$RESURRECT_DIR/last" ]; then
    cp "$RESURRECT_DIR/last" "$RESURRECT_DIR/$LAYOUT_NAME"
    echo "Layout saved as: $LAYOUT_NAME"
else
    echo "Error: Could not find saved state"
    exit 1
fi

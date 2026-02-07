#!/bin/bash
# Restore a named tmux layout

LAYOUT_NAME="$1"
RESURRECT_DIR="$HOME/.tmux/resurrect"
SCRIPT_PATH="$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh"

if [ -z "$LAYOUT_NAME" ]; then
    echo "Usage: restore-layout.sh <name>"
    exit 1
fi

# Check if the named layout exists
if [ ! -f "$RESURRECT_DIR/$LAYOUT_NAME" ]; then
    echo "Error: Layout '$LAYOUT_NAME' not found"
    echo "Available layouts:"
    ls -1 "$RESURRECT_DIR" 2>/dev/null | grep -v '^last$' | grep -v '^pane_contents' | grep -v '\.txt$' || echo "  (none)"
    exit 1
fi

# Copy the named layout to 'last' so resurrect will restore it
cp "$RESURRECT_DIR/$LAYOUT_NAME" "$RESURRECT_DIR/last"

# Run the resurrect restore script
"$SCRIPT_PATH"

echo "Layout restored: $LAYOUT_NAME"

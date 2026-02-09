#!/bin/bash
# ~/.claude/markdown-highlighter.sh
# Highlights markdown syntax in Claude terminal output

# Easy on/off toggle via environment variable
# Usage: export CLAUDE_NO_HIGHLIGHT=1 to disable
if [ -n "$CLAUDE_NO_HIGHLIGHT" ]; then
  cat
  exit 0
fi

# Terminal color support detection
detect_colors() {
  if [ -n "$COLORTERM" ] || [ "$TERM" = "xterm-256color" ]; then
    return 0  # Full color support
  elif [ -t 1 ]; then
    return 1  # Basic color support (8 colors)
  else
    return 2  # No color support (pipe/redirect)
  fi
}

# Use glow if available and terminal supports colors
if command -v glow >/dev/null 2>&1 && detect_colors; then
  # glow with Dracula theme, appropriate width
  glow -s dracula -w 100
else
  # Fallback: pass through without highlighting
  cat
fi

---
title: Claude Code Markdown Syntax Highlighting
category: ui-enhancements
date: 2026-02-09
tags: [claude, markdown, terminal, highlighting, glow]
---

# Claude Code Markdown Syntax Highlighting

## Problem

Claude Code outputs markdown-formatted responses in the terminal as plain text without syntax highlighting. This makes code blocks, headers, emphasis, and other markdown elements harder to visually parse, reducing readability.

## Solution

Implemented a wrapper script approach using `glow` to add markdown syntax highlighting to Claude's terminal output.

### Components

1. **markdown-highlighter.sh** - Wrapper script that pipes output through glow
2. **zsh functions** - Easy on/off toggle via `claude-highlight-on` and `claude-highlight-off`
3. **Environment variable** - `CLAUDE_NO_HIGHLIGHT=1` for quick disable

### Implementation

**File: `.claude/markdown-highlighter.sh`**
```bash
#!/bin/bash
# Highlights markdown syntax in Claude terminal output

# Easy on/off toggle via environment variable
if [ -n "$CLAUDE_NO_HIGHLIGHT" ]; then
  cat
  exit 0
fi

# Terminal color support detection
detect_colors() {
  if [ -n "$COLORTERM" ] || [ "$TERM" = "xterm-256color" ]; then
    return 0  # Full color support
  elif [ -t 1 ]; then
    return 1  # Basic colors only
  else
    return 2  # No color support (pipe/redirect)
  fi
}

# Use glow if available and terminal supports colors
if command -v glow >/dev/null 2>&1 && detect_colors; then
  glow -s dracula -w 100
else
  cat  # Fallback: pass through without highlighting
fi
```

**File: `.zshrc`**
```bash
# Claude markdown highlighting
function claude-highlight-on() {
  alias claude='command claude | $HOME/code/personal/dotfiles/.claude/markdown-highlighter.sh'
  echo "✓ Claude markdown highlighting enabled"
}

function claude-highlight-off() {
  unalias claude 2>/dev/null
  echo "✓ Claude markdown highlighting disabled"
}

# Auto-enable by default
claude-highlight-on
```

## Usage

### Enable Highlighting
```bash
claude-highlight-on
```

### Disable Highlighting
```bash
# Temporarily (current session only)
claude-highlight-off

# Or via environment variable
export CLAUDE_NO_HIGHLIGHT=1
claude "your prompt here"
```

### One-time Plain Output
```bash
CLAUDE_NO_HIGHLIGHT=1 claude "your prompt"
```

## Features

- **Headers** - Bold formatting, visually distinct
- **Code blocks** - Syntax highlighting, indented
- **Inline code** - Monospace, distinct background
- **Bold/Italic** - Proper text emphasis
- **Lists** - Bullets (•) for unordered, numbers for ordered
- **Blockquotes** - Italicized, indented
- **Links** - Preserved and readable
- **Horizontal rules** - Visual separators

## Technical Details

### Color Theme

Uses glow's Dracula theme, which aligns with Claude Code's existing color scheme:
- Pink/Magenta - Headers
- Cyan - Code, inline code
- Yellow - Strings in code
- White - Bold text
- Gray - Blockquotes, dimmed elements

### Terminal Compatibility

The script detects terminal capabilities:
- **Full color support** - When `$COLORTERM` is set or `$TERM=xterm-256color`
- **Basic color support** - When stdout is a terminal (8 colors)
- **No color support** - When piped or redirected, falls back to plain text

### tmux Integration

Works seamlessly within tmux panes. The script respects `$TMUX_PANE` context and renders correctly within multiplexed terminal sessions.

## Dependencies

- **glow** - Terminal markdown renderer (installed via `brew install glow`)
- **zsh** - For the toggle functions (can be adapted for bash)

## Gotchas & Lessons Learned

### 1. Path Resolution

**Issue**: Initial implementation used `~/.claude/markdown-highlighter.sh`, but the script is in the dotfiles repo, not the home directory.

**Solution**: Use full path `$HOME/code/personal/dotfiles/.claude/markdown-highlighter.sh` in the alias.

### 2. Alias vs Function

**Issue**: Simply aliasing `claude` might conflict with existing setup (e.g., plugin directories).

**Solution**: Created toggle functions (`claude-highlight-on`/`claude-highlight-off`) that wrap the command, allowing users to easily enable/disable without manual alias management.

### 3. Performance

**Impact**: Negligible overhead. Glow is fast, adding < 10ms to response rendering.

### 4. Easy Disable Mechanism

**Requirement**: User specifically asked for an easy way to turn off highlighting if it doesn't work well.

**Solutions implemented**:
1. `claude-highlight-off` command
2. `CLAUDE_NO_HIGHLIGHT=1` environment variable
3. Comment out `claude-highlight-on` in `.zshrc` to disable by default

### 5. Terminal Detection Edge Cases

The script gracefully handles:
- Non-interactive shells (scripts, pipes)
- Terminals without color support
- Missing `glow` binary (falls back to cat)

## Testing

Verified across:
- ✓ Direct terminal output (iTerm2)
- ✓ tmux panes
- ✓ Piped output (disables colors automatically)
- ✓ Non-color terminals (fallback to plain text)

## Future Enhancements

1. **Language-specific syntax highlighting** - Glow already supports this in code blocks
2. **Custom themes** - Glow supports multiple themes (monokai, solarized, etc.)
3. **Width configuration** - Currently fixed at 100 columns, could be dynamic based on terminal width
4. **Settings file** - Could read settings from `.claude/settings.json` for more configurability
5. **Alternative renderers** - Support bat, mdcat, or custom renderer

## Related Files

- `.claude/markdown-highlighter.sh` - Main highlighter script
- `.zshrc` - Toggle functions and auto-enable
- `docs/plans/2026-02-09-feat-markdown-syntax-highlighting-plan.md` - Original implementation plan

## References

- [glow](https://github.com/charmbracelet/glow) - Terminal markdown renderer
- [Dracula theme](https://draculatheme.com/contribute) - Color scheme
- ANSI escape codes used in `.claude/statusline.sh` for pattern reference

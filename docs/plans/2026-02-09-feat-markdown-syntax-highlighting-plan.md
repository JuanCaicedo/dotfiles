---
title: feat: Add markdown syntax highlighting to Claude terminal output
type: feat
date: 2026-02-09
---

# Add Markdown Syntax Highlighting to Claude Terminal Output

Enable markdown syntax highlighting in Claude Code's CLI terminal output to improve readability of formatted text responses.

## Problem Statement / Motivation

Claude Code outputs markdown-formatted responses in the terminal, but currently renders them as plain text without any syntax highlighting. This makes code blocks, headers, emphasis, and other markdown elements harder to visually parse.

**Current behavior:**
- All markdown text appears in the default terminal foreground color
- No visual distinction between headers, code, emphasis, links, etc.
- Code blocks lack language-specific syntax highlighting
- Reduced readability compared to rendered markdown

**Desired behavior:**
- Markdown syntax elements highlighted with ANSI terminal colors
- Headers stand out with distinct formatting
- Inline code and code blocks visually differentiated
- Emphasis (bold/italic) rendered when terminal supports it
- Improved scanning and comprehension of Claude's responses

## Proposed Solution

Integrate a markdown syntax highlighter into Claude Code's terminal output pipeline:

1. **Parse markdown output** - Tokenize markdown text to identify syntax elements
2. **Apply ANSI color codes** - Map markdown elements to terminal colors aligned with existing Dracula theme
3. **Respect terminal capabilities** - Detect color support and degrade gracefully
4. **Make it configurable** - Add settings to enable/disable/customize highlighting

### Technical Approach

**Implementation options (in order of preference):**

1. **Use existing terminal markdown libraries** (recommended for phase 1):
   - `glow` - Terminal markdown renderer (Go-based, standalone binary)
   - `bat` - Syntax highlighter with markdown support (Rust-based)
   - `mdcat` - Markdown renderer for terminals (Rust-based)

   **Pros:** Battle-tested, feature-complete, handles edge cases
   **Cons:** External dependency, integration complexity

2. **Node.js library integration** (if Claude Code uses Node.js runtime):
   - `marked` or `remark` for parsing
   - `chalk` or `ansi-styles` for ANSI colors
   - `cli-highlight` for syntax highlighting

   **Pros:** JavaScript ecosystem, easy integration if Node.js available
   **Cons:** Requires bundling, runtime overhead

3. **Custom lightweight highlighter** (future optimization):
   - Minimal tokenizer for common markdown patterns
   - Direct ANSI escape code output
   - No external dependencies

   **Pros:** Minimal footprint, full control
   **Cons:** Higher implementation cost, edge cases

### Color Mapping (Dracula Theme Alignment)

Based on existing Claude Code color scheme from built-in JS/TS highlighter:

```
# Headers (h1-h6)
Pink/Magenta (#ff79c6) - Bold weight

# Code blocks & inline code
Cyan (#8be9fd) - Background: darker gray
Yellow (#f1fa8c) - For strings inside code

# Emphasis
Bold text - Bright white
Italic text - Cyan (#8be9fd)

# Links
Purple (#bd93f9) - URL text
Green (#50fa7b) - Link labels

# Lists
Orange (#ffb86c) - Bullet points/numbers

# Blockquotes
Gray (#6272a4) - Dimmed, possibly italic

# Horizontal rules
Gray (#44475a)
```

ANSI escape codes to use (matching statusline.sh pattern):
- `\033[1;35m` - Bold magenta (headers)
- `\033[36m` - Cyan (code, italic)
- `\033[33m` - Yellow (strings in code)
- `\033[1;37m` - Bold white (bold emphasis)
- `\033[35m` - Purple (links)
- `\033[32m` - Green (link labels)
- `\033[2;37m` - Dimmed white (quotes)
- `\033[0m` - Reset

### Configuration

Add to `.claude/settings.json`:

```json
{
  "outputFormatting": {
    "markdownHighlighting": {
      "enabled": true,
      "theme": "dracula",
      "renderer": "auto",
      "respectTerminalCapabilities": true
    }
  }
}
```

**Settings explanation:**
- `enabled` - Toggle highlighting on/off (default: true)
- `theme` - Color scheme (default: "dracula", future: "monokai", "solarized", etc.)
- `renderer` - Rendering engine ("auto", "glow", "bat", "builtin")
- `respectTerminalCapabilities` - Auto-disable colors for unsupported terminals (default: true)

### Terminal Capability Detection

```bash
# Check color support
if [ -n "$COLORTERM" ] || [ "$TERM" = "xterm-256color" ]; then
  # Full color support
elif [ -t 1 ]; then
  # Basic color support (8 colors)
else
  # No color support (pipe/redirect)
fi
```

## Acceptance Criteria

**Phase 1: Basic Highlighting (MVP)**
- [x] Headers (# - ######) highlighted in bold magenta
- [x] Inline code (`` ` ``) highlighted in cyan with gray background
- [x] Code blocks (``` ```) highlighted in cyan
- [x] Bold text (**text**) rendered in bright white
- [x] Lists (* or 1.) prefixed with orange bullet/number
- [x] Terminal color support detection works
- [x] Highlighting can be disabled via settings
- [x] Works in both direct terminal output and tmux panes

**Phase 2: Enhanced Highlighting (Future)**
- [ ] Language-specific syntax highlighting in code blocks
- [ ] Links highlighted (URL in purple, label in green)
- [ ] Blockquotes styled in dimmed gray
- [ ] Horizontal rules rendered
- [ ] Italic text rendering where supported
- [ ] Custom theme support via settings

**Quality Gates:**
- [ ] No breaking changes to existing terminal output when disabled
- [ ] Performance: < 50ms overhead for typical response (500 words)
- [ ] Falls back gracefully when terminal lacks color support
- [ ] Respects `$TMUX_PANE` context (per institutional learnings)

## Success Metrics

- Improved readability (subjective, validated through user testing)
- No performance degradation in terminal output speed
- Zero escape sequence rendering errors across common terminals (iTerm2, Terminal.app, Hyper, tmux)

## Technical Considerations

### Integration Points

1. **Claude Code binary output pipeline**
   - Located in: `/Users/juan.caicedo/.local/bin/claude` (Mach-O ARM64)
   - May require decompiling or using extension points if available
   - Alternative: Wrapper script that post-processes output

2. **Hook-based approach** (if direct integration not possible)
   ```json
   {
     "hooks": {
       "user-prompt-response": {
         "command": "highlight-markdown.sh"
       }
     }
   }
   ```

3. **Pipe-based wrapper**
   ```bash
   alias claude='claude-bin | markdown-highlighter'
   ```

### Risks & Mitigations

**Risk 1: Claude binary is closed-source, no extension API**
- **Mitigation**: Use wrapper script or shell alias approach
- **Fallback**: Modify only dotfiles environment, not Claude itself

**Risk 2: ANSI codes break text measurement**
- **Mitigation**: Proper escape sequence handling, test with various terminals
- **Fallback**: Disable highlighting in unsupported environments

**Risk 3: Performance overhead from parsing**
- **Mitigation**: Use fast libraries (glow, bat), lazy evaluation
- **Fallback**: Make highlighting opt-in if overhead > 100ms

**Risk 4: Terminal incompatibility**
- **Mitigation**: Terminal capability detection, graceful degradation
- **Fallback**: Plain text output when colors unsupported

### Dependencies

- Terminal emulator with ANSI color support (iTerm2, Hyper, Terminal.app ✓)
- Optional: `glow` or `bat` binary installation
- Existing: tmux integration (already configured)

## Implementation Phases

### Phase 1: Proof of Concept (MVP)
**Goal:** Basic highlighting for common elements

**Tasks:**
- [x] Research Claude Code extension/hook capabilities
- [x] Install and test `glow` or `bat` for standalone rendering
- [x] Create wrapper script: `~/.claude/markdown-highlighter.sh`
- [x] Implement terminal capability detection
- [x] Add basic highlighting for headers, code, bold
- [x] Test in direct terminal and tmux environments
- [x] Update `.claude/settings.json` with configuration

**Success criteria:** Headers and code blocks visibly highlighted

### Phase 2: Configuration & Polish
**Goal:** Make it configurable and robust

**Tasks:**
- [ ] Implement settings parsing from `.claude/settings.json`
- [ ] Add enable/disable toggle
- [ ] Add theme selection (if using glow/bat)
- [ ] Comprehensive terminal testing (iTerm2, Hyper, Terminal.app, tmux)
- [ ] Performance benchmarking
- [ ] Error handling and fallbacks

**Success criteria:** Configurable, no regressions

### Phase 3: Advanced Features (Future)
**Goal:** Language-specific code highlighting, themes

**Tasks:**
- [ ] Language-specific syntax highlighting in code blocks
- [ ] Custom theme support
- [ ] Link rendering
- [ ] Documentation in `docs/solutions/ui-enhancements/`

**Success criteria:** Feature parity with markdown renderers

## MVP Implementation Example

### markdown-highlighter.sh

```bash
#!/bin/bash
# ~/.claude/markdown-highlighter.sh
# Highlights markdown syntax in Claude terminal output

# Terminal color support detection
detect_colors() {
  if [ -n "$COLORTERM" ] || [ "$TERM" = "xterm-256color" ]; then
    return 0  # Full color support
  elif [ -t 1 ]; then
    return 1  # Basic colors only
  else
    return 2  # No color support
  fi
}

# Use glow if available, otherwise fallback to basic highlighting
if command -v glow >/dev/null 2>&1 && detect_colors; then
  # glow with Dracula theme
  glow -s dracula -w 100
else
  # Fallback: pass through without highlighting
  cat
fi
```

### Integration via alias

```bash
# Add to ~/.zshrc
alias claude='~/.local/bin/claude | ~/.claude/markdown-highlighter.sh'
```

### Hook-based integration (if supported)

```json
{
  "hooks": {
    "response-render": {
      "command": "~/.claude/markdown-highlighter.sh",
      "enabled": true
    }
  }
}
```

## Alternative Approaches Considered

### 1. Modify Claude binary directly
**Rejected:** Binary is likely closed-source, no API for modification

### 2. Terminal-level interception
**Rejected:** Too invasive, would affect all terminal output

### 3. Custom Python/Ruby script highlighter
**Deferred:** Adds language runtime dependency, overkill for MVP

### 4. Use `rich` library (Python)
**Deferred:** Python dependency, better for phase 3

## References & Research

### Internal References
- Existing color usage: `/Users/juan.caicedo/code/personal/dotfiles/.claude/statusline.sh:5-8`
- Settings file: `/Users/juan.caicedo/code/personal/dotfiles/.claude/settings.json:1`
- Tmux integration: `/Users/juan.caicedo/code/personal/dotfiles/docs/solutions/integration-issues/claude-code-tmux-window-status.md`

### External References
- glow: https://github.com/charmbracelet/glow
- bat: https://github.com/sharkdp/bat
- ANSI escape codes: https://en.wikipedia.org/wiki/ANSI_escape_code
- Dracula theme: https://draculatheme.com/contribute
- Terminal capability detection: https://www.gnu.org/software/termutils/manual/termcap-1.3/html_mono/termcap.html

### Existing Patterns
- Claude Code Dracula theme colors (from binary analysis)
- ANSI escape code usage in statusline: `\033[2;36m`, `\033[2;33m`, `\033[0m`
- Tmux context awareness via `$TMUX_PANE` variable

## Future Considerations

1. **Rendered markdown mode** - After syntax highlighting works, add full rendering with tables, images
2. **Web-based output** - HTML rendering option for richer display
3. **Custom themes** - User-defined color schemes beyond Dracula
4. **Performance optimizations** - Caching, streaming rendering for long responses
5. **Plugin architecture** - Extensible renderer system for future enhancements

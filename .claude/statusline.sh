#!/bin/bash
# Optimized status line script for Claude Code
# Shows: current directory | git branch (if in a git repo)

# Read JSON input from stdin
input=$(cat)

# Extract current directory from JSON (fast, no filesystem access)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Get just the directory name (basename) instead of full path
dir_name=$(basename "$cwd")

# OPTIMIZATION 1: Fast git branch detection with timeout
# Use 'timeout' command to prevent hanging on slow git operations
# Fallback to plain git if timeout command is not available
if command -v timeout >/dev/null 2>&1; then
  # With timeout: abort git command after 0.1 seconds
  branch=$(cd "$cwd" 2>/dev/null && timeout 0.1 git -c core.fileMode=false -c gc.auto=0 rev-parse --abbrev-ref HEAD 2>/dev/null)
else
  # Without timeout: use git with optimizations
  branch=$(cd "$cwd" 2>/dev/null && git -c core.fileMode=false -c gc.auto=0 rev-parse --abbrev-ref HEAD 2>/dev/null)
fi

# OPTIMIZATION 2: Skip git check if .git directory doesn't exist
# This avoids the git command entirely for non-git directories
if [ ! -d "$cwd/.git" ]; then
  branch=""
fi

# Display the status line with colors
# Colors: cyan for branch, yellow for directory
# Note: Dimmed colors (\033[2m) are used for subtlety in the status line
if [ -n "$branch" ]; then
  # Format: "branch | directory" with colors
  # \033[2;36m = dimmed cyan, \033[2;33m = dimmed yellow
  printf "\033[2;36m%s\033[0m \033[2m|\033[0m \033[2;33m%s\033[0m\n" "$branch" "$dir_name"
else
  # Just show directory in yellow if not in a git repo
  printf "\033[2;33m%s\033[0m\n" "$dir_name"
fi

---
name: vanna-env-sync
description: Syncs .env.local files across vanna-connect project clones and worktrees by finding the most recent files and copying them to all locations. Use when environment files need to be synchronized across multiple vanna-connect repositories, when setup changes need to propagate, or when user mentions syncing envs, environment files, or .env.local files.
allowed-tools:
  - Bash
  - Read
---

# Vanna Environment Sync

Synchronizes `.env.local` files across all vanna-connect project clones and worktrees in `~/code/vanna`.

## Quick Start

Run this skill to:
1. Find all vanna-connect projects and worktrees
2. Identify the most recent `.env.local` files
3. Copy them to all other locations (projects and worktrees)

The skill syncs these files:
- `typescript/servers/api-service/.env.local`
- `typescript/servers/automations-service/.env.local`
- `typescript/servers/adt-service/.env.local`
- `typescript/apps/cli/.env.local`
- `typescript/apps/admin/.env.local`
- `typescript/apps/web/.env.local`

## Instructions

Follow this workflow:

### Step 1: Find All Projects and Worktrees

```bash
# Find regular project directories
echo "Regular projects:"
for dir in ~/code/vanna/*/; do
  if [ -d "${dir}typescript" ]; then
    echo "  $(basename "$dir")"
  fi
done

echo ""
echo "Worktree projects:"
# Find worktree directories
for worktree_dir in ~/code/vanna/*/.worktrees/*/; do
  if [ -d "${worktree_dir}typescript" ]; then
    parent=$(basename "$(dirname "$(dirname "$worktree_dir")")")
    worktree=$(basename "$worktree_dir")
    echo "  $parent/.worktrees/$worktree"
  fi
done
```

This identifies:
- All directories in `~/code/vanna/*/` that contain a `typescript` subdirectory
- All worktree directories in `~/code/vanna/*/.worktrees/*/` that contain a `typescript` subdirectory

### Step 2: Find Most Recent Files

```bash
find ~/code/vanna -name ".env.local" -type f -exec ls -lt {} + 2>/dev/null | head -30
```

Look for the files with the most recent modification timestamps. The source project will be the one with the newest files.

### Step 3: Copy Files to All Projects and Worktrees

Use this script template:

```bash
#!/bin/bash
# Source directory with the most recent .env.local files
SOURCE_DIR="/Users/juan.caicedo/code/vanna/[SOURCE_PATH]/typescript"

# Target locations (excluding the source)
# Can be either:
#   - Regular projects: "project-name"
#   - Worktrees: "project-name/.worktrees/worktree-name"
TARGETS=(
  # List all locations except the source
)

# Files to copy with their relative paths
FILES=(
  "servers/api-service/.env.local"
  "servers/automations-service/.env.local"
  "servers/adt-service/.env.local"
  "apps/cli/.env.local"
  "apps/admin/.env.local"
  "apps/web/.env.local"
)

# Copy files to each location
for target in "${TARGETS[@]}"; do
  echo "Copying to $target..."
  for file in "${FILES[@]}"; do
    SOURCE_FILE="$SOURCE_DIR/$file"
    TARGET_FILE="/Users/juan.caicedo/code/vanna/$target/typescript/$file"

    if [ -f "$SOURCE_FILE" ]; then
      # Create directory if it doesn't exist
      mkdir -p "$(dirname "$TARGET_FILE")"
      cp "$SOURCE_FILE" "$TARGET_FILE"
      echo "  ✓ Copied $file"
    else
      echo "  ✗ Source file not found: $file"
    fi
  done
  echo ""
done

echo "Done! Verifying copied files..."
find ~/code/vanna -name ".env.local" -type f -exec ls -lt {} + 2>/dev/null | head -30
```

### Step 4: Report Results

After copying, show:
- Source location used (project or worktree)
- Number of files copied
- List of target locations updated (projects and worktrees)
- Verification of new timestamps

## Examples

**Example 1: Sync from most recent project**

Input: User runs `/vanna-env-sync`

Process:
1. Find locations: `burrito-vanna-connect-2`, `taco-vanna-connect`, `vanna-connect`, `vanna-connect/.worktrees/feature-branch`, etc.
2. Identify most recent: `vanna-connect/.worktrees/feature-branch` (Feb 13 10:30)
3. Copy 6 files to all other locations

Output:
```
✓ Synced .env.local files from vanna-connect/.worktrees/feature-branch

Files copied:
- servers/api-service/.env.local
- servers/automations-service/.env.local
- servers/adt-service/.env.local
- apps/cli/.env.local
- apps/admin/.env.local
- apps/web/.env.local

To locations:
- taco-vanna-connect
- vanna-connect
- vanna-connect-2
- vanna-connect/.worktrees/another-branch
- vanna-connect-exploration
- vanna-connect-FT-654
- taco-backup

All files updated to Feb 13 10:45
```

**Example 2: No recent files found**

If no `.env.local` files exist, inform the user:
```
No .env.local files found in any vanna-connect projects.
Run the localSetup command to generate them first.
```

## Guidelines

- Always identify the most recent files by timestamp (across both regular projects and worktrees)
- Exclude the source location from the copy targets
- Create target directories if they don't exist
- Preserve file permissions when copying
- Show verification of timestamps after copying
- Handle missing files gracefully with clear messages
- Use absolute paths to avoid directory confusion
- Treat worktrees and regular projects equally when finding the most recent files

## Common Scenarios

**After running localSetup:**
The skill detects which location (project or worktree) has the newest setup and propagates it to all others.

**After manual edits:**
If you manually update .env.local in one location, run this to sync across all locations.

**Before switching projects or worktrees:**
Ensure all locations have consistent environment configuration before changing your working directory.

**Working with git worktrees:**
When using git worktrees for parallel development, this ensures all worktrees have the same environment configuration as the main project.

## Notes

- These files are auto-generated by the localSetup command
- Manual edits will be lost on next localSetup run
- For persistent changes, edit `.env` instead of `.env.local`
- The skill always syncs from the most recent files, not from a specific project

# Global Claude Code Guidelines

## Project-Specific Documentation Rules

### Vanna Project
When working in any directory matching the pattern `~/code/vanna/*`:

**Documentation & Planning Location:**
- All documentation files → `~/code/vanna/docs/`
- All planning files → `~/code/vanna/docs/planning/`

**Exception:** If already working in `~/code/vanna/docs/`, write files normally in the current directory (don't redirect).

This applies to ALL subdirectories under `~/code/vanna/` including:
- vanna-connect, vanna-connect-2, burrito-vanna-connect-2, etc.
- Any future Vanna-related projects in this directory

**What goes to the centralized docs:**
- ✅ `.md` documentation files
- ✅ Planning documents, specs, design docs
- ✅ Architecture diagrams and guides
- ✅ Any `docs/` or `planning/` relative paths

**What stays in the local project:**
- ❌ Code files, tests, configuration
- ❌ Project-specific README.md (these can stay local)

**Git Workflow:**
- ⚠️ Do NOT automatically commit documentation files in Vanna repos
- Wait for explicit user instruction before committing changes to `~/code/vanna/docs/`
- Code commits in subdirectories (vanna-connect, etc.) can follow normal workflow

**Examples:**
- When in `~/code/vanna/vanna-connect/src/` and writing docs → use `~/code/vanna/docs/`
- When in `~/code/vanna/burrito-vanna-connect-2/` and writing planning → use `~/code/vanna/docs/planning/`

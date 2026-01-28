# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Grove is a CLI tool for managing git worktrees. The main command `gwt` creates worktrees with automatic .env file handling and dependency installation.

## Architecture

**bin/gwt** - The main bash script. Handles argument parsing, worktree creation via `git worktree add`, env file copying/symlinking, and package manager detection.

**integrations/** - Shell wrapper functions (grove.bash, grove.zsh) that call `gwt` and auto-cd into the created worktree by parsing the `GWT_PATH:` marker from stdout.

**completions/** - Shell completions (_gwt for zsh, gwt.bash for bash) that complete branch names and flags.

**Formula/grove.rb** - Homebrew formula for installation.

## Testing Changes

Test locally without installation:
```bash
./bin/gwt --help
./bin/gwt --version
```

Test in a real git repo:
```bash
cd /tmp && mkdir test-repo && cd test-repo && git init
echo "TEST=1" > .env
git add . && git commit -m "init"
git checkout -b feature/test
git checkout main
/path/to/grove/bin/gwt feature/test
# Verify .worktrees/test/.env is a copy (not symlink)
```

## Key Behaviors

- Default: copies .env files (allows independent config per worktree)
- With `-l` flag or `GWT_LINK_ENV=1`: symlinks instead
- Folder name derived from branch: `feature/auth` → `.worktrees/auth`
- Outputs `GWT_PATH:<path>` marker for shell integration to capture

## Commit Convention

Use commitizen/conventional commits format (e.g., `feat:`, `fix:`, `chore:`).

# 🌳 Grove

A modern CLI tool for managing git worktrees. Create isolated worktrees with automatic environment setup—perfect for running multiple AI coding assistants on different branches simultaneously.

## Why Grove?

Git worktrees let you have multiple branches checked out at once in separate directories. Grove makes this effortless:

- **Parallel AI sessions**: Run Claude Code, Cursor, or Copilot on different features at the same time
- **Zero-stash workflow**: Start a bugfix without stashing your current work
- **Automatic setup**: Copies your `.env` files and installs dependencies
- **Smart detection**: Auto-detects npm, pnpm, yarn, or bun

## Installation

### macOS (Homebrew)

```bash
brew tap donkoko/grove
brew install grove
```

### Linux / macOS (manual)

```bash
curl -fsSL https://raw.githubusercontent.com/donkoko/grove/main/install.sh | bash
```

### Enable auto-cd (recommended)

After installation, enable the shell integration to automatically cd into new worktrees:

**Zsh** (add to `~/.zshrc`):
```bash
source /usr/local/share/grove/integrations/grove.zsh
# or for Homebrew on Apple Silicon:
source /opt/homebrew/share/grove/integrations/grove.zsh
```

**Bash** (add to `~/.bashrc`):
```bash
source /usr/local/share/grove/integrations/grove.bash
# or for Homebrew on Apple Silicon:
source /opt/homebrew/share/grove/integrations/grove.bash
```

Then restart your shell or run `source ~/.zshrc` (or `~/.bashrc`).

## Usage

```bash
# Checkout an existing branch
gwt feature/auth                    # → .worktrees/auth

# Custom folder name
gwt feature/auth -f login           # → .worktrees/login

# Create a new branch from main
gwt -n feature/new-thing            # → .worktrees/new-thing

# Create a new branch from specific base
gwt -n feature/new-thing develop    # → .worktrees/new-thing (from develop)

# Skip dependency installation
gwt feature/auth -s
gwt feature/auth --skip
```

### Options

| Flag | Description |
|------|-------------|
| `-n` | Create a new branch instead of checking out existing |
| `-f <name>` | Custom folder name (default: branch name without prefix) |
| `-l, --link` | Symlink env files instead of copying |
| `-s, --skip` | Skip dependency installation |
| `-h, --help` | Show help message |
| `-v, --version` | Show version |

### Configuration

Set these environment variables in your shell config:

```bash
# Change worktrees directory (default: .worktrees)
export GWT_DIR=".trees"

# Change which env files get copied (default: .env .env.local)
export GWT_ENV_FILES=".env .env.local .env.development"

# Always skip dependency installation (default: 0)
export GWT_SKIP_INSTALL=1

# Always symlink env files instead of copying (default: 0)
export GWT_LINK_ENV=1
```

## How It Works

When you run `gwt feature/auth`:

1. Creates `.worktrees/auth` with that branch checked out
2. Adds `.worktrees/` to `.gitignore` (if not already there)
3. Copies your `.env` files from the main repo (use `-l` to symlink instead)
4. Switches to your nvm default node version (if using nvm)
5. Runs `npm install` (or pnpm/yarn/bun based on lockfile)
6. cd's you into the new worktree (if shell integration is enabled)

All worktrees share the same `.git` history, so commits in one are immediately visible in others.

## Managing Worktrees

Grove creates worktrees—use git's built-in commands to manage them:

```bash
# List all worktrees
git worktree list

# Remove a worktree
git worktree remove .worktrees/auth

# Force remove (if dirty)
git worktree remove --force .worktrees/auth

# Clean up stale references
git worktree prune
```

## Example Workflow

```bash
# Start in your main repo (stays on main)
cd ~/projects/my-app

# Terminal 1: Start Claude Code on a feature
gwt -n feature/new-api
claude

# Terminal 2: Start another session on a bugfix
cd ~/projects/my-app
gwt bugfix/login-issue  
claude

# Both work in parallel without conflicts!
```

## Project Structure

```
my-app/
├── .git/
├── .gitignore              # Grove adds .worktrees/ here
├── .worktrees/             # Your worktrees live here
│   ├── feature-a/          # Each is a full working copy
│   ├── bugfix-123/
│   └── experiment/
├── .env                    # Copied into each worktree
├── .env.local
└── src/
```

## Uninstall

### Homebrew
```bash
brew uninstall grove
brew untap donkoko/grove
```

### Manual
```bash
curl -fsSL https://raw.githubusercontent.com/donkoko/grove/main/uninstall.sh | bash
```

Don't forget to remove the `source` line from your shell config.

## License

MIT

---

**Grove** is made for developers who juggle multiple tasks. Happy hacking! 🌳

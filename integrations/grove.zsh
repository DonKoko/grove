# Grove shell integration for Zsh
# Add to ~/.zshrc: source /usr/local/share/grove/integrations/grove.zsh

# Wrapper function that auto-cds into the worktree
gwt() {
  local output
  local exit_code
  local worktree_path

  # Run the actual gwt command and capture output
  output=$(command gwt "$@" 2>&1)
  exit_code=$?

  # Print the output (excluding the path marker)
  echo "$output" | grep -v "^GWT_PATH:"

  # If successful, extract path and cd into it
  if [[ $exit_code -eq 0 ]]; then
    worktree_path=$(echo "$output" | grep "^GWT_PATH:" | cut -d: -f2-)
    if [[ -n "$worktree_path" ]] && [[ -d "$worktree_path" ]]; then
      cd "$worktree_path" || return 1
      echo ""
      echo "Now in: $worktree_path"
    fi
  fi

  return $exit_code
}

# Add completions to fpath
if [[ -d "/usr/local/share/grove/completions" ]]; then
  fpath=("/usr/local/share/grove/completions" $fpath)
elif [[ -d "${HOMEBREW_PREFIX:-/opt/homebrew}/share/grove/completions" ]]; then
  fpath=("${HOMEBREW_PREFIX:-/opt/homebrew}/share/grove/completions" $fpath)
fi

# Initialize completions if not already done
autoload -Uz compinit
compinit -u 2>/dev/null

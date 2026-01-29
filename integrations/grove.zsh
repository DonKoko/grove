# Grove shell integration for Zsh
# Add to ~/.zshrc: source /usr/local/share/grove/integrations/grove.zsh

# Wrapper function that auto-cds into the worktree
gwt() {
  local output
  local exit_code
  local worktree_path

  # Run gwt: stderr (progress) goes straight to terminal, stdout is captured
  output=$(command gwt "$@")
  exit_code=$?

  # If successful, extract path and cd into it
  if [[ $exit_code -eq 0 ]]; then
    worktree_path=$(echo "$output" | grep "^GWT_PATH:" | cut -d: -f2-)
    if [[ -n "$worktree_path" ]] && [[ -d "$worktree_path" ]]; then
      cd "$worktree_path" || return 1
    fi
  fi

  return $exit_code
}

grove() { gwt "$@"; }

# Add completions to fpath
if [[ -d "/usr/local/share/grove/completions" ]]; then
  fpath=("/usr/local/share/grove/completions" $fpath)
elif [[ -d "${HOMEBREW_PREFIX:-/opt/homebrew}/share/grove/completions" ]]; then
  fpath=("${HOMEBREW_PREFIX:-/opt/homebrew}/share/grove/completions" $fpath)
fi

# Initialize completions if not already done
autoload -Uz compinit
compinit -u 2>/dev/null

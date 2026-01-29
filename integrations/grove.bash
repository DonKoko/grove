# Grove shell integration for Bash
# Add to ~/.bashrc: source /usr/local/share/grove/integrations/grove.bash

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

# Source bash completions if available
if [[ -f "/usr/local/share/grove/completions/gwt.bash" ]]; then
  source "/usr/local/share/grove/completions/gwt.bash"
elif [[ -f "${HOMEBREW_PREFIX:-/opt/homebrew}/share/grove/completions/gwt.bash" ]]; then
  source "${HOMEBREW_PREFIX:-/opt/homebrew}/share/grove/completions/gwt.bash"
fi

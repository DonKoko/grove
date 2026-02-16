# Bash completion for gwt
# Add to ~/.bashrc: source /usr/local/share/grove/completions/gwt.bash

_gwt_completions() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"
  local first="${COMP_WORDS[1]}"

  case "$prev" in
    -f)
      # No completion for folder name
      return 0
      ;;
  esac

  # Complete worktree names and --force at every position for remove
  if [[ "$first" == "remove" ]] && [[ $COMP_CWORD -ge 2 ]]; then
    local gwt_dir="${GWT_DIR:-.worktrees}"
    local worktrees=""
    if [[ -d "$gwt_dir" ]]; then
      worktrees=$(ls -1 "$gwt_dir" 2>/dev/null)
    fi
    COMPREPLY=($(compgen -W "$worktrees --force" -- "$cur"))
    return 0
  fi

  if [[ "$cur" == -* ]]; then
    COMPREPLY=($(compgen -W "-n -f -l --link -s --skip -h --help -v --version" -- "$cur"))
  else
    # Complete subcommands and branch names
    local branches
    branches=$(git branch -a 2>/dev/null | sed 's/^[* ]*//' | sed 's/remotes\/origin\///' | sort -u)
    COMPREPLY=($(compgen -W "list remove update $branches" -- "$cur"))
  fi
}

complete -F _gwt_completions gwt grove

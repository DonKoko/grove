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
    remove)
      # Complete worktree names for remove
      local gwt_dir="${GWT_DIR:-.worktrees}"
      if [[ -d "$gwt_dir" ]]; then
        local worktrees
        worktrees=$(ls -1 "$gwt_dir" 2>/dev/null)
        COMPREPLY=($(compgen -W "$worktrees" -- "$cur"))
      fi
      return 0
      ;;
  esac

  # Complete --force after worktree name in remove
  if [[ "$first" == "remove" ]] && [[ $COMP_CWORD -eq 3 ]]; then
    COMPREPLY=($(compgen -W "--force" -- "$cur"))
    return 0
  fi

  if [[ "$cur" == -* ]]; then
    COMPREPLY=($(compgen -W "-n -f -l --link -s --skip -h --help -v --version" -- "$cur"))
  else
    # Complete subcommands and branch names
    local branches
    branches=$(git branch -a 2>/dev/null | sed 's/^[* ]*//' | sed 's/remotes\/origin\///' | sort -u)
    COMPREPLY=($(compgen -W "list remove $branches" -- "$cur"))
  fi
}

complete -F _gwt_completions gwt

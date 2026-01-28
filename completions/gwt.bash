# Bash completion for gwt
# Add to ~/.bashrc: source /usr/local/share/grove/completions/gwt.bash

_gwt_completions() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"

  case "$prev" in
    -f)
      # No completion for folder name
      return 0
      ;;
  esac

  if [[ "$cur" == -* ]]; then
    COMPREPLY=($(compgen -W "-n -f -l --link -s --skip -h --help -v --version" -- "$cur"))
  else
    # Complete branch names
    local branches
    branches=$(git branch -a 2>/dev/null | sed 's/^[* ]*//' | sed 's/remotes\/origin\///' | sort -u)
    COMPREPLY=($(compgen -W "$branches" -- "$cur"))
  fi
}

complete -F _gwt_completions gwt

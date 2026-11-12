# bash: cstatus / cs <Tab> — команды и номера задач
_cstatus() {
  local cur prev; cur="${COMP_WORDS[COMP_CWORD]}"; prev="${COMP_WORDS[COMP_CWORD-1]}"
  if [ "$COMP_CWORD" = 1 ]; then COMPREPLY=($(compgen -W "mine copy run close render cheat task gc" -- "$cur")); return; fi
  case "$prev" in
    copy|run|close) COMPREPLY=($(compgen -W "$(cstatus mine 2>/dev/null | grep -o '^ *\[[0-9]*\]' | tr -d ' []')" -- "$cur"));;
    render|cheat) COMPREPLY=($(compgen -W "--plain" -- "$cur"));;
    task) COMPREPLY=($(compgen -W "set done rm ls clear-done" -- "$cur"));;
    done|rm|set) [ "${COMP_WORDS[1]}" = task ] && COMPREPLY=($(compgen -W "$(cstatus task ls 2>/dev/null | cut -f1)" -- "$cur"));;
  esac
}
complete -F _cstatus cstatus cs

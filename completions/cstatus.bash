# bash: cstatus / cs <Tab> — команды, номера задач, id и группы
_cstatus() {
  local cur prev; cur="${COMP_WORDS[COMP_CWORD]}"; prev="${COMP_WORDS[COMP_CWORD-1]}"
  if [ "$COMP_CWORD" = 1 ]; then COMPREPLY=($(compgen -W "mine copy run close render cheat task lang gc" -- "$cur")); return; fi
  case "$prev" in
    copy|run|close) COMPREPLY=($(compgen -W "$(cstatus mine 2>/dev/null | grep -o '^ *\[[0-9]*\]' | tr -d ' []')" -- "$cur"));;
    render) COMPREPLY=($(compgen -W "--plain --tasks2" -- "$cur"));;
    cheat) COMPREPLY=($(compgen -W "--plain" -- "$cur"));;
    lang) COMPREPLY=($(compgen -W "ru en" -- "$cur"));;
    task) COMPREPLY=($(compgen -W "set done important group groups rm ls clear-done" -- "$cur"));;
    done|rm|set|group|important) [ "${COMP_WORDS[1]}" = task ] && COMPREPLY=($(compgen -W "$(cstatus task ls 2>/dev/null | cut -f1)" -- "$cur"));;
    *) if [ "${COMP_WORDS[1]}" = task ] && [ "${COMP_WORDS[2]}" = group ] && [ "$COMP_CWORD" = 4 ]; then
         local IFS=$'\n'; COMPREPLY=($(compgen -W "$(cstatus task groups 2>/dev/null | sed 's/^[0-9]*\. //')" -- "$cur"))
       elif [ "${COMP_WORDS[1]}" = task ] && [ "${COMP_WORDS[2]}" = important ] && [ "$COMP_CWORD" = 4 ]; then
         COMPREPLY=($(compgen -W "on off" -- "$cur"))
       fi;;
  esac
}
complete -F _cstatus cstatus cs

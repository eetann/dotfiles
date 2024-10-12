function fzf_mise_tasks() {
  # mise settings set experimental true
  if [ ! -e .mise.toml ]; then
    echo 'fzf_mise_tasks'
    echo 'There is no .mise.toml'
    zle send-break
    return 1
  fi
  if ! type yq > /dev/null; then
    echo 'fzf_mise_tasks'
    echo 'yq command is required'
    zle send-break
    return 1
  fi

  local tasks="yq -oj '.tasks | to_entries | .[] | .key + \" = \" + .value.run' .mise.toml 2>/dev/null || echo ''"
  if [[ -z $tasks ]]; then
    echo 'fzf_mise_tasks'
    echo 'There is no tasks in .mise.toml'
    zle send-break
    return 1
  fi
  local selected=`eval $tasks | sed 's/^"//;s/"$//' | FZF_DEFAULT_OPTS='' fzf --height=50% --reverse --exit-0 | awk -F ' = ' '{ print $1}'`

  zle reset-prompt
  if [[ -z $selected ]]; then
    return 0
  fi

  # 再実行したくなるときのために履歴に残して実行
  BUFFER="mise run $selected"
  zle accept-line
}

zle -N fzf_mise_tasks
bindkey "^Xm" fzf_mise_tasks

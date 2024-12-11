function fzf_mise_tasks() {
  # mise settings set experimental true
  # 検索対象のファイルリスト
  local files=( ".mise.local.toml" "mise.local.toml" ".mise.toml" "mise.toml" "mise/config.toml" )
  local found_files=()
  for file in "${files[@]}"; do
    if [[ -e $file ]]; then
      found_files+=("$file")
    fi
  done

  if [[ ${#found_files[@]} -eq 0 ]]; then
    echo 'fzf_mise_tasks'
    echo 'No target mise file found'
    zle send-break
    return 1
  fi
  if ! type yq > /dev/null; then
    echo 'fzf_mise_tasks'
    echo 'yq command is required'
    zle send-break
    return 1
  fi

  local tasks_list=()
  for file in "${found_files[@]}"; do
    local file_tasks=$(yq -oj '.tasks | to_entries | .[] | .key + " = " + .value.run' "$file" 2>/dev/null || echo '')
    if [[ ${file_tasks:-null} != null ]]; then
      tasks_list+=("$file_tasks")
    fi
  done
  local tasks=$(printf "%s\n" "${tasks_list[@]}")

  if [[ -z $tasks ]]; then
    echo 'fzf_mise_tasks'
    echo 'There is no tasks in .mise.toml'
    zle send-break
    return 1
  fi
  local selected=`echo "$tasks" | sed 's/^"//;s/"$//' | FZF_DEFAULT_OPTS='' fzf --height=50% --reverse --exit-0 | awk -F ' = ' '{ print $1}'`

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

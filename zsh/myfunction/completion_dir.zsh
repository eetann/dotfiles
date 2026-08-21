function completion_dir() {
  local ary=(`echo $LBUFFER`)
  local query
  local prebuffer
  # 単語を入力途中ならそれをクエリにする
  if [[ "${LBUFFER: -1}" == " " ]]; then
    query=""
    prebuffer=$ary
  else
    query=${ary[-1]}
    prebuffer=${ary[1,-2]}
  fi
  # コマンドがない場合は cd にする
  if [ -z "$prebuffer" ]; then
    prebuffer="cd"
  fi

  # 共通のプレビュー設定
  local preview_cmd='
  ( (type bat > /dev/null) &&
    bat --color=always \
      --theme=gruvbox-dark \
      --line-range :200 $(ghq root)/{}/README.* \
    || (cat {} | head -200) ) 2> /dev/null
'
  local preview_window='down,60%,wrap,+3/2,~3'

  local find_directory=$(cat <<"EOF"
( (type fd > /dev/null) &&
  fd --type d \
    --strip-cwd-prefix \
    --hidden \
    --exclude '{.git,node_modules}/**' ) \
  || $find_ignore d -print 2> /dev/null
EOF
)
  local candidates=$(eval $find_directory)

  local res
  # niwatermのタブ内（NIWATERM_TAB_IDあり）かつniwatermコマンドが使える場合は、
  # fzf --tmuxの代わりにniwatermのpopupでfzfを実行する。
  # popup起動自体に失敗した場合（アプリ未起動・既にpopup使用中等）は通常のfzf --tmuxにフォールバックする
  res=$(_fzf_niwaterm_popup_select "$candidates" "$query" "$preview_cmd" "$preview_window" "" "")
  if (( $? == 3 )); then
    local fzf_command="fzf"
    if type fzf-tmux > /dev/null; then
      fzf_command="fzf-tmux -p 80%"
    fi
    fzf_command+=" --query '$query' --preview '$preview_cmd' --preview-window '$preview_window'"
    res=$(printf '%s\n' "$candidates" | eval $fzf_command)
  fi

  if [ -n "$res" ]; then
    BUFFER="${prebuffer} ${res}"
  else
    return 1
  fi
  # カーソル位置を行末にして更新
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N completion_dir
bindkey '^xd' completion_dir

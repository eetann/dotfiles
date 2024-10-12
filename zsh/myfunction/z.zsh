# z ×fzf
function fz() {
  local fzf_command="fzf"
  if type fzf-tmux > /dev/null; then
    fzf_command="fzf-tmux -p 80%"
  fi
  fzf_command+=" "
  fzf_command+=$(cat << "EOF"
--preview '
  tree -aC -L 1 {} | head -200
' \
--preview-window 'right,wrap,~1'
EOF
)
  # zの出力の先頭12文字の頻度情報を使ってソートし、fzfに渡すときは削る
  local res=$(z | sort -rn | cut -c 12- | eval $fzf_command)
  if [ -n "$res" ]; then
    BUFFER+="cd $res"
    zle accept-line
  else
    return 1
  fi
}
zle -N fz
bindkey '^xz' fz

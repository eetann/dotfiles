function completion_dir() {
  local fzf_command="fzf"
  if type fzf-tmux > /dev/null; then
    fzf_command="fzf-tmux -p 80%"
  fi

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

  fzf_command+=" "
  fzf_command+=$(cat << EOF
--query '$query' \
--preview '
  ( (type bat > /dev/null) &&
    bat --color=always \
      --theme=gruvbox-dark \
      --line-range :200 \$(ghq root)/{}/README.* \
    || (cat {} | head -200) ) 2> /dev/null
' \
--preview-window 'down,60%,wrap,+3/2,~3'
EOF
)

  local find_directory=$(cat <<"EOF"
( (type fd > /dev/null) &&
  fd --type d \
    --strip-cwd-prefix \
    --hidden \
    --exclude '{.git,node_modules}/**' ) \
  || $find_ignore d -print 2> /dev/null
EOF
)
  local res=$(eval $find_directory | eval $fzf_command)
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

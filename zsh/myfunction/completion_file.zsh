function completion_file() {
  # 入力をスペースで区切って配列に
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

  # 共通のプレビュー設定
  local preview_cmd='
  ( (type bat > /dev/null) &&
    bat --color=always \
      --theme=gruvbox-dark \
      --style=plain \
      --line-range :200 {} \
    || (cat {} | head -200) ) 2> /dev/null
'

  local fzf_command=$(cat << EOF
fzf --tmux center,80% \
--query '$query' \
--multi \
--expect=ctrl-t \
--header='^T: .mywork (recent)' \
--preview '$preview_cmd' \
--preview-window 'down,60%,wrap'
EOF
)

  local result=$(eval $FZF_CTRL_T_COMMAND | eval $fzf_command)
  local key=$(echo "$result" | sed -n '1p')
  local selected=$(echo "$result" | sed -n '2,$p')

  # ctrl-t: .mywork専用モード
  if [[ "$key" == "ctrl-t" ]]; then
    local mywork_fzf=$(cat << EOF
fzf --tmux center,80% \
--query '$query' \
--multi \
--header='.mywork (recent order)' \
--preview '$preview_cmd' \
--preview-window 'down,60%,wrap'
EOF
)
    # .myworkが存在する場合のみ
    if [[ -d ".mywork" ]]; then
      selected=$(fd --type f . .mywork/ --hidden --no-ignore 2>/dev/null | xargs ls -t 2>/dev/null | eval $mywork_fzf)
    fi
  fi

  # ファイルを選択した場合のみバッファを更新
  if [[ -n "$selected" ]]; then
    # 改行で区切った配列へ 変数展開フラグfを使う
    select_arr=(${(f)selected})
    escaped=""
    for val in $select_arr; do
      escaped+=" "
      escaped+=$(printf "%q" "$val")
    done
    BUFFER="${prebuffer}${escaped}"
  fi
  # カーソル位置を行末にして更新
  CURSOR=$#BUFFER
  zle reset-prompt
}

zle -N completion_file
bindkey "^k" completion_file

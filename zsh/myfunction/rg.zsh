function rg_fzf_nvim() {
  local query=$LBUFFER
  if [ -z $query ]; then
    echo "検索文字がありません。入力してから実行してください"
    zle send-break
    return 1
  fi
  BUFFER=""
  zle -I
  echo "rg_fzf_nvim $query"
  local preview_cmd='bat --style=numbers --color=always --highlight-line {2} {1}'
  local preview_window='down,60%,wrap,+{2}/2'

  # 入力途中の文字列をrgに渡す
  local candidates=$(rg --column --line-number --no-heading --color=always --smart-case -- $query)

  local selected
  # niwatermのタブ内（NIWATERM_TAB_IDあり）かつniwatermコマンドが使える場合は、
  # fzf-tmuxの代わりにniwatermのpopupでfzfを実行する。
  # popup起動自体に失敗した場合（アプリ未起動・既にpopup使用中等）は通常のfzf-tmux/fzfにフォールバックする
  selected=$(_fzf_niwaterm_popup_select "$candidates" "" "$preview_cmd" "$preview_window" ":" "1")
  if (( $? == 3 )); then
    local fzf_command="fzf"
    if type fzf-tmux > /dev/null; then
      fzf_command="fzf-tmux -p 80%"
    fi
    fzf_command+=" --ansi --delimiter : --preview '$preview_cmd' --preview-window '$preview_window'"
    selected=$(printf '%s\n' "$candidates" | eval $fzf_command)
  fi
  # ファイルを選択した場合のみバッファを更新
  if [[ -n "$selected" ]]; then
    # 改行で区切った配列へ 変数展開フラグfを使う
    select_arr=(${(f)selected})
    escaped=""
    count=0
    for val in $select_arr; do
      escaped+=" "
      # 最初のファイルだけ指定行で開いてあげる
      if [[ $count -eq 0 ]]; then
        escaped+=$(printf "%q" "$val" | awk -F: '{print $1 " -c " $2}')
      else
        escaped+=$(printf "%q" "$val" | awk -F: '{print $1}')
      fi
      count+=1
    done
    BUFFER="nvim${escaped}"
  fi
  # カーソル位置を行末にして更新
  CURSOR=$#BUFFER
  # zle reset-prompt
}

zle -N rg_fzf_nvim
bindkey '^xK' rg_fzf_nvim

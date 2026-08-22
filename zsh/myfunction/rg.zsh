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

  # niwatermのタブ内（NIWATERM_TAB_IDあり）かつniwatermコマンドが使える場合は、
  # fzf-tmuxの代わりにniwatermのpopupでfzfを実行するfzf-niwatermを使う
  # （niwaterm利用可否の判定・popup起動失敗時のローカルfzfへのフォールバックは
  # fzf-niwaterm自身が行う。詳細: niwaterm本体のpackages/cli/bin/fzf-niwaterm）
  local fzf_command
  if [[ -n "$NIWATERM_TAB_ID" ]] && (( $+commands[niwaterm] )); then
    fzf_command="fzf-niwaterm"
  elif type fzf-tmux > /dev/null; then
    fzf_command="fzf-tmux -p 80%"
  else
    fzf_command="fzf"
  fi
  fzf_command+=" --ansi --delimiter : --preview '$preview_cmd' --preview-window '$preview_window'"
  local selected=$(printf '%s\n' "$candidates" | eval $fzf_command)
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

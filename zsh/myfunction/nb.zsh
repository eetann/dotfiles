function fzf_nb_edit() {
  if ! type nb > /dev/null; then
    echo 'fzf_nb_edit'
    echo 'nb command is required'
    zle send-break
    return 1
  fi
  # pinを優先表示したいのでnb ls
  local list_cmd=$(cat << EOF
nb ls -a --no-header --no-footer --no-color home: \
  | awk '{gsub(/^\[|\]/, ""); print}'
EOF
)
  local preview_cmd='bat --color=always --language=md --style=plain $(nb show {1} --relative-path)'
  local candidates=$(eval "$list_cmd")

  # niwatermのタブ内（NIWATERM_TAB_IDあり）かつniwatermコマンドが使える場合は、
  # fzf --tmuxの代わりにniwatermのpopupでfzfを実行するfzf-niwatermを使う
  # （niwaterm利用可否の判定・popup起動失敗時のローカルfzfへのフォールバックは
  # fzf-niwaterm自身が行う。詳細: niwaterm本体のpackages/cli/bin/fzf-niwaterm）
  local fzf_command="fzf --tmux 80%"
  if [[ -n "$NIWATERM_TAB_ID" ]] && (( $+commands[niwaterm] )); then
    fzf_command="fzf-niwaterm"
  fi
  local selected=$(printf '%s\n' "$candidates" | eval "$fzf_command --ansi --preview \"\$preview_cmd\"")

  if [[ -z $selected ]]; then
    return 0
  fi

  zle reset-prompt
  # 末尾削除: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Filename-Generation:~:text=%25pattern%7D-,%24%7Bname%25%25pattern%7D,-If%20the%20pattern
  # zshのpettern: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Operators
  # 再実行したくなるときのために履歴に残して実行
  BUFFER="nb edit ${selected%%[[:space:]]?#}"
  zle accept-line
}

zle -N fzf_nb_edit
bindkey "^Xe" fzf_nb_edit

# こっちのほうがパフォーマンス的に良い
function nbe() {
  BUFFER=""
  zle -I
  echo "ノート一覧取得中..."
  nb
  zle reset-prompt
  BUFFER="nb e "
  zle end-of-line
}

zle -N nbe
bindkey "^X^X" nbe

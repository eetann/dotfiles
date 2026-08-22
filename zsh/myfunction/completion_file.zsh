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

  local selected=$(_completion_file_fzf "$query" "$preview_cmd")

  # ファイルを選択した場合のみバッファを更新
  if [[ -n "$selected" ]]; then
    # 改行で区切った配列へ 変数展開フラグfを使う
    local select_arr=(${(f)selected})
    local escaped=""
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

# fzf（ローカル or niwatermのpopup）でファイルを選択し、選ばれたパス一覧を改行区切りで返す。
#
# niwatermのタブ内（NIWATERM_TAB_IDあり）かつniwatermコマンドが使える場合は、
# fzf --tmuxの代わりにniwatermのpopupでfzfを実行するfzf-niwatermを使う
# （niwaterm利用可否の判定・popup起動失敗時のローカルfzfへのフォールバックは
# fzf-niwaterm自身が行う。詳細: niwaterm本体のpackages/cli/bin/fzf-niwaterm）
function _completion_file_fzf() {
  local query=$1
  local preview_cmd=$2

  local fzf_base="fzf --tmux center,80%"
  if [[ -n "$NIWATERM_TAB_ID" ]] && (( $+commands[niwaterm] )); then
    fzf_base="fzf-niwaterm"
  fi

  local fzf_command=$(cat << EOF
$fzf_base \
--query '$query' \
--multi \
--expect=ctrl-t \
--header='^T: .mywork docs/adr docs/task-logs (recent)' \
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
$fzf_base \
--query '$query' \
--multi \
--header='.mywork docs/adr docs/task-logs (recent order)' \
--preview '$preview_cmd' \
--preview-window 'down,60%,wrap'
EOF
)
    # 存在する対象ディレクトリだけを集める
    local mywork_dirs=()
    [[ -d ".mywork" ]] && mywork_dirs+=(".mywork")
    [[ -d "docs/adr" ]] && mywork_dirs+=("docs/adr")
    [[ -d "docs/task-logs" ]] && mywork_dirs+=("docs/task-logs")
    if (( ${#mywork_dirs} > 0 )); then
      selected=$(fd --type f . $mywork_dirs --hidden --no-ignore 2>/dev/null | xargs ls -t 2>/dev/null | eval $mywork_fzf)
    fi
  fi

  echo -n "$selected"
}

zle -N completion_file
bindkey "^k" completion_file

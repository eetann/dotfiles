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

  local selected

  # niwatermのタブ内（NIWATERM_TAB_IDあり）かつniwatermコマンドが使える場合は、
  # fzf --tmuxの代わりにniwatermのpopupでfzfを実行する。
  # popup起動自体に失敗した場合（アプリ未起動・既にpopup使用中等）は通常のfzf --tmuxにフォールバックする
  if [[ -n "$NIWATERM_TAB_ID" ]] && (( $+commands[niwaterm] )); then
    selected=$(_completion_file_niwaterm_popup "$query" "$preview_cmd")
    (( $? == 3 )) && selected=$(_completion_file_local_fzf "$query" "$preview_cmd")
  else
    selected=$(_completion_file_local_fzf "$query" "$preview_cmd")
  fi

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

# ローカルのfzf --tmuxでファイルを選択し、選ばれたパス一覧を改行区切りで返す
function _completion_file_local_fzf() {
  local query=$1
  local preview_cmd=$2

  local fzf_command=$(cat << EOF
fzf --tmux center,80% \
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
fzf --tmux center,80% \
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

# niwatermのpopup（niwaterm popup open --capture-stdout）内でfzfを実行し、
# 選ばれたパス一覧を改行区切りで返す。
#
# 実際にfzfを動かすロジックはcompletion_file_popup_runner.sh（静的なbashスクリプト、
# 通常通りシンタックスハイライトが効く）に書いてあり、この関数はそれを呼び出すだけ。
# query・preview_cmd・ctrl_t_commandは環境変数経由で渡す（printf %qでシェルエスケープ済み）。
# niwaterm CLIの`--capture-stdout`（fzf-tmux相当。詳細: niwaterm docs show cli の
# `popup open`節）が、結果の受け渡し・一時ファイルの生成/削除・完了待ちを全部面倒見てくれる。
#
# 戻り値: 0=選択あり/なし正常終了, 3=popup起動自体に失敗（呼び出し元はfzf --tmuxへフォールバックする）
function _completion_file_niwaterm_popup() {
  local query=$1
  local preview_cmd=$2

  # アプリ未起動時、popup openへ直接進むとTCP接続タイムアウト待ちで長時間固まりうるため、
  # 軽量なpingで先に疎通確認する
  timeout 3 niwaterm ping > /dev/null 2>&1 || return 3

  # popup内シェルには.zshrc等のFZF_CTRL_T_COMMAND定義が無い可能性があるため、
  # 呼び出し元（今のシェル）で確定している値をそのまま環境変数として渡す
  local ctrl_t_command=${FZF_CTRL_T_COMMAND:-fd --type f --hidden --exclude .git}
  local runner="$ZDIR/myfunction/completion_file_popup_runner.sh"

  local envs="COMPLETION_FILE_QUERY=$(printf %q "$query")"
  envs+=" COMPLETION_FILE_PREVIEW_CMD=$(printf %q "$preview_cmd")"
  envs+=" COMPLETION_FILE_CTRL_T_COMMAND=$(printf %q "$ctrl_t_command")"

  local selected
  selected=$(
    niwaterm popup open --width 80 --height 80 --capture-stdout \
      "$envs bash $(printf %q "$runner")"
  ) || return 3

  echo -n "$selected"
  return 0
}

zle -N completion_file
bindkey "^k" completion_file

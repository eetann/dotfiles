# fzfを使う各種myfunctionから共通で呼び出す、niwaterm popup連携の共通処理。
# 実際のfzfコマンド構築（候補データの受け渡し含む）はfzf_niwaterm_popup_runner.shに
# 任せ、ここでは「niwatermが使える状況か」の判定と「popupを開いて結果を受け取る」
# IPC部分だけを共通化する。
#
# 元ネタ: completion_file.zshの_completion_file_niwaterm_popup

# niwatermのタブ内（NIWATERM_TAB_IDあり）かつniwatermコマンドが使え、
# pingが通る場合のみ0を返す。それ以外は3を返す
function _fzf_niwaterm_available() {
  [[ -n "$NIWATERM_TAB_ID" ]] || return 3
  (($+commands[niwaterm])) || return 3
  # アプリ未起動時、popup openへ直接進むとTCP接続タイムアウト待ちで長時間固まりうるため、
  # 軽量なpingで先に疎通確認する
  timeout 3 niwaterm ping > /dev/null 2>&1 || return 3
  return 0
}

# base64エンコードのショートハンド
function _fzf_niwaterm_b64() {
  printf '%s' "$1" | base64 -w0
}

# 候補データ（candidates）をniwatermのpopup内でfzfに通し、選択結果を返す。
# candidatesは呼び出し元で1回だけ生成した候補リストのテキスト（改行区切り）。
# query/preview_cmd/preview_window/delimiterは未使用なら空文字列を渡せばよい。
# ansiは"1"でfzfに--ansiを付与する。
#
# データはすべてbase64経由でfzf_niwaterm_popup_runner.shへ渡し、runner側では
# クォート済みの変数参照・argv要素としてのみ扱う（文字列結合してevalしないため、
# candidatesやqueryの中身がどんな文字列でもシェルインジェクションにならない）。
#
# 戻り値: 0=正常終了（結果は標準出力）, 3=popup起動自体に失敗
#         （呼び出し元は既存のfzf-tmux/fzfへフォールバックする）
function _fzf_niwaterm_popup_select() {
  local candidates=$1
  local query=$2
  local preview_cmd=$3
  local preview_window=$4
  local delimiter=$5
  local ansi=$6

  _fzf_niwaterm_available || return 3

  local runner="$ZDIR/myfunction/fzf_niwaterm_popup_runner.sh"
  local envs="FZF_NW_CANDIDATES_B64=$(_fzf_niwaterm_b64 "$candidates")"
  envs+=" FZF_NW_QUERY_B64=$(_fzf_niwaterm_b64 "$query")"
  envs+=" FZF_NW_PREVIEW_CMD_B64=$(_fzf_niwaterm_b64 "$preview_cmd")"
  envs+=" FZF_NW_PREVIEW_WINDOW_B64=$(_fzf_niwaterm_b64 "$preview_window")"
  envs+=" FZF_NW_DELIMITER_B64=$(_fzf_niwaterm_b64 "$delimiter")"
  envs+=" FZF_NW_ANSI=$ansi"
  envs+=" FZF_NW_FZF_DEFAULT_OPTS_B64=$(_fzf_niwaterm_b64 "$FZF_DEFAULT_OPTS")"

  local selected
  selected=$(
    niwaterm popup open --width 80 --height 80 --capture-stdout \
      "$envs bash $(printf %q "$runner")"
  ) || return 3

  echo -n "$selected"
  return 0
}

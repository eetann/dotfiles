#!/usr/bin/env bash
# niwatermのpopup内（niwaterm popup open --capture-stdout）で実行される汎用ランナー。
# zsh/myfunction/fzf_niwaterm.zshの_fzf_niwaterm_popup_selectから呼ばれる。
#
# 候補データ・fzfオプションはすべてbase64の環境変数経由で「データ」として受け取り、
# 文字列結合してevalすることは一切せず、常にクォート済み変数参照・argv要素として
# fzfへ渡す（completion_file_popup_runner.shと同じ理由でbase64を使う。中身に
# シングルクォートや$(...)が含まれていても再解釈されない）。
set -o pipefail

b64d() { [[ -n "$1" ]] && printf '%s' "$1" | base64 -d; }

candidates=$(b64d "${FZF_NW_CANDIDATES_B64:-}")
query=$(b64d "${FZF_NW_QUERY_B64:-}")
preview_cmd=$(b64d "${FZF_NW_PREVIEW_CMD_B64:-}")
preview_window=$(b64d "${FZF_NW_PREVIEW_WINDOW_B64:-}")
delimiter=$(b64d "${FZF_NW_DELIMITER_B64:-}")
export FZF_DEFAULT_OPTS
FZF_DEFAULT_OPTS=$(b64d "${FZF_NW_FZF_DEFAULT_OPTS_B64:-}")

args=()
[[ -n "$query" ]] && args+=(--query "$query")
[[ -n "$preview_cmd" ]] && args+=(--preview "$preview_cmd")
[[ -n "$preview_window" ]] && args+=(--preview-window "$preview_window")
[[ -n "$delimiter" ]] && args+=(--delimiter "$delimiter")
[[ "${FZF_NW_ANSI:-}" == "1" ]] && args+=(--ansi)

printf '%s' "$candidates" | fzf "${args[@]}"

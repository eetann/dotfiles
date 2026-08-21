#!/usr/bin/env bash
# niwatermのpopup内（niwaterm popup open --capture-stdout）で実行される。
# 標準出力はniwaterm側がキャプチャして呼び出し元シェルへそのまま返すため、選択結果だけを
# 出力すること。UI（fzfの画面自体）はこのスクリプトの実行画面（popup内PTY）にそのまま出る。
# query・preview_cmd・ctrl_t_commandはcompletion_file.zshが環境変数経由で渡す
# （IPC越しの実行のため、popup内シェルはcompletion_file.zsh側のローカル変数を直接見えない）。
set -o pipefail

query="${COMPLETION_FILE_QUERY:-}"
preview_cmd="${COMPLETION_FILE_PREVIEW_CMD:-}"
ctrl_t_command="${COMPLETION_FILE_CTRL_T_COMMAND:-fd --type f --hidden --exclude .git}"

result=$(eval "$ctrl_t_command" | fzf \
  --query "$query" \
  --multi \
  --expect=ctrl-t \
  --header='^T: .mywork docs/adr docs/task-logs (recent)' \
  --preview "$preview_cmd" \
  --preview-window 'down,60%,wrap')

key=$(printf '%s\n' "$result" | sed -n '1p')
selected=$(printf '%s\n' "$result" | sed -n '2,$p')

# ctrl-t: .mywork専用モード
if [[ "$key" == "ctrl-t" ]]; then
  mywork_dirs=()
  [[ -d ".mywork" ]] && mywork_dirs+=(".mywork")
  [[ -d "docs/adr" ]] && mywork_dirs+=("docs/adr")
  [[ -d "docs/task-logs" ]] && mywork_dirs+=("docs/task-logs")
  if ((${#mywork_dirs[@]} > 0)); then
    selected=$(
      fd --type f . "${mywork_dirs[@]}" --hidden --no-ignore 2>/dev/null \
        | xargs ls -t 2>/dev/null \
        | fzf \
          --query "$query" \
          --multi \
          --header='.mywork docs/adr docs/task-logs (recent order)' \
          --preview "$preview_cmd" \
          --preview-window 'down,60%,wrap'
    )
  fi
fi

printf '%s' "$selected"

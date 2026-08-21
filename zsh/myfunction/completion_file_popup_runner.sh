#!/usr/bin/env bash
# niwatermのpopup内（niwaterm popup open --capture-stdout）で実行される。
# 標準出力はniwaterm側がキャプチャして呼び出し元シェルへそのまま返すため、選択結果だけを
# 出力すること。UI（fzfの画面自体）はこのスクリプトの実行画面（popup内PTY）にそのまま出る。
# query・preview_cmd・ctrl_t_command・fzf_default_optsはcompletion_file.zshがbase64で
# 環境変数経由で渡す（IPC越しの実行のため、popup内シェルはcompletion_file.zsh側の
# ローカル変数はおろか、呼び出し元シェルのFZF_DEFAULT_OPTS等の環境変数も一切見えない。
# base64にしているのはシェルのクォート・行継続と値の中身が干渉しないようにするため）
set -o pipefail

b64d() { printf '%s' "$1" | base64 -d; }

query=$(b64d "${COMPLETION_FILE_QUERY_B64:-}")
preview_cmd=$(b64d "${COMPLETION_FILE_PREVIEW_CMD_B64:-}")
ctrl_t_command=$(b64d "${COMPLETION_FILE_CTRL_T_COMMAND_B64:-}")
[[ -z "$ctrl_t_command" ]] && ctrl_t_command="fd --type f --hidden --exclude .git"
export FZF_DEFAULT_OPTS
FZF_DEFAULT_OPTS=$(b64d "${COMPLETION_FILE_FZF_DEFAULT_OPTS_B64:-}")

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

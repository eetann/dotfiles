function cd_worktree() {
  local selected
  selected=$(~/ghq/github.com/eetann/wtman/dist/index.js list \
    | sed '$d' \
    | fzf --tmux center,80% --ansi --header-lines=3 --no-select-1 \
    | awk -F '│' '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}')

  if [[ -n "$selected" ]]; then
    BUFFER="cd ${(q)selected}"
    zle accept-line
  fi
}
zle -N cd_worktree
bindkey '^xW' cd_worktree

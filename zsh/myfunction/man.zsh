function fman() {
  # Mac以外: hoge (1) → 1 hoge
  # MAC:     hoge(1) → 1 hoge
  local selected=$(man -k . \
    | fzf-tmux -p 80% \
      -q "$1" \
      --prompt='man> ' \
      --preview-window 'down,70%,~1' \
      --preview "$(cat << "EOF"
echo {} \
| awk ' \
  { $0 = gensub(/\s?\(([1-9])\)/, " \\1", 1) }
  { printf "%s ", $2 }
  { print $1 }
' \
| xargs -r man \
| col -bx \
| bat --language=man --plain --color always --theme=gruvbox-dark
EOF
)" \
    | awk ' \
      { $0 = gensub(/\s?\(([1-9])\)/, " \\1", 1) }
      { printf "%s ", $2 }
      { print $1 }
    ')

  zle reset-prompt
  if [[ -z $selected ]]; then
    return 0
  fi


  # 再実行したくなるときのために履歴に残して実行
  BUFFER="man $selected"
  zle accept-line

}
zle -N fman
bindkey '^xf' fman

export MANPAGER='nvim +Man!'

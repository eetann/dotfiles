function mise_tasks() {
  BUFFER="mise run "
  zle end-of-line
  zle zeno-completion
  if [[ "$BUFFER" != "mise run " ]]; then
    zle accept-line
  fi
}

zle -N mise_tasks
bindkey "^Xm" mise_tasks

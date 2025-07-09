function mise_tasks() {
  BUFFER="mise run "
  zle end-of-line
  zle zeno-completion
  zle accept-line
}

zle -N mise_tasks
bindkey "^Xm" mise_tasks

function mise_tasks() {
  BUFFER="mise run"
  zle accept-line
}

zle -N mise_tasks
bindkey "^Xm" mise_tasks

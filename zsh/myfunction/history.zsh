function history_popup() {
  ZENO_ENABLE_FZF_TMUX=1 \
    ZENO_FZF_TMUX_OPTIONS="--tmux 80%" \
    zeno-history-selection
}

zle -N history_popup
bindkey '^r' history_popup

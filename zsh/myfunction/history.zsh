function history_popup() {
  _zeno_lazy_load
  [[ -z $ZENO_LOADED ]] && return

  ZENO_FZF_COMMAND="fzf-tmux" \
    ZENO_FZF_TMUX_OPTIONS="-p 80%" \
    zeno-history-selection
}

zle -N history_popup
bindkey '^r' history_popup

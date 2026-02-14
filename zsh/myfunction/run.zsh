function run_task() {
  _zeno_lazy_load
  [[ -z $ZENO_LOADED ]] && return

  BUFFER="run "
  zle end-of-line
  zle zeno-completion
  if [[ "$BUFFER" != "run " ]]; then
    # "run " を除去し、zenoが付与したクオートを解除して実際のコマンドに置換
    BUFFER="${BUFFER#run }"
    BUFFER="${(Q)BUFFER}"
    zle accept-line
  fi
}
zle -N run_task
bindkey "^Xr" run_task

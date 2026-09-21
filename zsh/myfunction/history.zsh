function history_popup() {
  _zeno_lazy_load
  [[ -z $ZENO_LOADED ]] && return

  # niwatermのタブ内ではplugin/zeno.zshがZENO_FZF_COMMANDをfzf-niwatermへ切り替えるため、
  # ここでは何も指定せずそのまま呼ぶ（fzf-niwaterm側がpopup起動失敗時はローカルfzfへ
  # フォールバックする。詳細はniwaterm本体のpackages/cli/bin/fzf-niwaterm）。
  # niwatermの外（tmux）ではfzf-tmuxのpopupを使う
  if [[ -n "$NIWATERM_TAB_ID" ]]; then
    zeno-history-selection
  else
    ZENO_FZF_COMMAND="fzf-tmux" \
      ZENO_FZF_TMUX_OPTIONS="-p 80%" \
      zeno-history-selection
  fi
}

zle -N history_popup
bindkey '^r' history_popup

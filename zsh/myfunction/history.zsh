function history_popup() {
  _zeno_lazy_load
  [[ -z $ZENO_LOADED ]] && return

  # niwatermのタブ内（NIWATERM_TAB_IDあり）かつniwatermコマンドが使える場合は、
  # fzf-tmuxの代わりにfzf-niwaterm（bin/fzf-niwaterm、fzf-tmux互換のニウォターム版
  # ラッパー）を使う。zeno-history-selection widgetはZENO_FZF_COMMANDに指定した
  # コマンド名へ標準入力（history一覧）とfzfオプションをそのまま渡すだけなので、
  # fzf-tmux同様のインターフェースを持つラッパーコマンドさえ用意すればwidget自体は
  # 無改造で使い回せる（詳細はbin/fzf-niwatermのコメント参照）。
  # fzf-niwaterm自体はpopup起動が失敗した場合（既にpopup使用中等）ローカルfzfへ
  # フォールバックするが、niwatermがそもそも使えない場合のtmux連携は
  # ここ（呼び出し元）で出し分ける
  if [[ -n "$NIWATERM_TAB_ID" ]] && (( $+commands[niwaterm] )); then
    ZENO_FZF_COMMAND="fzf-niwaterm" \
      zeno-history-selection
  else
    ZENO_FZF_COMMAND="fzf-tmux" \
      ZENO_FZF_TMUX_OPTIONS="-p 80%" \
      zeno-history-selection
  fi
}

zle -N history_popup
bindkey '^r' history_popup

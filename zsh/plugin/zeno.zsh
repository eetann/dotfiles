# zeno 環境変数・遅延ロード設定

export ZENO_HOME=~/.config/zeno
export ZENO_GIT_CAT="bat --color=always"
export ZENO_DISABLE_EXECUTE_CACHE_COMMAND=1

# zeno遅延ロード
# プラグインキャッシュから外し、最初のキー入力時にsourceする
function _zeno_lazy_load() {
  [[ -n $_ZENO_LAZY_LOADED ]] && return
  _ZENO_LAZY_LOADED=1
  # tmux display-message "zeno"

  # zenoはfzfに依存するため先にロード
  _fzf_lazy_load

  # ZLE widget内からsourceすると$0がwidget名になりZENO_ROOTが不正になるため明示的に設定
  export ZENO_ROOT="$HOME/.zsh/plugins/zeno"
  source "$HOME/.zsh/plugins/zeno/zeno.zsh"

  if [[ -n $ZENO_LOADED ]]; then
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(zeno-auto-snippet-and-accept-line)

    bindkey " " zeno-auto-snippet
    bindkey '^m' zeno-auto-snippet-and-accept-line
    bindkey '^i' zeno-completion
    bindkey '^x ' zeno-insert-space
    bindkey '^x^m' accept-line
    bindkey '^x^z' zeno-toggle-auto-snippet
    bindkey '^x^p' zeno-insert-snippet
  fi
}

# stub widgets: 初回呼び出しでzenoをロードし、本来のwidgetを実行する
function _zeno_stub_space() {
  _zeno_lazy_load
  if [[ -n $ZENO_LOADED ]]; then
    zle zeno-auto-snippet
  else
    zle self-insert
  fi
}
zle -N _zeno_stub_space

function _zeno_stub_accept_line() {
  _zeno_lazy_load
  if [[ -n $ZENO_LOADED ]]; then
    zle zeno-auto-snippet-and-accept-line
  else
    zle accept-line
  fi
}
zle -N _zeno_stub_accept_line

function _zeno_stub_completion() {
  _zeno_lazy_load
  if [[ -n $ZENO_LOADED ]]; then
    zle zeno-completion
  else
    zle expand-or-complete
  fi
}
zle -N _zeno_stub_completion

function _zeno_stub_insert_snippet() {
  _zeno_lazy_load
  if [[ -n $ZENO_LOADED ]]; then
    zle zeno-insert-snippet
  fi
}
zle -N _zeno_stub_insert_snippet

# stub widgetsにキーをバインド（zenoロード後は本来のwidgetに差し替わる）
bindkey " " _zeno_stub_space
bindkey "^m" _zeno_stub_accept_line
bindkey "^i" _zeno_stub_completion
bindkey "^x^p" _zeno_stub_insert_snippet

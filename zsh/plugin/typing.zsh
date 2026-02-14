# 入力体験系プラグインの読み込み

# autosuggestions（プラグイン自身がprecmd経由で遅延初期化するためそのままsource）
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
source "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# fast-syntax-highlighting（全widgetをラップするため precmd で遅延ロード）
autoload -Uz add-zsh-hook

function _fsh_lazy_load() {
  add-zsh-hook -d precmd _fsh_lazy_load
  source "$HOME/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
}

add-zsh-hook precmd _fsh_lazy_load

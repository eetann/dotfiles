# 環境変数
export BAT_THEME="gruvbox-dark"

# powerlevel10k（instant promptと連携するため即時ロード）
source "$HOME/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme"

# プラグイン個別設定・遅延ロード
source $ZDIR/plugin/typing.zsh
source $ZDIR/plugin/fzf.zsh
source $ZDIR/plugin/zeno.zsh

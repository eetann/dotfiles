# 補完------------------------------------------------------------

# キャッシュディレクトリ
ZSH_CACHE_DIR="${HOME}/.cache/zsh"
mkdir -p "$ZSH_CACHE_DIR"

# fpath設定（compinit前に完了させる）
fpath=($HOME/.zsh/completions $fpath)
if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
fi

# compinit最適化: zcompdumpが1日以内なら-C（再スキャンをスキップ）
autoload -Uz compinit
_zcompdump="${ZSH_CACHE_DIR}/zcompdump"
if [[ -f "$_zcompdump" ]] && (( $(date +%s) - $(stat -f %m "$_zcompdump") < 86400 )); then
  compinit -C -d "$_zcompdump"
else
  compinit -d "$_zcompdump"
  # 再生成時にコンパイルして次回以降の読み込みを高速化
  zcompile "$_zcompdump"
fi
unset _zcompdump

setopt correct # コマンドのスペルチェックをする
setopt mark_dirs # file名の展開でdirectoryにマッチした場合末尾に/付加
setopt auto_param_keys # カッコの対応などを自動的に補完する
setopt auto_pushd # ディレクトリスタックon
setopt pushd_ignore_dups # 履歴を賢く
setopt complete_in_word # 語の途中でもカーソル位置で補完
setopt list_packed # 補完候補を詰めて表示
# setopt hist_expand # 補完時にヒストリを自動的に展開する
unsetopt print_exit_value # 戻り値が0以外の場合終了コードを表示
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
zstyle ':completion:*:default' menu select=2
# 大文字・小文字を区別しない(大文字を入力した場合は区別する)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
  /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin \
  /usr/local/git/bin

# pwdを補完候補から除外
zstyle ':completion:*' ignore-parents parent pwd ..
#入力途中の履歴補完を有効化する
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
# 入力途中の履歴補完
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

setopt interactive_comments # 対話中にもコメント可
setopt AUTO_MENU # タブキーの連打で自動的にメニュー補完
setopt chase_links # 移動先がシンボリックリンクならば実際のディレクトリに移動する

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^O" edit-command-line

bindkey "^Q" forward-word

# bashcompinit + aws completerは必要になった時だけロード
if [ -e /usr/local/bin/aws_completer ]; then
  autoload bashcompinit && bashcompinit
  complete -C '/usr/local/bin/aws_completer' aws
fi
[ -s "${HOME}/.bun/_bun" ] && source "${HOME}/.bun/_bun"

# 補完------------------------------------------------------------
# 補完を有効化
fpath=(/usr/local/share/zsh-completions $fpath)
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
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

if [ -e /usr/local/bin/aws_completer ]; then
  complete -C '/usr/local/bin/aws_completer' aws
fi
if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then export FPATH="$HOME/.zsh/completions:$FPATH"; fi

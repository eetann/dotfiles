# 補完------------------------------------------------------------
# 補完を有効化
fpath=(/usr/local/share/zsh-completions $fpath)
autoload -Uz compinit
compinit -u
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

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^O" edit-command-line

# 展開------------------------------------------------------------
# Gスペース のように入力したら、勝手に | grep に置き換えてくれる
setopt extended_glob
typeset -A abbreviations
abbreviations=(
    "G"    "| grep"
    "X"    "| xargs"
    "T"    "| tail"
    "C"    "| cat"
    "W"    "| wc"
    "A"    "| awk"
    "S"    "| sed"
    "E"    "2>&1 > /dev/null"
    "N"    "> /dev/null"
    "DC"   "docker-compose "
    "CD"   "&& cd \$_"
    "CL"   "| clip.exe"
    "TREE" "tree -a -I '.git|node_modules'"
)

magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    zle self-insert
}

no-magic-abbrev-expand() {
    LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand

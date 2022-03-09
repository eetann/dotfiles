# 操作------------------------------------------------------------
setopt no_beep
setopt IGNOREEOF # Ctrl+Dでログアウトしてしまうことを防ぐ
bindkey -e
autoload -Uz smart-insert-last-word
# [a-zA-Z], /, \ のうち少なくとも1文字を含む長さ2以上の単語
zstyle :insert-last-word match '*([[:alpha:]/\\]?|?[[:alpha:]/\\])*'
zle -N insert-last-word smart-insert-last-word
bindkey '^]' insert-last-word
bindkey "^U" backward-kill-line
bindkey "^C" send-break
# Ctrl + s の停止を無効化
stty stop undef

# 履歴------------------------------------------------------------
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000

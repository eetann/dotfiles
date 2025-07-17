alias rm='gomi'
alias la='ls -F --color -al'
alias ls='ls -F --color'
alias reload="source ~/.zshrc"
alias echopath="echo $PATH | sed -e 's/:/\n/g'"
alias manja="man -L ja"
alias manen="man -L en"
alias lg='lazygit --use-config-dir="$HOME/.config/lazygit"'
alias zd='cd ~/dotfiles'
alias zdev='cd ~/ghq/dev/'
alias ml='nvim .memo.local.md'
alias mt='mise watch test'
alias tn="tmux popup -E -w 95% -h 95% -d '#{pane_current_path}' 'nvim'"
case ${OSTYPE} in
  darwin*)
    alias xargs="gxargs"
    alias sed="gsed"
    alias awk="gawk"
    ;;
esac
alias idea='nb e idea.md'

# nocorrect
alias ionic='nocorrect ionic'
alias pod='nocorrect pod'
alias ng='nocorrect ng'

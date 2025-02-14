alias la='ls -F --color -al'
alias ls='ls -F --color'
alias mytree='tree -a -I ".git|node_modules|dist|vendor|platforms" --charset unicode'
alias reload="source ~/.zshrc"
alias echopath="echo $PATH | sed -e 's/:/\n/g'"
alias manja="man -L ja"
alias manen="man -L en"
alias lg='lazygit --use-config-dir="$HOME/.config/lazygit"'
alias zd='cd ~/dotfiles'
alias ml='nvim .memo.local.md'
alias mt='mise watch test'
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

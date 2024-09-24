alias la='ls -F --color -al'
alias ls='ls -F --color'
alias mytree='tree -a -I ".git|node_modules|dist" --charset unicode'
alias reload="source ~/.zshrc"
alias echopath="echo $PATH | sed -e 's/:/\n/g'"
alias manja="man -L ja"
alias manen="man -L en"
alias lg='lazygit --use-config-dir="$HOME/.config/lazygit"'
alias zd='cd ~/dotfiles'
alias dupdate="git pull && nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'"
case ${OSTYPE} in
  darwin*)
    alias xargs="gxargs"
    alias sed="gsed"
    alias awk="gawk"
    ;;
esac

# nocorrect
alias ionic='nocorrect ionic'

#!/usr/bin/fish

curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
fisher add oh-my-fish/theme-bobthefish
fisher add jethrokuan/z
fisher add 0rax/fish-bd
fish_update_completions

alias ga='git add .'
funcsave ga
alias gc='git commit -m'
funcsave gc
alias gsh='git push'
funcsave gsh
alias gst='git status'
funcsave gst

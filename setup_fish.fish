#!/usr/bin/fish

curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
fisher add oh-my-fish/theme-bobthefish
fisher add jethrokuan/z
fish_update_completions


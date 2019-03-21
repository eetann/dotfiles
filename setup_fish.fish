#!/usr/bin/fish

# make link
sudo ln -s /mnt/c/Users/admin/dotfiles/wsl.conf /etc/wsl.conf
ln -s /mnt/c/Users/admin/dotfiles/.vimrc .vimrc
ln -s /mnt/c/Users/admin/.vim .vim
ln -s /mnt/c/Users/admin/dotfiles/config.fish  ~/.config/fish/config.fish
ln -s /mnt/c/Users/admin/dotfiles/flake8 ~/.config/flake8

fish_update_completions
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
fisher add oh-my-fish/theme-bobthefish
fisher add jethrokuan/z


#!/bin/bash

# change the time zone to JST
yes | sudo dpkg-reconfigure tzdata

# change Japan's repository from overseas for speed
yes | sudo sed -i -e 's%http://.*.ubuntu.com%http://ftp.jaist.ac.jp/pub/Linux%g' /etc/apt/sources.list

# update & upgrade pacage
yes | sudo apt-get update
yes | sudo apt-get upgrade

# install git
yes | sudo apt install git

# change command output to Japanese
yes | sudo apt install language-pack-ja

# change error message to Japanese
yes | sudo update-locale LANG=ja_JP.UTF-8

# install Japanese manual
yes | sudo apt install manpages-ja manpages-ja-dev

# for using latest viming
yes | sudo apt remove vim
yes | sudo add-apt-repository ppa:jonathonf/vim
yes | sudo apt update
yes | sudo apt upgrade
yes | sudo apt install vim
yes | sudo apt install vim-gtk
yes | sudo apt install xdg-utils
yes | sudo apt install x11-apps
yes | sudo apt install cmigemo
yes | sudo apt install pandoc
yes | sudo apt install tree

# install golang
yes | sudo add-apt-repository ppa:longsleep/golang-backports
yes | sudo apt install golang-go
mkdir ~/go
mkdir ~/go/bin
go get github.com/mattn/jvgrep
go get github.com/mattn/memo

# install for c/c++
yes | sudo apt install build-essential
yes | sudo apt install clang
yes | sudo apt install cmake
yes | sudo apt install clang-format
yes | sudo apt install clang-tools

# install for Python3
yes | sudo apt install python3.7
yes | sudo apt install python3-pip
pip3 install --user python-language-server
pip3 install --user pyls-black
pip3 install --user pyls-isort
pip3 install --user flake8 isort black
pip3 install --user neovim
pip3 install --user vim-vint
pip3 install --user numpy
pip3 install --user matplotlib
pip3 install --user pandas
yes | sudo apt install python3-tk

# for python3.7 & neovim
# git clone git://github.com/yyuu/pyenv.git ~/.pyenv
# sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
# pyenv install 3.7.3
# pyenv global 3.7.3
sudo add-apt-repository ppa:neovim-ppa/unstable
yes | sudo apt install neovim


# install universal-ctags
yes | sudo apt install autoconf
yes | sudo apt install pkg-config
git clone https://github.com/universal-ctags/ctags.git
cd ctags
./autogen.sh
./configure
make
sudo make install
cd

# fzf
git clone https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install

# install fish & change login shell
sudo apt-add-repository ppa:fish-shell/release-3
yes | sudo apt install fish

# make link
mkdir ~/.config
mkdir ~/.config/fish
ln -s /mnt/c/Users/admin/ ~/myhome
ln -s /mnt/c/Users/admin/dotfiles/ dotfiles
ln -s /mnt/c/Users/admin/dotfiles/fish/config.fish  ~/.config/fish/config.fish
ln -s /mnt/c/Users/admin/dotfiles/fish/fish_user_key_bindings.fish ~/.config/fish/functions/fish_user_key_bindings.fish
ln -s /mnt/c/Users/admin/dotfiles/fish/tm.fish ~/.config/fish/functions/tm.fish
ln -s /mnt/c/Users/admin/dotfiles/vim/.vimrc ~/.vimrc
ln -s /mnt/c/Users/admin/dotfiles/vim/flake8 ~/.config/flake8
ln -s /mnt/c/Users/admin/dotfiles/vim/pylintrc ~/.config/pylintrc
ln -s /mnt/c/Users/admin/.vim .vim
ln -s /mnt/c/Users/admin/dotfiles/tmux.conf ~/.tmux.conf
mkdir ~/.config/nvim
ln -s /mnt/c/Users/admin/dotfiles/vim/.vimrc ~/.config/nvim/init.vim

# for coc.nvom
# curl --compressed -o- -L https://yarnpkg.com/install.sh | sh
# npm install -g yarn

# /etc/wsl.conf に以下の内容を書く
# [interop]
# appendWindowsPath = false

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# wslでwindowsのバッテリーを見るために以下をwindows側で実行
# go get -u github.com/Code-Hex/battery/cmd/battery

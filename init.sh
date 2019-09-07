#!/bin/sh

# change the time zone to JST
yes | sudo dpkg-reconfigure tzdata

# change Japan's repository from overseas for speed
yes | sudo sed -i -e 's%http://.*.ubuntu.com%http://ftp.jaist.ac.jp/pub/Linux%g' /etc/apt/sources.list

# update & upgrade pacage
yes | sudo apt-get update
yes | sudo apt-get upgrade

# install git
yes | sudo apt install git

# for using latest viming
yes | sudo apt remove vim
yes | sudo add-apt-repository ppa:jonathonf/vim
yes | sudo apt update
yes | sudo apt upgrade
yes | sudo apt install vim
yes | sudo apt install vim-gtk
yes | sudo apt install xdg-utils
yes | sudo apt install x11-apps
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
# 別のパッケージ管理する?
yes | sudo apt install python3-pip
pip3 install --user python-language-server[all]
pip3 uninstall pyflakes pycodestyle
pip3 install --user pyls-black
pip3 install --user pyls-isort
pip3 install --user flake8 isort black
pip3 install --user pynvim
pip3 install --user vim-vint
pip3 install --user numpy
pip3 install --user matplotlib
pip3 install --user pandas
yes | sudo apt install python3-tk
# pythonのクラス図を作成
yes | sudo apt install graphviz
yes | sudo apt install python3.7


# install universal-ctags
yes | sudo apt install autoconf
yes | sudo apt install pkg-config
git clone https://github.com/universal-ctags/ctags.git
cd ctags
./autogen.sh
./configure
make
sudo make install

# fzf
git clone https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install

# install for zsh
yes | sudo apt install zsh
chsh -s /usr/bin/zsh
mkdir ~/.config
exec $SHELL -l

# /etc/wsl.conf に以下の内容を書く
# [interop]
# appendWindowsPath = false

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# wslでwindowsのバッテリーを見るために以下をwindows側で実行
# go get -u github.com/Code-Hex/battery/cmd/battery

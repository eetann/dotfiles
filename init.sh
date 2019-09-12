#!/bin/sh
# install for zsh
yes | sudo apt install zsh
chsh -s /usr/bin/zsh
mkdir ~/.config
exec /usr/bin/zsh -l

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
git clone https://github.com/anyenv/anyenv ~/.anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"
pyenv install 3.7.3
pyenv global 3.7.3
pip install pylint mccabe rope python-language-server pyls-black pyls-isort \
    pynvim vim-vint numpy matplotlib pandas
# yes | sudo apt install python3-tk
# pythonのクラス図を作成
# yes | sudo apt install graphviz
# pip3 uninstall pyflakes pycodestyle


# install universal-ctags
yes | sudo apt install autoconf
yes | sudo apt install pkg-config
git clone https://github.com/universal-ctags/ctags.git
cd ctags
./autogen.sh
./configure
make
sudo make install

# /etc/wsl.conf に以下の内容を書く
# [interop]
# appendWindowsPath = false

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# wslでwindowsのバッテリーを見るために以下をwindows側で実行
# go get -u github.com/Code-Hex/battery/cmd/battery
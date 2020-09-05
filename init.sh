#!/bin/sh

grep appendWindasdfowsPath /etc/wsl.conf
if [ $? != 0 ]; then
    echo '1. sudo vim /etc/wsl.conf で以下を書き込む'
    echo '[interop]'
    echo 'appendWindowsPath = false'
    echo '2. exec $SHELL -l'
    exit
fi

# change the time zone to JST
yes | sudo dpkg-reconfigure tzdata

# change Japan's repository from overseas for speed
yes | sudo sed -i -e 's%http://.*.ubuntu.com%http://ftp.jaist.ac.jp/pub/Linux%g' /etc/apt/sources.list

# update & upgrade pacage
yes | sudo apt update
yes | sudo apt upgrade
yes | sudo apt install sox tree nkf git golang

# for golang
# pオプションで親子両方作成
mkdir -p ~/go/bin

# lazygitの追加
yes | sudo add-apt-repository ppa:lazygit-team/release
yes | sudo apt update
yes | sudo apt install lazygit

# for using latest vim
yes | sudo apt install vim-gtk3
cd ~
git clone https://github.com/vim/vim.git
cd vim
./configure \
    --enable-xim \
    --with-features=huge \
    --enable-multibyte \
    --enable-gtk3-check \
    --enable-python3interp
    --enable-fail-if-missing \
    --with-x
make
sudo make install
vim --version

# install for c/c++
# https://clangd.llvm.org/installation.html
sudo apt install clangd-10
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-10 100

# install for Python3
pip3 install pylint mccabe rope python-language-server flake8 pyls-black pyls-isort \
    pynvim numpy matplotlib pandas opencv-python online-judge-tools pysimplegui

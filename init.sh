#!/bin/sh
# install for zsh
yes | sudo apt install zsh
chsh -s /usr/bin/zsh
mkdir ~/.config
exec /usr/bin/zsh -l
# zshのプラグインマネージャーzinit
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# change the time zone to JST
yes | sudo dpkg-reconfigure tzdata

# change Japan's repository from overseas for speed
yes | sudo sed -i -e 's%http://.*.ubuntu.com%http://ftp.jaist.ac.jp/pub/Linux%g' /etc/apt/sources.list

# update & upgrade pacage
yes | sudo apt-get update
yes | sudo apt-get upgrade

# install git
yes | sudo apt install git
# lazygitの追加
yes | sudo add-apt-repository ppa:lazygit-team/release
yes | sudo apt-get update
yes | sudo apt-get install lazygit

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

# install universal-ctags
# yes | sudo apt install autoconf
# yes | sudo apt install pkg-config
# git clone https://github.com/universal-ctags/ctags.git
# cd ctags
# ./autogen.sh
# ./configure
# make
# sudo make install

# /etc/wsl.conf に以下の内容を書く
# [interop]
# appendWindowsPath = false

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# wslでwindowsのバッテリーを見るために以下をwindows側で実行
# go get -u github.com/Code-Hex/battery/cmd/battery

# git clone https://github.com/skanehira/gtran.git ~/.gtran
# cd ~/.gtran
# go install

# latexのために
# suto apt install texlive
# https://osdn.net/projects/mytexpert/downloads/26068/jlisting.sty.bz2/
# https://ctan.org/tex-archive/macros/generic/dirtree
# をDL
# ファイルを適切なディレクトリに移動してから
# bunzip2 jlisting.sty.bz2
# sudo mv jlisting.sty /usr/share/texlive/texmf-dist/tex/latex/listings
# cd /usr/share/texlive/texmf-dist/tex/latex/listings
# chmod 644 jlisting.sty
# sudo mktexlsr
# unzip dirtree.zip
# cd dirtree

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

# install git
yes | sudo apt install git
# lazygitの追加
yes | sudo add-apt-repository ppa:lazygit-team/release
yes | sudo apt update
yes | sudo apt install lazygit

# for using latest vim
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
yes | sudo apt update
yes | sudo apt install golang-go
mkdir ~/go
mkdir ~/go/bin

# install for c/c++
sudo apt install clang-tools-8
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-8 100

# install for Python3
# 別のパッケージ管理する?
yes | sudo apt install python3 python3-pip
pip3 install pip -U
git clone https://github.com/anyenv/anyenv ~/.anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"
yes | anyenv install --init
anyenv install pyenv
exec $SHELL -l
sudo apt install zlib1g-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev
pyenv install 3.8.1
pyenv global 3.8.1
pip install pylint mccabe rope python-language-server pyls-black pyls-isort \
    pynvim vim-vint numpy matplotlib pandas opencv-python

# install universal-ctags
# yes | sudo apt install autoconf
# yes | sudo apt install pkg-config
# git clone https://github.com/universal-ctags/ctags.git
# cd ctags
# ./autogen.sh
# ./configure
# make
# sudo make install

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "tmux起動したら prefix + I で プラグインをインストール"
# wslでwindowsのバッテリーを見るために以下をwindows側で実行
# go get -u github.com/Code-Hex/battery/cmd/battery

# latexのために
sudo apt install texlive
sudo apt install latexmk
# https://osdn.net/projects/mytexpert/downloads/26068/jlisting.sty.bz2/
# https://ctan.org/tex-archive/macros/generic/dirtree
# https://www.ctan.org/pkg/matlab-prettifier
# をDL
# ファイルを適切なディレクトリに移動してから
# bunzip2 jlisting.sty.bz2
# sudo mv jlisting.sty /usr/share/texlive/texmf-dist/tex/latex/listings
# cd /usr/share/texlive/texmf-dist/tex/latex/listings
# chmod 644 jlisting.sty
# sudo mktexlsr
# unzip dirtree.zip
# ディレクトリ戻る
# cd dirtree
# latex dirtree.ins
# cd ..
# sudo mv dirtree.sty /usr/share/texlive/texmf-dist/tex/latex/dirtree
# cd /usr/share/texlive/texmf-dist/tex/latex/dirtree
# chmod 644 dirtree.sty
# sudo mktexlsr
# unzip matlab-prettifier.zip
# latex matlab-prettifier.ins
# sudo mkdir /usr/share/texlive/texmf-dist/tex/latex/matlab-prettifier
# sudo mv matlab-prettifier.sty /usr/share/texlive/texmf-dist/tex/latex/matlab-prettifier
# cd /usr/share/texlive/texmf-dist/tex/latex/matlab-prettifier
# chmod 644 matlab-prettifier.sty
# sudo mktexlsr

# install for zsh
yes | sudo apt install zsh
chsh -s /usr/bin/zsh
mkdir ~/.config
exec /usr/bin/zsh -l
# zshのプラグインマネージャーzinit
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
zinit self-update

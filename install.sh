#!/usr/bin/env bash
sudo apt install -y git build-essential
echo "Installed build tools."
git clone https://github.com/eetann/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles
echo "Got dotfiles."
make install

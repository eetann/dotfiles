#!/usr/bin/env bash
sudo apt install -y git build-essential
git clone https://github.com/eetann/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles
make install

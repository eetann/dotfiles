#!/bin/bash

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

# change the time zone to JST
yes | sudo dpkg-reconfigure tzdata

# install buile tool tools & clang & make
yes | sudo apt install build-essential

yes | sudo apt install clang

yes | sudo apt install cmake

# make link
ln -s /mnt/c/Users/admin/dotfiles/.vimrc .vimrc
ln -s /mnt/c/Users/admin/.vim .vim

# install fish & change login shell
yes | sudo apt install fish
yes | sudo chsh -s `which fish`

# to invalidate to append windows Path
yes | sudo touch /etc/wsl.conf
yes | sudo echo '[interop]' >> /etc/wsl.conf
yes | sudo echo 'appendWindowsPath = false' >> /etc/wsl.conf 



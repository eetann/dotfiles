#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=$HOME/dotfiles; export DOTPATH
fi

# load useful functions
. "$DOTPATH"/etc/scripts/header.sh

PKG_DEFAULT="git tree nkf curl"
PKG_UBUNTU="neovim manpages-ja manpages-ja-dev wamerican"
PKG_BREW="bat ripgrep lazygit tmux ghq zsh"

brewinstall() {
  log "Installing packages ..."
  brew install $PKG_BREW
  brew doctor
  info "Installed Homebrew."
}

ubuntu() {
  log "Installing packages ..."

  sudo apt update -qq -y
  sudo apt upgrade -qq -y
  sudo apt install -qq -y $PKG_DEFAULT
  sudo apt install -qq -y software-properties-common

  if ! has "neovim"; then
    sudo add-apt-repository ppa:neovim-ppa/unstable
  fi
  sudo apt update -qq -y
  sudo apt upgrade -qq -y
  sudo apt install -qq -y $PKG_UBUNTU

  # https://docs.brew.sh/Homebrew-on-Linux
  log "Installing Homebrew ..."
  if ! has "brew"; then
    BUILD_PKG_UBUNTU="build-essential procps curl file git"
    sudo apt update -q -y
    sudo apt upgrade -q -y
    sudo apt install -q -y $BUILD_PKG_UBUNTU

    # Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    # test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    # test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    # test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    # echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
    echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> ~/.bash_profile
    echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> ~/.zprofile
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  fi
  brewinstall

  info "Installed packages."
}

case $(detect_os) in
  ubuntu)
    ubuntu ;;
esac

if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo ""

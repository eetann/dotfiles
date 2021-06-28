#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=$HOME/dotfiles; export DOTPATH
fi

# load useful functions
. "$DOTPATH"/etc/scripts/header.sh

log "Installing Homebrew ..."

ubuntu() {
  PKG_UBUNTU="build-essential procps curl file git"
  sudo apt update -q -y
  sudo apt upgrade -q -y
  sudo apt install -q -y $PKG_UBUNTU

  # Homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  # test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  # test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  # test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
  # echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
  echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> ~/.bash_profile
  echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> ~/.zprofile
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  info "Installed Homebrew."
  # https://docs.brew.sh/Homebrew-on-Linux
}

if ! has "brew"; then
  case $(detect_os) in
    ubuntu)
      ubuntu ;;
  esac
fi

log "Installing packages ..."
brew install bat ripgrep lazygit ghq
git config --global --add ghq.root $GOPATH/src
git config --global --add ghq.root $HOME/ghq


# zsh
brew install zsh
cd ~
mkdir -p ~/.config

# zinit
mkdir -p ~/.zinit
if [ ! -d ~/.zinit/bin ]; then
  git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
fi

# efm-langserver
mkdir -p ~/.config/efm-langserver
brew install efm-langserver

info "Installed packages."

brew doctor

echo ""

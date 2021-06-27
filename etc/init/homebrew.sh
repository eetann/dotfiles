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
  sudo apt install -q -y "$PKG_UBUNTU"

  # Homebrew
  test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
  info "Installed Homebrew."
  # https://docs.brew.sh/Homebrew-on-Linux
}

case $(detect_os) in
  ubuntu)
    ubuntu ;;
esac

log "Installing packages ..."
brew install bat ripgrep lazygit ghq
git config --global --add ghq.root $GOPATH/src
git config --global --add ghq.root $HOME/ghq


# zsh
brew install zsh
chsh -s /usr/bin/zsh
cd ~
mkdir -p ~/.config
exec /usr/bin/zsh -l

# zinit
mkdir ~/.zinit
git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
source ~/.zinit/bin/zinit.zsh
zinit self-update
# For change the commandline theme
fast-theme clean
# https://github.com/zdharma/zinit#manual-installation

# efm-langserver
mkdir -p ~/.config/efm-langserver
brew install efm-langserver

info "Installed packages."

brew doctor

echo ""

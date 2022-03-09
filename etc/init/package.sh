#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=$HOME/dotfiles; export DOTPATH
fi

# load useful functions
. "$DOTPATH"/etc/scripts/header.sh

PKG_DEFAULT="git tree nkf curl"
PKG_UBUNTU="manpages-ja manpages-ja-dev wamerica"

ubuntu() {
  log "Installing packages ..."

  sudo apt update -qq -y
  sudo apt upgrade -qq -y
  sudo apt install -qq -y $PKG_DEFAULT
  sudo apt install -qq -y $PKG_UBUNTU
  sudo apt install -qq -y software-properties-common
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

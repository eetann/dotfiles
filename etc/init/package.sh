#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=$HOME/dotfiles; export DOTPATH
fi

# load useful functions
. "$DOTPATH"/etc/scripts/header.sh

PKG_DEFAULT="git tree nkf tmux curl"

ubuntu() {
  log "Installing packages ..."

  sudo apt update -q -y
  sudo apt upgrade -q -y
  sudo apt install -q -y $PKG_DEFAULT
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  info "Installed packages."
}

case $(detect_os) in
  ubuntu)
    ubuntu ;;
esac

echo ""

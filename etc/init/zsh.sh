#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=$HOME/dotfiles; export DOTPATH
fi

# load useful functions
. "$DOTPATH"/etc/scripts/header.sh


log "Installing Zsh ..."

ubuntu() {
  sudo apt update -qq -y
  sudo apt upgrade -qq -y
  sudo apt install -qq -y zsh
}

case $(detect_os) in
  ubuntu)
    ubuntu ;;
esac

info "Installed Zsh."

echo ""

#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=$HOME/.dotfiles; export DOTPATH
fi

# load useful functions
. "$DOTPATH"/etc/scripts/header.sh

ubuntu() {
  yes | sudo add-apt-repository ppa:longsleep/golang-backports
  yes | sudo apt update
  yes | sudo apt install golang-go
  # https://github.com/golang/go/wiki/Ubuntu
}

if ! has "go"; then
  log "Installing golang ..."
  case $(detect_os) in
    ubuntu)
      ubuntu ;;
  esac
  info "Installed golang."
fi

if ! has "jvgrep"; then
  log "Installing jvgrep ..."
  go get github.com/mattn/jvgrep
  info "Installed jvgrep."
fi

if ! has "mmv"; then
  log "Installing mmv ..."
  go get github.com/itchyny/mmv/cmd/mmv
  info "Installed mmv."
fi

echo ""

#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=$HOME/dotfiles; export DOTPATH
fi

# load useful functions
. "$DOTPATH"/etc/scripts/header.sh

ubuntu() {
  sudo add-apt-repository -y ppa:longsleep/golang-backports
  sudo apt update -y -qq
  sudo apt install -y -qq golang
  # https://github.com/golang/go/wiki/Ubuntu
}


archlinux() {
  sudo pacman -S go
}

mkdir -p $HOME/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH:$GOPATH/bin

if ! has "go"; then
  log "Installing golang ..."
  case $(detect_os) in
    ubuntu)
      ubuntu ;;
    archlinux)
      archlinux;;
  esac
  info "Installed golang."
fi

if ! has "jvgrep"; then
  log "Installing jvgrep ..."
  go install github.com/mattn/jvgrep@latest
  info "Installed jvgrep."
fi

if ! has "mmv"; then
  log "Installing mmv ..."
  go install github.com/itchyny/mmv/cmd/mmv@latest
  info "Installed mmv."
fi

echo ""

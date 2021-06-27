#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=$HOME/.dotfiles; export DOTPATH
fi

# load useful functions
. "$DOTPATH"/etc/scripts/header.sh

echo ""

ubuntu() {
  log "Changing for jp ..."
  # change the time zone to JST
  yes | sudo dpkg-reconfigure tzdata

  # change Japan's repository from overseas for speed
  yes | sudo sed -i -e 's%http://.*.ubuntu.com%http://ftp.jaist.ac.jp/pub/Linux%g' /etc/apt/sources.list

  info "Changed the time zone and sources.list."
}

case $(detect_os) in
  ubuntu)
    ubuntu ;;
esac

echo ""

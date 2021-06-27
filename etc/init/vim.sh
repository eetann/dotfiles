#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=$HOME/.dotfiles; export DOTPATH
fi

# load useful functions
. "$DOTPATH"/etc/scripts/header.sh


log "Building Vim ..."


ubuntu() {
  PKG_BUILD="git gettext libtinfo-dev libacl1-dev libgpm-dev build-essential"
  PKG_BUILD+="libxt-dev"
  PKG_BUILD+="libxmu-dev libgtk-3-dev libxpm-dev"
  PKG_BUILD+="python-dev python3-dev"
  sudo apt update -q -y
  sudo apt upgrade -q -y
  sudo apt install -q -y "$PKG_BUILD"
}

case $(detect_os) in
  ubuntu)
    ubuntu ;;
esac


cd ~
git clone https://github.com/vim/vim.git
cd ~/vim/src
./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-gtk3-check \
    --enable-python3interp \
    --enable-fail-if-missing \
    --enable-xim \
    --with-x
make
sudo make install
hash -r
vim --version
info "Built Vim."

echo ""

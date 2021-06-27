#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=$HOME/dotfiles; export DOTPATH
fi

# load useful functions
. "$DOTPATH"/etc/scripts/header.sh

ubuntu() {
  if ! has "asdf"; then
    # asdf
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    cd ~/.asdf
    git checkout "$(git describe --abbrev=0 --tags)"
    # https://asdf-vm.com/#/core-manage-asdf
    log "Installed asdf."

    # nodejs
    # Check the latest good version at https://nodejs.org/ja/download/
    # You need to rewrite `nodenv install xx.xx.x` and `nodenv global xx.xx.x`
		# Or asdf latest <name>
    asdf plugin add nodejs
    asdf install nodejs 14.16.0
    asdf global nodejs 14.16.0

    # npm list --global --depth=0
    npm install -g textlint textlint-rule-preset-ja-technical-writing
    log "Installed nodejs."
  fi
}


case $(detect_os) in
  ubuntu)
    ubuntu ;;
esac

echo ""

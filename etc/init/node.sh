#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

if [ -z "${DOTPATH:-}" ]; then
	DOTPATH=$HOME/dotfiles
	export DOTPATH
fi

# load useful functions
. "$DOTPATH"/etc/scripts/header.sh

# check `npm ls -g`
PKG_DEFAULT="textlint textlint-rule-preset-ja-technical-writing eslint_d"

all_env() {
	log "Installing packages ..."

	curl https://get.volta.sh | bash
	export VOLTA_HOME=$HOME/.volta
	export PATH=$PATH:$VOLTA_HOME/bin
	volta install node
	npm install -g $PKG_DEFAULT
	info "Installed packages."
}

all_env

echo ""

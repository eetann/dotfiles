#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

if [ -z "${DOTPATH:-}" ]; then
	DOTPATH=$HOME/dotfiles
	export DOTPATH
fi

# load useful functions
. "$DOTPATH"/etc/scripts/header.sh

if ! command -v brew >/dev/null 2>&1; then
	error "brewが見つかりません。このスクリプトはmacOS専用です（NixOS-WSLでは使用しません）。"
	exit 1
fi

brew bundle --file "$HOME/dotfiles/etc/init/Brewfile"

echo ""

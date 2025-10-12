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
# vscode-langservers-extractedはESLintのため: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
PKG_DEFAULT="vscode-langservers-extracted tree-sitter-cli"

ubuntu() {
	# https://nodejs.org/en/download/package-manager
	curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && \ sudo apt-get install -y nodejs
}
archlinux() {
	sudo pacman -S nodejs npm
}
darwin() {
	# brew install node
  info "node"
}

log "Installing packages ..."
case $(detect_os) in
ubuntu)
	ubuntu
	;;
archlinux)
	archlinux
	;;
darwin)
	darwin
	;;
esac
curl -fsSL https://bun.sh/install | bash
bun add -g $PKG_DEFAULT
info "Installed packages."

echo ""

#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

if [ -z "${DOTPATH:-}" ]; then
	DOTPATH=$HOME/dotfiles
	export DOTPATH
fi

# load useful functions
. "$DOTPATH"/etc/scripts/header.sh

ubuntu() {
	if ! has "pip3"; then
		sudo apt install -qq -y python3-pip
		log "Installed pip3 packages."
	fi
	# https://www.python.jp/install/ubuntu/pip.html#2XQ9V7
}

archlinux() {
	sudo pacman -S python python-pip
}

case $(detect_os) in
ubuntu)
	ubuntu
	;;
archlinux)
	archlinux
	;;
esac

pip3 install --user pynvim numpy matplotlib pandas opencv-python pysimplegui

echo ""

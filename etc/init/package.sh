#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

if [ -z "${DOTPATH:-}" ]; then
	DOTPATH=$HOME/dotfiles
	export DOTPATH
fi

# load useful functions
. "$DOTPATH"/etc/scripts/header.sh

PKG_DEFAULT="git tree nkf curl"

PKG_UBUNTU="manpages-ja manpages-ja-dev wamerican"

PKG_ARCH="neovim alacritty tmux words lazygit fcitx5-im fcitx5-mozc xdg-user-dirs-gtk"
PKG_ARCH+=" vivaldi powertop tlp rofi bat ghq ripgrep"
PKG_ARCH+=" playerctl light ttf-font-awesome noto-fonts noto-fonts-cjk noto-fonts-emoji spotify"
PKG_ARCH+=" shellcheck shfmt direnv"

ubuntu() {
	log "Installing packages ..."

	sudo apt update -qq -y
	sudo apt upgrade -qq -y
	sudo apt install -qq -y ${PKG_DEFAULT}
	sudo apt install -qq -y software-properties-common

	if ! has "neovim"; then
		sudo add-apt-repository ppa:neovim-ppa/unstable
	fi
	sudo apt update -qq -y
	sudo apt upgrade -qq -y
	sudo apt install -qq -y ${PKG_UBUNTU}

	# https://docs.brew.sh/Homebrew-on-Linux
	log "Installing Homebrew ..."
	if ! has "brew"; then
		BUILD_PKG_UBUNTU="build-essential procps curl file git"
		sudo apt update -q -y
		sudo apt upgrade -q -y
		sudo apt install -q -y ${BUILD_PKG_UBUNTU}
		sudo snap install --beta nvim --classic

		# Homebrew
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
		#shellcheck disable=SC2016
		echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.bash_profile
		#shellcheck disable=SC2016
		echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.zprofile
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	fi
	brew bundle --file "$HOME/dotfiles/etc/init/Brewfile"

	info "Installed packages."
}

archlinux() {
	log "Installing packages ..."

	sudo pacman -S "$PKG_ARCH"

	info "Installed packages."
}

# Mac
darwin() {
	brew bundle --file "$HOME/dotfiles/etc/init/Brewfile"
}

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

if [ ! -d ~/.tmux/plugins/tpm ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo ""

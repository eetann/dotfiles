#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

if [ -z "${DOTPATH:-}" ]; then
	DOTPATH=$HOME/dotfiles
	export DOTPATH
fi

# load useful functions
. "$DOTPATH"/etc/scripts/header.sh

install_omz_plug() {
	if [ ! -d "$HOME/.oh-my-zsh" ]; then
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	fi

	ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
	if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
		git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
	fi

	if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
		git clone https://github.com/zsh-users/zsh-completions.git "$ZSH_CUSTOM/plugins/zsh-completions"
	fi

	if [ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ]; then
		git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
	fi

	if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
		git clone https://github.com/zsh-users/zsh-history-substring-search.git "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
	fi

	if [ ! -d "$HOME/rupaz" ]; then
		git clone https://github.com/rupa/z.git "$HOME/rupaz"
	fi

	if [ ! -d "$HOME/.fzf" ]; then
		git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
		~/.fzf/install --key-bindings --completion --no-update-rc
	fi

  if [[ ! -d "$ZSH_CUSTOM/plugins/zeno" ]]; then
    git clone https://github.com/yuki-yano/zeno.zsh.git "$ZSH_CUSTOM/plugins/zeno"
  fi

	if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
	fi
}

install_omz_plug
fast-theme clean

echo ""

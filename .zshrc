export ZDIR=$HOME/dotfiles/zsh

source $ZDIR/000_path.zsh
source $ZDIR/001_operation.zsh
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $ZDIR/002_completion.zsh
source $ZDIR/003_plugin.zsh
source $ZDIR/004_alias.zsh

foreach script ($ZDIR/myfunction/*.zsh) {
  source $script
}

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
if type mise > /dev/null; then
  eval "$(mise activate zsh)"
fi
export SKIP_FIREBASE_FIRESTORE_SWIFT=1

# tmux未起動、vim・VSCodeの中じゃない、ログインシェルなら
# if [[ -z "$TMUX" && -z "$VIM" && "$TERM_PROGRAM" != "vscode" && $- == *l* && -z "$NO_TMUX" ]] ; then
#   tmux-first-choose-session
# fi

export GOPATH=$HOME/go
export BUN_INSTALL="$HOME/.bun"
path+=(
  $HOME/dotfiles/bin(N-/)
  $GOPATH(N-/)
  $GOPATH/bin(N-/)
  $HOME/.local/bin(N-/)
  $HOME/.cargo/bin(N-/)
  $HOME/.luarocks/bin(N-/)
  $HOME/.deno/env(N-/)
  /snap/bin(N-/)
  $BUN_INSTALL/bin(N-/)
)

if type nvim > /dev/null; then
  export EDITOR=nvim
  export MANPAGER="nvim +Man!"
else
  export EDITOR=vim
fi

# Rancher Desktop > Preferences > Application > Environment > Manual を設定
path+=($HOME/.rd/bin(N-/))

if [ -e $HOME/Library/Android/sdk ]; then
  export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
  path+=(
    # avdmanager, sdkmanager
    $ANDROID_SDK_ROOT/tools/bin(N-/)
    # adb, logcat
    $ANDROID_SDK_ROOT/platform-tools(N-/)
    # emulator
    $ANDROID_SDK_ROOT/emulator(N-/)
  )
fi

# 重複排除とパスの順序維持
typeset -U path PATH

# tmux未起動、vim・VSCodeの中じゃない、ログインシェルなら
if [[ -z "$TMUX" && -z "$VIM" && "$TERM_PROGRAM" != "vscode" && $- == *l* && -z "$NO_TMUX" ]] ; then
  tmux-first-choose-session
fi

if type direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi
export LG_CONFIG_FILE="$HOME/dotfiles/.config/lazygit/config.yml"

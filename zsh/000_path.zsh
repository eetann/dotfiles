export GOPATH=$HOME/go
export BUN_INSTALL="$HOME/.bun"
path+=(
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

# tmuxが起動していない&vimの中でなければ、tmux起動
if [[ -z "$TMUX" && -z "$VIM" && $- == *l* ]] ; then
  if [[ $TERM_PROGRAM != "vscode" ]] ; then
    # get the IDs
    ID="`tmux list-sessions`"
    if [[ -z "$ID" ]]; then
      tmux new-session
    fi
    create_new_session="Create New Session"
    ID="$ID\n${create_new_session}:"
    ID="`echo $ID | fzf | cut -d: -f1`"
    if [[ "$ID" = "${create_new_session}" ]]; then
      tmux new-session
    elif [[ -n "$ID" ]]; then
      tmux attach-session -t "$ID"
    else
      :  # Start terminal normally
    fi
  fi
fi

# 重複排除とパスの順序維持
typeset -U path PATH

if type direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi
export LG_CONFIG_FILE="$HOME/dotfiles/.config/lazygit/config.yml"

# tmuxが起動していない&vimの中でなければ、tmux起動
if [[ -z "$TMUX" && -z "$VIM" && $- == *l* ]] ; then
  # golang tmuxに必要なので読み込む
  export GOPATH=$HOME/go
  export PATH=$PATH:$GOPATH:$GOPATH/bin
  export PATH=$HOME/.local/bin:$PATH
  export PATH=$PATH:$HOME/.cargo/bin
  if [ -e $HOME/.rd/bin ]; then
    export PATH=$HOME/.rd/bin:$PATH
  fi

  if [ -e $HOME/Library/Android/sdk ]; then
    export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
    # avdmanager, sdkmanager
    export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin
    # adb, logcat
    export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
    # emulator
    export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
  fi

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

# =では空白入れないこと!!!
# pathなどの設定--------------------------------------------------
typeset -U path PATH
snap_bin_path="/snap/bin"
if [ -n "${PATH##*${snap_bin_path}}" -a -n "${PATH##*${snap_bin_path}:*}" ]; then
  export PATH=$PATH:${snap_bin_path}
fi


if type nvim > /dev/null; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

if type direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi
export LG_CONFIG_FILE="$HOME/dotfiles/.config/lazygit/config.yml"

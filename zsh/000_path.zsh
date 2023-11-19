# tmuxが起動していない&vimの中でなければ、tmux起動
if [[ -z "$TMUX" && -z "$VIM" && $- == *l* ]] ; then
  # golang tmuxに必要なので読み込む
  export GOPATH=$HOME/go
  export PATH=$PATH:$GOPATH:$GOPATH/bin
  export PATH=$HOME/.local/bin:$PATH
  export VOLTA_HOME=$HOME/.volta
  export PATH=$PATH:$VOLTA_HOME/bin:$HOME/.cargo/bin

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

# =では空白入れないこと!!!
# pathなどの設定--------------------------------------------------
typeset -U path PATH
# WSL用
if [[ "$(uname -r)" == *microsoft* ]]; then
  LOCAL_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
  export DISPLAY=$LOCAL_IP:0.0
  export PATH=$PATH:/mnt/c/Windows/System32
fi

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

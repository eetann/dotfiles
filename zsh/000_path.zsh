# tmuxが起動していない&vimの中でなければ、tmux起動
if [[ -z "$TMUX" ]] && [[ -z "$VIM" ]] ; then
    # golang tmuxに必要なので読み込む
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH:$GOPATH/bin

    tmux -u has-session -t e 2>/dev/null || tmux -u new-session -ds e \
        && tmux -u attach-session -t e
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

export EDITOR=vim

. $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)

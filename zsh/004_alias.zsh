alias rm='gomi'
alias la='ls -F --color -alh'
alias ls='ls -F --color'
alias reload="source ~/.zshrc"
alias echopath="echo $PATH | sed -e 's/:/\n/g'"
alias manja="man -L ja"
alias manen="man -L en"
alias lg='lazygit --use-config-dir="$HOME/.config/lazygit"'
alias zd='cd ~/dotfiles'
alias zdev='cd ~/ghq/dev/'
alias zeetann='cd ~/ghq/github.com/eetann/'
alias zhome='cd ~/.nb/home/'
alias ml='nvim .memo.local.md'
alias mt='mise watch test'
alias tn="tmux popup -E -w 95% -h 95% -d '#{pane_current_path}' 'nvim'"
alias rrmap='bun run ~/ghq/github.com/eetann/rrmap/src/cli.ts'
# portlessは実コマンドをdetached(別セッション)で起動するうえ、SIGHUPを見ていない。
# そのためターミナルを閉じるとportless本体だけがSIGHUPで即死し、後始末(killTree)が
# 走らずにサーバーだけが孤児として残る。Linuxでは親(portless)の死に道連れにして落とす。
# execでbunをportlessの直の子にするのが必須（PDEATHSIGはforkでクリアされる）。
if [[ $OSTYPE == linux* ]]; then
  alias rrmapw="portless run sh -c 'exec setpriv --pdeathsig TERM bun run ~/ghq/github.com/eetann/rrmap/src/cli.ts web --port \$PORT'"
else
  alias rrmapw="portless run sh -c 'bun run ~/ghq/github.com/eetann/rrmap/src/cli.ts web --port \$PORT'"
fi
case ${OSTYPE} in
  darwin*)
    alias awk="gawk"
    # nix経由なので元からsed・xargsになる
    # alias sed="gsed"
    # alias xargs="gxargs"
    ;;
esac
alias idea='nb e idea.md'
based-branch() {
  git show-branch \
    | grep '*' \
    | grep -v "$(git rev-parse --abbrev-ref HEAD)" \
    | head -1 \
    | awk -F'[]~^[]' '{print $2}'
}

# nocorrect
alias ionic='nocorrect ionic'
alias pod='nocorrect pod'
alias ng='nocorrect ng'

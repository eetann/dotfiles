# tmuxが起動していない&vimの中でなければ、tmux起動
if [[ -z "$TMUX" ]] && [[ -z "$VIM" ]] ; then
    # golang tmuxに必要なので読み込む
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH:$GOPATH/bin
    export PATH=$HOME/.anyenv/bin:$PATH

    tmux -u has-session -t e 2>/dev/null || tmux -u new-session -ds e \
        && tmux -u attach-session -t e
fi

eval "$(anyenv init -)"
# =では空白入れないこと!!!
# pathなどの設定--------------------------------------------------
typeset -U path PATH
# WSL用
LOCAL_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
export DISPLAY=$LOCAL_IP:0.0

export EDITOR=vim
export PATH=$PATH:/mnt/c/Windows/System32
export MYNODEBIN=`npm bin -g`
export PATH=$PATH:$HOME/.local/bin:$MYNODEBIN

# Python
export PYLINTRC=$HOME/dotfiles/vim/pylintrc
# alias python="python3"

# 操作------------------------------------------------------------
setopt no_beep
setopt IGNOREEOF # Ctrl+Dでログアウトしてしまうことを防ぐ
bindkey -e
autoload -Uz smart-insert-last-word
# [a-zA-Z], /, \ のうち少なくとも1文字を含む長さ2以上の単語
zstyle :insert-last-word match '*([[:alpha:]/\\]?|?[[:alpha:]/\\])*'
zle -N insert-last-word smart-insert-last-word
bindkey '^]' insert-last-word
bindkey "^U" backward-kill-line
bindkey "^C" send-break
# Ctrl + s の停止を無効化
stty stop undef

# 履歴------------------------------------------------------------
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000

# 補完------------------------------------------------------------
# 補完を有効化
fpath=(/usr/local/share/zsh-completions $fpath)
autoload -Uz compinit
compinit -u
setopt correct # コマンドのスペルチェックをする
setopt mark_dirs # file名の展開でdirectoryにマッチした場合末尾に/付加
setopt auto_param_keys # カッコの対応などを自動的に補完する
setopt auto_pushd # ディレクトリスタックon
setopt pushd_ignore_dups # 履歴を賢く
setopt complete_in_word # 語の途中でもカーソル位置で補完
setopt list_packed # 補完候補を詰めて表示
# setopt hist_expand # 補完時にヒストリを自動的に展開する
unsetopt print_exit_value # 戻り値が0以外の場合終了コードを表示
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
zstyle ':completion:*:default' menu select=2
# 大文字・小文字を区別しない(大文字を入力した場合は区別する)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin \
    /usr/local/git/bin
# pwdを補完候補から除外
zstyle ':completion:*' ignore-parents parent pwd ..
#入力途中の履歴補完を有効化する
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
# 入力途中の履歴補完
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

setopt interactive_comments # 対話中にもコメント可
setopt AUTO_MENU # タブキーの連打で自動的にメニュー補完
setopt chase_links # 移動先がシンボリックリンクならば実際のディレクトリに移動する

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^O" edit-command-line

# 展開------------------------------------------------------------
# Gスペース のように入力したら、勝手に | grep に置き換えてくれる
setopt extended_glob
typeset -A abbreviations
abbreviations=(
    "G"    "| grep"
    "X"    "| xargs"
    "T"    "| tail"
    "C"    "| cat"
    "W"    "| wc"
    "A"    "| awk"
    "S"    "| sed"
    "E"    "2>&1 > /dev/null"
    "N"    "> /dev/null"
    "CD"   "&& cd \$_"
    "CL"   "| clip.exe"
    "TREE" "tree -a -I '.git|node_modules'"
)

magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    zle self-insert
}

no-magic-abbrev-expand() {
    LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand

# alias-----------------------------------------------------------
alias la='ls -F --color -al'
alias ls='ls -F --color'
alias mytree='tree -a -I ".git|node_modules"'
alias grep=jvgrep
# alias t="tmuximum"
alias reload="exec zsh -l"
alias attest="[[ -e main.cpp ]] && g++ main.cpp && oj test"
alias atsubmit="[[ -e main.cpp ]] && acc submit main.cpp"

# 色--------------------------------------------------------------
autoload -Uz colors
colors
if [[ -f ~/.dircolors && -x `which dircolors` ]]; then
    eval `dircolors ~/.dircolors`
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
fi

# プロンプト------------------------------------------------------
setopt prompt_cr # 改行のない出力をプロンプトで上書きするのを防ぐ
setopt prompt_sp
setopt transient_rprompt
local my_char=039
local my_sep="%F{007} %f"
# BackgroundJob数
local prompt_job="%(1j.%U(%j)%u$my_sep .)"
# command返り値
local my_check="%(?..%F{red} $my_sep )"
# pwd
local prompt_dir="$my_check%F{$my_char}%B %~%b $my_sep"
# git
autoload -Uz vcs_info
setopt prompt_subst # 表示するたびに変数展開
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '%F{yellow}'
zstyle ':vcs_info:git:*' unstagedstr '%F{red}'
zstyle ':vcs_info:git:*' formats '%F{255} %r'$my_sep' %F{green}%c%u%b%f'
zstyle ':vcs_info:git:*' actionformats '%F{255} %r'$my_sep' %F{004}%b%f'
# プロンプト表示前にversion管理から情報を取ってくる
precmd () { vcs_info }

local prompt_git=' %B$vcs_info_msg_0_%b'
local prompt_end="%F{040}%F{039}%f"
PROMPT="$prompt_job$prompt_dir$prompt_git"$'\n'"$prompt_end"

# plugins --------------------------------------------------------
# zinit がなければ取ってくる
if [ ! -e $HOME/.zinit ]; then
    git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
fi

# zinit をロード
source $HOME/.zinit/bin/zinit.zsh
# zinit のコマンド補完をロード
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# `zinit light {plugin}`で読み込み
# その前に`zinit ice {option}`でオプションをつける
# blockf : プラグインの中で$fpathに書き込むのを禁止
zinit ice blockf
zinit light zsh-users/zsh-completions

zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

zinit light zdharma/fast-syntax-highlighting

# wait'n' : .zshrc が読み込まれて n 秒で読み込む
# nの前に!をつけると読み込み完了メッセージを非表示
zinit ice wait'!0'; zinit light rupa/z
zinit ice wait'!0'; zinit light zsh-users/zsh-history-substring-search

# as"program" : プラグインをsourceせず、$PATHに追加
zinit ice wait'!0' as"program"; zinit light arks22/tmuximum

# from"{hoge}"              : hogeからclone
# pick"hoge.zsh"            : $PATHに追加するファイルを指定
# multisrc"{hoge,fuga}.zsh" : 複数のファイルをsource
# id-as                     : ニックネーム
# atload                    : プラグインがロード後に実行
zinit ice wait"!0" from"gh-r" as"program"; zinit load junegunn/fzf-bin
zinit ice wait"!0" as"program" pick"bin/fzf-tmux"; zinit load junegunn/fzf
zinit ice wait"!0" multisrc"shell/{completion,key-bindings}.zsh"\
    id-as"junegunn/fzf_completions" pick"/dev/null"
    # atload"bindkey '^I' expand-or-complete"
# zinit light junegunn/fzf
FZF_DEFAULT_OPTS="--multi --height=60% --select-1 --exit-0 --reverse"
FZF_DEFAULT_OPTS+=" --bind ctrl-j:preview-down,ctrl-k:preview-up,ctrl-d:preview-page-down,ctrl-u:preview-page-up"
export FZF_DEFAULT_OPTS
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
nosearch=('\$RECYCLE.BIN')
nosearch+=('.git')
nosearch+=('RECYCLER')
nosearch+=('.metadata')
nosearch+=('node_modules')
find_dir="find ./ -type d \("
for d in $nosearch; do
    find_dir="$find_dir -name '$d' -o"
done
find_dir=${find_dir:0:-3}
find_file="$find_dir \) -prune -o -type f -print"
find_dir="$find_dir \) -prune -o -type d -print"
export FZF_ALT_C_COMMAND="$find_dir"
export FZF_ALT_C_OPTS="--preview 'tree -al {} | head -n 100'"
export FZF_CTRL_T_COMMAND="$find_file"
preview='[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file ||'
preview+='bat --color=always --style=header,grid --line-range :100 {}'
export FZF_CTRL_T_OPTS="--preview \"$preview\""
export FZF_COMPLETION_OPTS="--preview \"$preview\""
export FZF_COMPLETION_TRIGGER='**'

# プラグインによる関数--------------------------------------------
# z ×fzf
function fz() {
    local res=$(z | sort -rn | cut -c 12- | fzf)
    if [ -n "$res" ]; then
        BUFFER+="cd $res"
        zle accept-line
    else
        return 1
    fi
}
zle -N fz
bindkey '^xz' fz

function fghq() {
    local res=$(ghq list |fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")
    if [ -n "$res" ]; then
        BUFFER+="cd $(ghq root)/$res"
        zle accept-line
    else
        return 1
    fi
}
zle -N fghq
bindkey '^xg' fghq

function ghq-new() {
  local root=`ghq root`
  local user=`git config --get github.user`
  if [ -z "$user" ]; then
    echo "you need to set github.user."
    echo "git config --global github.user YOUR_GITHUB_USER_NAME"
    return 1
  fi
  local name=$1
  local repo="$root/github.com/$user/$name"
  if [ -e "$repo" ]; then
    echo "$repo is already exists."
    return 1
  fi
  git init $repo
  cd $repo
  sed -e "s/Awesome-name/${name}/" ~/dotfiles/vim/template/markdown/base-readme.md > README.md
  git add .
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

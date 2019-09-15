# tmuxが起動していない&vimの中でなければ、tmux起動
if [[ -z "$TMUX"  ]] && [[ -z "$VIM" ]] ; then
    # golang tmuxに必要なので読み込む
    export GOPATH=$HOME/go
    export GOPATH=/mnt/c/Users/admin/go:$GOPATH
    export PATH=$PATH:$GOPATH:$GOPATH/bin:/usr/lib/go-1.12/bin:/mnt/c/Users/admin/go/bin
    export PATH=$HOME/.anyenv/bin:$PATH

    tmux has-session -t e 2>/dev/null || tmux new-session -ds e \
        && tmux attach-session -t e
    exit
fi

eval "$(anyenv init -)"
# =では空白入れないこと!!!
# pathなどの設定--------------------------------------------------
typeset -U path PATH
export DISPLAY=localhost:0.0
export EDITOR=vim
export PATH=$PATH:/mnt/c/Windows/System32
export PATH=$PATH:$HOME/.local/bin

# Python
export PYLINTRC=$HOME/dotfiles/vim/pylintrc
# alias python="python3"

# MATLAB
export PATH=$PATH:/usr/local/MATLAB/R2019a/bin/glnxa64

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
setopt auto_cd # 入力コマンド不在 & ディレクトリ名と一致: cdする
setopt auto_pushd # ディレクトリスタックon
setopt pushd_ignore_dups # 履歴を賢く
setopt COMPLETE_IN_WORD # 語の途中でもカーソル位置で補完
setopt hist_expand
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
# 大文字・小文字を区別しない(大文字を入力した場合は区別する)
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' use-cache yes
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

setopt interactive_comments # 対話中にもコメント
setopt AUTO_MENU # タブキーの連打で自動的にメニュー補完
setopt chase_links # 移動先がシンボリックリンクならば実際のディレクトリに移動する

# alias-----------------------------------------------------------
alias la='ls -F --color -al'
alias ls='ls -F --color'
alias gs='git status'
alias ga='git add -A'
alias gd='git diff'
alias gcm='(){git commit -m "$1"}'
alias gsh='git push origin HEAD'
alias gst='git status'
alias mytree='tree -a -I ".git"'
alias grep=jvgrep
alias t="tmuximum"
alias reload="exec zsh -l"

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
precmd () { vcs_info }

local prompt_git=' %B$vcs_info_msg_0_%b'
local prompt_end="%F{040}%F{039}%f"
PROMPT="$prompt_job$prompt_dir$prompt_git"$'\n'"$prompt_end"

# plugins --------------------------------------------------------
# zplugin がなければ取ってくる
if [ ! -e $HOME/.zplugin ]; then
    git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin
fi

# zplugin をロード
source $HOME/.zplugin/bin/zplugin.zsh
# zplugin のコマンド補完をロード
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

# `zplugin light {plugin}`で読み込み
# その前に`zplugin ice {option}`でオプションをつける
# blockf : プラグインの中で$fpathに書き込むのを禁止
zplugin ice blockf
zplugin light zsh-users/zsh-completions

zplugin light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
# 遅くなる
# ZSH_AUTOSUGGEST_STRATEGY=(history completion)

zplugin light zdharma/fast-syntax-highlighting

# wait'n' : .zshrc が読み込まれて n 秒で読み込む
zplugin ice wait'0'; zplugin light b4b4r07/enhancd
zplugin ice wait'0'; zplugin light rupa/z
zplugin ice wait'0'; zplugin light zsh-users/zsh-history-substring-search

# as"program" : プラグインをsourceせず、$PATHに追加
zplugin ice wait'0' as"program"; zplugin light arks22/tmuximum

# from"{hoge}"              : hogeからclone
# pick"hoge.zsh"            : $PATHに追加するファイルを指定
# multisrc"{hoge,fuga}.zsh" : 複数のファイルをsource
# id-as                     : ニックネーム
# atload                    : プラグインがロード後に実行
zplugin ice wait"0" from"gh-r" as"program"; zplugin load junegunn/fzf-bin
zplugin ice wait"0" as"program" pick"bin/fzf-tmux"; zplugin load junegunn/fzf
zplugin ice wait"0" multisrc"shell/{completion,key-bindings}.zsh"\
    id-as"junegunn/fzf_completions" pick"/dev/null"\
    atload"bindkey '^I' expand-or-complete"
zplugin light junegunn/fzf
FZF_DEFAULT_OPTS="--multi --height=60% --select-1 --exit-0 --reverse"
FZF_DEFAULT_OPTS+=" --bind ctrl-j:preview-down,ctrl-k:preview-up,ctrl-d:preview-page-down,ctrl-u:preview-page-up"
export FZF_DEFAULT_OPTS
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
export FZF_ALT_C_COMMAND="find * -type d -maxdepth 1"
export FZF_ALT_C_OPTS="--preview 'tree -al {} | head -n 100'"
export FZF_COMPLETION_OPTS="--preview 'head -n 100 {}'"
export FZF_COMPLETION_TRIGGER=''

# プラグインによる関数--------------------------------------------
# z ×fzf
function zz() {
    local res=$(z | sort -rn | cut -c 12- | fzf)
    if [ -n "$res" ]; then
        cd $res
    else
        return 1
    fi
}

# fbr - checkout git branch
function fbr() {
    local branches branch
    branches=$(git branch -vv) &&
        branch=$(echo "$branches" | fzf +m) &&
        git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
    }

# gadd
function gadd() {
    local out q n addfiles
    while out=$(
            git status --short |
            awk '{if (substr($0,2,1) !~ / /) print $2}' |
            fzf-tmux --multi --exit-0 --expect=ctrl-d); do
        q=$(head -1 <<< "$out")
        n=$[$(wc -l <<< "$out") - 1]
        addfiles=(`echo $(tail "-$n" <<< "$out")`)
        [[ -z "$addfiles" ]] && continue
        if [ "$q" = ctrl-d ]; then
            git diff --color=always $addfiles | less -R
        else
            git add $addfiles
        fi
    done
}

function my_fzf_completion() {
    # 入力をスペースで区切って配列に
    local ary=(`echo $LBUFFER`)
    local query
    local prebuffer
    # 単語を入力途中ならそれをクエリにする
    if [[ "${LBUFFER: -1}" == " " ]]; then
        query=""
        # 最後のスペースは削除するので配列の方
        prebuffer=$ary
    else
        query=${ary[-1]}
        prebuffer=${ary[1,-2]}
    fi
    # fzfでファイルを選択
    # テキストファイル以外をプレビュー
    # ASCIIは変換して表示
    selected=$(find * -type f \
        | fzf --query "${query}" --preview \
        '[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file ||
        ( [[ $(file {}) =~ ASCII ]] &&
        ( head -n 100 {} | nkf -Sw ) || head -n 100 {} )')
    # ファイルを選択した場合のみバッファを更新
    if [[ -n "$selected" ]]; then
        # 改行をスペースに置換
        selected=$(tr '\n' ' ' <<< "$selected")
        BUFFER="${prebuffer} ${selected}"
    fi
    # カーソル位置を行末にして更新
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N my_fzf_completion
bindkey "^k" my_fzf_completion

# =では空白入れないこと!!!
# pathなどの設定--------------------------------------------------
export DISPLAY=localhost:0.0
export EDITOR=vim
export PATH=$PATH:/mnt/c/Windows/System32
export PATH=$PATH:$HOME/.fzf/bin:$HOME/.local/bin

# python
alias python=/usr/bin/python3.7
alias python3=/usr/bin/python3.7
export PYLINTRC=$HOME/dotfiles/vim/pylintrc

# golang
export GOPATH=$HOME/go
export GOPATH=/mnt/c/Users/admin/go:$GOPATH
export PATH=$PATH:$GOPATH:$GOPATH/bin:/usr/lib/go-1.12/bin:/mnt/c/Users/admin/go/bin

# 操作------------------------------------------------------------
# bindkey -v
bindkey -e
bindkey "^U" backward-kill-line
setopt IGNOREEOF # Ctrl+Dでログアウトしてしまうことを防ぐ
bindkey "^C" send-break
autoload -Uz smart-insert-last-word
# [a-zA-Z], /, \ のうち少なくとも1文字を含む長さ2以上の単語
zstyle :insert-last-word match '*([[:alpha:]/\\]?|?[[:alpha:]/\\])*'
zle -N insert-last-word smart-insert-last-word
bindkey '^]' insert-last-word
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
setopt no_beep

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
# 大文字・小文字を区別しない(大文字を入力した場合は区別する)
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' use-cache yes
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
alias gsh='git push'
alias gst='git status'
alias mytree='tree -a -I ".git"'
alias grep=jvgrep

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

# .zplugディレクトリが無ければgit clone
if [[ ! -d ~/.zplug ]];then
    git clone https://github.com/zplug/zplug ~/.zplug
fi

# zplugを使う
source ~/.zplug/init.zsh
zplug "zplug/zplug", hook-build:'zplug --self-manage'

# zplug "ユーザー名/リポジトリ名", タグ
# 補完------------------------------------------------------------
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

# fzf-------------------------------------------------------------
# zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
# Ctrl-Rで履歴検索、Ctrl-Tでファイル名検索補完できる
zplug "junegunn/fzf", use:shell/key-bindings.zsh
# cd **[TAB], vim **[TAB]などでファイル名を補完できる
zplug "junegunn/fzf", use:shell/completion.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="-m --height=60% --select-1 --exit-0 --reverse"
# export FZF_CTRL_T_OPTS="--preview 'test [(file {} | grep ASCII)=ASCII];and head -n 100 {}|nkf -Sw ;or head -n 100 {}'"
export FZF_CTRL_T_OPTS="--preview 'head -n 100 {}'"
export FZF_ALT_C_OPTS="--preview 'tree -al {} | head -n 100'"
export FZF_COMPLETION_TRIGGER='**'
bindkey "^I" expand-or-complete

# cdコマンドをインタラクティブに
zplug "b4b4r07/enhancd", use:init.sh
zplug "rupa/z", use:z.sh
zplug "arks22/tmuximum", as:command
alias t="tmuximum"

# プラグインによる関数--------------------------------------------
# z ×fzf
zz() {
    local res=$(z | sort -rn | cut -c 12- | fzf)
    if [ -n "$res" ]; then
        cd $res
    else
        return 1
    fi
}

# fbr - checkout git branch
fbr() {
    local branches branch
    branches=$(git branch -vv) &&
        branch=$(echo "$branches" | fzf +m) &&
        git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
    }

# gadd
gadd() {
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

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load --verbose

[[ -z "$TMUX" && ! -z "$PS1" ]] && tmuximum

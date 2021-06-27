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

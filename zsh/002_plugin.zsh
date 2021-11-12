export ZSH=$HOME/.oh-my-zsh

ZSH_THEME=""
plugins=(
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
    zsh-history-substring-search
    fzf
)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
source $HOME/rupaz/z.sh

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
if type bat > /dev/null; then
  preview+='bat --color=always --style=header,grid --line-range :100 {}'
else
  preview+='head -n 100 {}'
fi
export FZF_CTRL_T_OPTS="--preview \"$preview\""
export FZF_COMPLETION_OPTS="--preview \"$preview\""
export FZF_COMPLETION_TRIGGER='**'

export FZF_BASE=$HOME/.fzf
# 重複させないため，zshrcに直接書いている
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $ZSH/oh-my-zsh.sh

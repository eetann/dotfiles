export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
    zsh-history-substring-search
    fzf
)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
source $HOME/rupaz/z.sh
source $ZSH/oh-my-zsh.sh

FZF_DEFAULT_OPTS="--multi --height=60% --select-1 --exit-0 --reverse"
FZF_DEFAULT_OPTS+=" --bind ctrl-f:preview-page-down,ctrl-b:preview-page-up"
export FZF_DEFAULT_OPTS
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
local nosearch=('\$RECYCLE.BIN')
nosearch+=('.git')
nosearch+=('RECYCLER')
nosearch+=('.metadata')
nosearch+=('node_modules')
local find_dir="find ./ -type d \("
for d in $nosearch; do
    find_dir="$find_dir -name '$d' -o"
done
find_dir=${find_dir:0:-3}
FZF_FIND_FILE="$find_dir \) -prune -o -type f -print"
find_dir="$find_dir \) -prune -o -type d -print"
export FZF_ALT_C_COMMAND="$find_dir"
export FZF_CTRL_T_COMMAND="$FZF_FIND_FILE"
FZF_PREVIEW='[[ -d {} ]] && tree -aC -L 1 {}
[[ -f {} ]] && [[ $(file --mime {}) =~ binary ]] && echo {} is a binary file
((type bat > /dev/null) && bat --color=always --style=header,grid --line-range :100 {} ||
cat {}) 2> /dev/null | head -100'
export FZF_CTRL_T_OPTS="--preview \"$FZF_PREVIEW\""
export FZF_ALT_C_OPTS="--preview \"$FZF_PREVIEW\""
export FZF_COMPLETION_OPTS="--preview \"$FZF_PREVIEW\""
export FZF_COMPLETION_TRIGGER='**'
export FZF_TMUX=1
export FZF_TMUX_OPTS="-p 80%"
export FZF_BASE=$HOME/.fzf

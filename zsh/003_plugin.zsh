export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  colored-man-pages
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
FZF_DEFAULT_OPTS+=" --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up"
export FZF_DEFAULT_OPTS

# NOTE: 現時点では改行が正確ではない
export FZF_CTRL_R_OPTS=$(cat <<"EOF"
--preview '
  echo {} \
  | awk "{ sub(/\s*[0-9]*?\s*/, \"\"); gsub(/\\\\n/, \"\\n\"); print }" \
  | bat --color=always --language=sh --style=plain
' 
--preview-window 'down,wrap'
EOF
)

local find_ignore="find ./ -type d \( -name '.git' -o -name 'node_modules' \) -prune -o -type"
export FZF_CTRL_T_COMMAND=$(cat <<EOF
( (type fd > /dev/null) &&
  fd --type f \
    --strip-cwd-prefix \
    --hidden \
    --exclude '{.git,node_modules}/**' ) \
  || $find_ignore f -print 2> /dev/null
EOF
)
export FZF_ALT_C_COMMAND=$(cat <<EOF
( (type fd > /dev/null) &&
  fd --type d \
    --strip-cwd-prefix \
    --hidden \
    --exclude '{.git,node_modules}/**' ) \
  || $find_ignore d -print 2> /dev/null
EOF
)

fzf_preview='( (type bat > /dev/null) && bat --color=always --theme="Nord" --line-range :200 {} || cat {}) 2> /dev/null | head -100'
preview_cmd=$(cat << EOF
( (type bat > /dev/null) &&
  bat --color=always \
    --theme="Nord" \
    --line-range :200 {} \
  || (cat {} | head -200) ) 2> /dev/null
EOF
)

export FZF_ALT_C_OPTS="--preview 'tree -aC -L 1 {}'"
export FZF_CTRL_T_OPTS="--preview \"$preview_cmd\" --preview-window 'down,wrap,+{2}+3/2,~3'"
export FZF_COMPLETION_TRIGGER='**'
export FZF_TMUX=1
export FZF_TMUX_OPTS="-p 80%"
export FZF_BASE=$HOME/.fzf

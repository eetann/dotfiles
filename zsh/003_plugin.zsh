export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  colored-man-pages
  zsh-autosuggestions
  zsh-completions
  fast-syntax-highlighting
  zsh-history-substring-search
  fzf
)
if command -v docker &>/dev/null; then
  plugins+=(
    docker
    docker-compose
  )
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
source $HOME/rupaz/z.sh
source $ZSH/oh-my-zsh.sh
source $ZSH/custom/plugins/zeno/zeno.zsh

export BAT_THEME="gruvbox-dark"

export FZF_DEFAULT_OPTS=$(cat <<"EOF"
--multi
--height=60%
--select-1
--exit-0
--reverse
--bind ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up
EOF
)

local find_ignore="find ./ -type d \( -name '.git' -o -name 'node_modules' \) -prune -o -type"

export FZF_CTRL_T_COMMAND=$(cat <<"EOF"
( (type fd > /dev/null) &&
  (
  fd --type f \
    --strip-cwd-prefix \
    --hidden \
    --exclude '{.git,node_modules,vendor,public/vendor}/**'

  fd --type f . .claude/ --hidden --no-ignore 2> /dev/null
  )
) || $find_ignore f -print 2> /dev/null
EOF
)
export FZF_CTRL_T_OPTS=$(cat << "EOF"
--preview '
  ( (type bat > /dev/null) &&
    bat --color=always \
      --theme=gruvbox-dark \
      --line-range :200 {} \
    || (cat {} | head -200) ) 2> /dev/null
'
--preview-window 'down,60%,wrap,+3/2,~3'
EOF
)

export FZF_ALT_C_COMMAND=$(cat <<"EOF"
( (type fd > /dev/null) &&
  fd --type d \
    --strip-cwd-prefix \
    --hidden \
    --exclude '{.git,node_modules}/**' ) \
  || $find_ignore d -print 2> /dev/null
EOF
)
export FZF_ALT_C_OPTS="--preview 'tree -aC -L 1 {} | head -200'"

export FZF_COMPLETION_TRIGGER='**'
export FZF_TMUX=1
export FZF_TMUX_OPTS="-p 80%"
export FZF_BASE=$HOME/.fzf

export ZENO_HOME=~/.config/zeno
export ZENO_GIT_CAT="bat --color=always"

# tmuxやwezterm(tmuxなし)の最初のプロンプトでzeno-auto-snippet発動時に
# カーソルより左(p10kのプロンプトも含む)が消えるので、その応急処置
# ※zenoのアップデートのタイミングではないのでzenoが原因ではなさそう
function my_zeno_fallback() {
  zle self-insert
  zle reset-prompt
}
zle -N my_zeno_fallback


if [[ -n $ZENO_LOADED ]]; then
  ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(zeno-auto-snippet-and-accept-line)
  bindkey " " zeno-auto-snippet

  export ZENO_AUTO_SNIPPET_FALLBACK=my_zeno_fallback

  # bindkey '^r' zeno-history-selection
  bindkey '^m' zeno-auto-snippet-and-accept-line

  bindkey '^i' zeno-completion

  bindkey '^x ' zeno-insert-space
  bindkey '^x^m' accept-line
  bindkey '^x^z' zeno-toggle-auto-snippet

  bindkey '^x^p' zeno-insert-snippet
fi

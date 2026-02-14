# fzf 環境変数・遅延ロード設定

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
  fd --type f . .mywork/ --hidden --no-ignore 2> /dev/null
  ) | sort -u
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

export FZF_COMPLETION_TRIGGER='**'
export FZF_TMUX=1
export FZF_TMUX_OPTS="-p 80%"

# ^Rはmyfunction/history.zshでzeno経由の履歴検索を使うため、fzf側では無効化
# Alt-Cも zsh/myfunction/completion_dir.zshで足りるので無効化
export FZF_CTRL_R_COMMAND=''
export FZF_ALT_C_COMMAND=''

# fzf遅延ロード
function _fzf_lazy_load() {
  [[ -n $_FZF_LAZY_LOADED ]] && return
  _FZF_LAZY_LOADED=1

  source "$HOME/.zsh/plugins/fzf/key-bindings.zsh"
  source "$HOME/.zsh/plugins/fzf/completion.zsh"

  # fzf completionは読み込み時の^Iバインド（stub widget）をフォールバック先として保存する
  # stub → zeno-completion → fzf-completion → stub... の無限ループを防ぐため
  # フォールバックをデフォルト補完に上書きする
  fzf_default_completion='expand-or-complete'
}

# stub widgets: 初回呼び出しでfzfをロードし、本来のwidgetを実行する
function _fzf_stub_file() {
  _fzf_lazy_load
  zle fzf-file-widget
}
zle -N _fzf_stub_file

# stub widgetsにキーをバインド（fzfロード後は本来のwidgetに差し替わる）
bindkey "^T" _fzf_stub_file

# 環境変数
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

export ZENO_HOME=~/.config/zeno
export ZENO_GIT_CAT="bat --color=always"
export ZENO_DISABLE_EXECUTE_CACHE_COMMAND=1

# プラグインファイル一覧（読み込み順序）
typeset -a PLUGIN_FILES=(
  "$HOME/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme"
  "$HOME/.zsh/plugins/fzf/key-bindings.zsh"
  "$HOME/.zsh/plugins/fzf/completion.zsh"
  "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
  "$HOME/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
  "$HOME/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
)

# プラグインキャッシュ統合ロジック
# キャッシュキー: ZSH_VERSION + プラグイン一覧ハッシュ
_plugin_hash=$(cksum <<< "${(j:\n:)PLUGIN_FILES}")
_cache_key="${ZSH_VERSION}-${_plugin_hash}"
_cache_file="${ZSH_CACHE_DIR}/plugins-cache.${_cache_key}.zsh"

# 鮮度チェック: キャッシュ不在 or プラグインファイルがキャッシュより新しい場合に再生成
_need_regen=0
if [[ ! -f "$_cache_file" ]]; then
  _need_regen=1
else
  for _f in "${PLUGIN_FILES[@]}"; do
    if [[ "$_f" -nt "$_cache_file" ]]; then
      _need_regen=1
      break
    fi
  done
fi

if (( _need_regen )); then
  {
    for _f in "${PLUGIN_FILES[@]}"; do
      echo "source \"$_f\""
    done
  } > "$_cache_file"
  zcompile "$_cache_file"
fi

source "$_cache_file"
unset _plugin_hash _cache_key _cache_file _need_regen _f

# プラグインキャッシュ外で読み込む
source $HOME/rupaz/z.sh

# autosuggestions設定
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

# zeno関連の設定
# tmuxやwezterm(tmuxなし)の最初のプロンプトでzeno-auto-snippet発動時に
# カーソルより左(p10kのプロンプトも含む)が消えるので、その応急処置
# ※zenoのアップデートのタイミングではないのでzenoが原因ではなさそう
function my_zeno_fallback() {
  zle self-insert
  zle reset-prompt
}
zle -N my_zeno_fallback

# zeno遅延ロード
# プラグインキャッシュから外し、最初のキー入力時にsourceする
function _zeno_lazy_load() {
  [[ -n $_ZENO_LAZY_LOADED ]] && return
  _ZENO_LAZY_LOADED=1

  # ZLE widget内からsourceすると$0がwidget名になりZENO_ROOTが不正になるため明示的に設定
  export ZENO_ROOT="$HOME/.zsh/plugins/zeno"
  source "$HOME/.zsh/plugins/zeno/zeno.zsh"

  if [[ -n $ZENO_LOADED ]]; then
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(zeno-auto-snippet-and-accept-line)
    export ZENO_AUTO_SNIPPET_FALLBACK=my_zeno_fallback

    bindkey " " zeno-auto-snippet
    bindkey '^m' zeno-auto-snippet-and-accept-line
    bindkey '^i' zeno-completion
    bindkey '^x ' zeno-insert-space
    bindkey '^x^m' accept-line
    bindkey '^x^z' zeno-toggle-auto-snippet
    bindkey '^x^p' zeno-insert-snippet
  fi
}

# stub widgets: 初回呼び出しでzenoをロードし、本来のwidgetを実行する
function _zeno_stub_space() {
  _zeno_lazy_load
  if [[ -n $ZENO_LOADED ]]; then
    zle zeno-auto-snippet
  else
    zle self-insert
  fi
}
zle -N _zeno_stub_space

function _zeno_stub_accept_line() {
  _zeno_lazy_load
  if [[ -n $ZENO_LOADED ]]; then
    zle zeno-auto-snippet-and-accept-line
  else
    zle accept-line
  fi
}
zle -N _zeno_stub_accept_line

function _zeno_stub_completion() {
  _zeno_lazy_load
  if [[ -n $ZENO_LOADED ]]; then
    zle zeno-completion
  else
    zle expand-or-complete
  fi
}
zle -N _zeno_stub_completion

function _zeno_stub_insert_snippet() {
  _zeno_lazy_load
  if [[ -n $ZENO_LOADED ]]; then
    zle zeno-insert-snippet
  fi
}
zle -N _zeno_stub_insert_snippet

# stub widgetsにキーをバインド（zenoロード後は本来のwidgetに差し替わる）
bindkey " " _zeno_stub_space
bindkey "^m" _zeno_stub_accept_line
bindkey "^i" _zeno_stub_completion
bindkey "^x^p" _zeno_stub_insert_snippet

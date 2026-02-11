function fzf_npm_scripts() {
  _zeno_lazy_load
  [[ -z $ZENO_LOADED ]] && return

  if [[ ! -f package.json ]]; then
    echo 'fzf_npm_scripts'
    echo 'There is no package.json'
    zle send-break
    return 1
  fi
  if ! type jq > /dev/null; then
    echo 'fzf_npm_scripts'
    echo 'jq command is required'
    zle send-break
    return 1
  fi

  local prefix="npm"
  local git_root=$(git rev-parse --show-superproject-working-tree --show-toplevel 2>/dev/null | head -1)
  if [[ -f pnpm-lock.yaml || ( -n "$git_root" && -f "$git_root/pnpm-lock.yaml" ) ]]; then
    prefix="pnpm"
    elif [[ -f bun.lock || ( -n "$git_root" && -f "$git_root/bun.lock" ) ]]; then
    prefix="bun"
  fi
  BUFFER="$prefix run "
  zle end-of-line
  zle zeno-completion # from zeno
  if [[ "$BUFFER" != "$prefix run " ]]; then
    zle accept-line
  fi
}
zle -N fzf_npm_scripts
bindkey "^Xn" fzf_npm_scripts

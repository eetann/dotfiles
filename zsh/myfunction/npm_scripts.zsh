function fzf_npm_scripts() {
  local prefix="npm"
  local git_root=$(git rev-parse --show-superproject-working-tree --show-toplevel 2>/dev/null | head -1)
  if [[ -f pnpm-lock.yaml || ( -n "$git_root" && -f "$git_root/pnpm-lock.yaml" ) ]]; then
    prefix="pnpm"
    elif [[ -f bun.lock || ( -n "$git_root" && -f "$git_root/bun.lock" ) ]]; then
    prefix="bun"
  fi
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

  local scripts=`jq -r '.scripts | to_entries | .[] | .key + " = " + .value' package.json 2>/dev/null || echo ''`
  if [[ -z $scripts ]]; then
    echo 'fzf_npm_scripts'
    echo 'There is no scripts in package.json'
    zle send-break
    return 1
  fi
  local selected=`echo $scripts | FZF_DEFAULT_OPTS='' fzf --height=50% --reverse --exit-0 | awk -F ' = ' '{ print $1}'`

  zle reset-prompt
  if [[ -z $selected ]]; then
    return 0
  fi

  # 再実行したくなるときのために履歴に残して実行
  BUFFER="$prefix run $selected"
  zle accept-line
}
zle -N fzf_npm_scripts
bindkey "^Xn" fzf_npm_scripts

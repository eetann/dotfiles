function monorepo_cd() {
  local cwd packages_dir candidates selected

  cwd="$PWD"

  # 現在のディレクトリ名に'packages'が含まれているか判定
  if [[ "$cwd" == *"/packages"* ]]; then
    # 'packages' ディレクトリの直下を探す
    packages_dir="${cwd%%/packages*}/packages"
    if [[ -d "$packages_dir" ]]; then
      # candidates: packages直下のディレクトリ（ただし現在のディレクトリは除外）
      candidates=()
      for d in "${packages_dir}"/*(/); do
        [[ "$d" != "$cwd/" ]] && candidates+=("$d")
      done
      # packagesより上のディレクトリも候補に追加
      upper_dir="${packages_dir%/packages}"
      [[ "$upper_dir" != "$cwd" ]] && candidates+=("$upper_dir")
    else
      return
    fi
  elif [[ -d "$cwd/packages" ]]; then
    packages_dir="$cwd/packages"
    candidates=("${packages_dir}"/*(/))
  else
    return
  fi

  # ディレクトリがなければ終了
  if [[ ${#candidates[@]} -eq 0 ]]; then
    return
  fi

  # fzfで選択
  selected=$(printf '%s\n' "${candidates[@]}" | fzf)
  if [[ -n "$selected" ]]; then
    BUFFER="cd $selected"
    zle accept-line
  fi
}
zle -N monorepo_cd
bindkey '^xc' monorepo_cd

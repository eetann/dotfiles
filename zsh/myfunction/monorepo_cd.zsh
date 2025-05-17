function monorepo_cd() {
  local packages_dir candidates=()
  local cwd="$PWD"

  # 現在のディレクトリ名に'packages'が含まれているか判定
  if [[ "$cwd" == *"/packages"* ]]; then
    # 'packages' ディレクトリの直下を探す
    packages_dir="${cwd%%/packages*}/packages"
    if [[ ! -d "$packages_dir" ]]; then
      return
    fi
    if [[ -d "$packages_dir" ]]; then
      # candidates: packages直下のディレクトリ（ただし現在のディレクトリは除外）
      for d in "${packages_dir}"/*(/); do
        [[ "$d" != "$cwd/" ]] && candidates+=("$d")
      done
      # packagesより上のディレクトリも候補に追加
      local upper_dir="${packages_dir%/packages}"
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

  # fzfで表示名付きで選択
  local display_list=()
  for d in "${candidates[@]}"; do
    if [[ "$d" == "${packages_dir%/packages}" ]]; then
      display_list+=("<root> | $d")
    else
      display_list+=("$(basename "$d") | $d")
    fi
  done

  local selected=$(printf '%s\n' "${display_list[@]}" | fzf)
  if [[ -n "$selected" ]]; then
    local dest="${selected##*$' | '}"
    BUFFER="cd $dest"
    zle accept-line
  fi
}
zle -N monorepo_cd
bindkey '^xc' monorepo_cd

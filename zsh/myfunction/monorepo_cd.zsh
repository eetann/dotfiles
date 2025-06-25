function monorepo_cd() {
  local candidates=()
  local cwd="$PWD"
  local dir_type=""
  local target_dir=""

  # 現在のディレクトリがmonorepoのサブディレクトリか判定
  if [[ "$cwd" == *"/packages/"* ]] || [[ "$cwd" == *"/packages" ]]; then
    dir_type="packages"
    target_dir="${cwd%%/packages*}/packages"
  elif [[ "$cwd" == *"/apps/"* ]] || [[ "$cwd" == *"/apps" ]]; then
    dir_type="apps"
    target_dir="${cwd%%/apps*}/apps"
  elif [[ "$cwd" == *"/libs/"* ]] || [[ "$cwd" == *"/libs" ]]; then
    dir_type="libs"
    target_dir="${cwd%%/libs*}/libs"
  fi

  if [[ -n "$dir_type" && -d "$target_dir" ]]; then
    # 現在のディレクトリタイプの直下を探す
    for d in "${target_dir}"/*(/); do
      [[ "$d" != "$cwd/" ]] && candidates+=("$d")
    done
    
    local root_dir="${target_dir%/$dir_type}"
    # 他のmonorepoディレクトリも候補に追加
    for other_type in packages apps libs; do
      if [[ "$other_type" != "$dir_type" && -d "$root_dir/$other_type" ]]; then
        # 各ディレクトリの直下を追加
        for d in "$root_dir/$other_type"/*(/); do
          [[ "$d" != "$cwd/" ]] && candidates+=("$d")
        done
      fi
    done
    # ルートディレクトリを候補に追加
    [[ "$root_dir" != "$cwd" ]] && candidates+=("$root_dir")
    
  else
    # ルートディレクトリから探す
    local found=false
    for monorepo_type in packages apps libs; do
      if [[ -d "$cwd/$monorepo_type" ]]; then
        found=true
        candidates+=("$cwd/$monorepo_type"/*(/))
      fi
    done
    if [[ "$found" == false ]]; then
      return
    fi
  fi

  # ディレクトリがなければ終了
  if [[ ${#candidates[@]} -eq 0 ]]; then
    return
  fi

  # fzfで表示名付きで選択
  local display_list=()
  for d in "${candidates[@]}"; do
    local display_name=""
    local base_name="$(basename "$d")"
    
    # ルートディレクトリの判定
    if [[ "$d" == "${target_dir%/$dir_type}" ]] || [[ "$base_name" == "$(basename "$cwd")" && "$d" == "$cwd/.." ]]; then
      display_name="<root>"
    # monorepoディレクトリタイプの判定
    elif [[ "$base_name" == "packages" || "$base_name" == "apps" || "$base_name" == "libs" ]]; then
      display_name="[$base_name]"
    # サブディレクトリの判定
    elif [[ "$d" == *"/packages/"* ]]; then
      display_name="[package] $base_name"
    elif [[ "$d" == *"/apps/"* ]]; then
      display_name="[app] $base_name"
    elif [[ "$d" == *"/libs/"* ]]; then
      display_name="[lib] $base_name"
    else
      display_name="$base_name"
    fi
    
    display_list+=("$display_name | $d")
  done

  local selected=$(printf '%s\n' "${display_list[@]}" | fzf)
  if [[ -n "$selected" ]]; then
    local dest="${selected##*$' | '}"
    BUFFER="cd $dest"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N monorepo_cd
bindkey '^xc' monorepo_cd

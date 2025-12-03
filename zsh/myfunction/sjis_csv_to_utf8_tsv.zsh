function sjis_csv_to_utf8_tsv() {
  local csv=$(find ~/Downloads -maxdepth 1 -name "*.csv" | fzf --prompt="CSV> ")
  [[ -z "$csv" ]] && return

  local original_filename=$(basename "$csv")

  # 日付部分を抽出 (_YYYYMMDD_YYYYMMDD)
  local date_part=$(echo "$original_filename" | grep -oE '_[0-9]{8}_[0-9]{8}')
  [[ -z "$date_part" ]] && { echo "日付パターンが見つからない"; return 1; }

  # prefixを選択（自由入力も可）
  local prefix=$(printf '%s\n' "ipad_operation" "ipad_status" "ipad_error" \
    | fzf --prompt="Prefix> " --print-query | tail -1)
  [[ -z "$prefix" ]] && return

  local filename="${prefix}${date_part}.csv"
  mv "$csv" ./"$filename"
  nkf -w --overwrite "$filename"
  bun run ~/dotfiles/bin/csv_to_tsv.ts --file "$filename"
  gomi "$filename"
}

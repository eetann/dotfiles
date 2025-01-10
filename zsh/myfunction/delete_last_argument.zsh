function delete_last_argument() {
  # シェルのパースに基づいて配列化
  # https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion-Flags:~:text=into%20words%20using%20shell%20parsing%20to%20find%20the%20words
  local args=("${(z)BUFFER}")

  if (( 2 <= ${#args} )); then
    # 配列の取り出し
    # https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion:~:text=%24%7Bname%3Aoffset%3Alength%7D
    args=("${args:0:$#args-1}")
    # 配列を半角スペースで結合
    # https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion:~:text=the%20parenthesised%20group.-,j%3Astring%3A,-Join%20the%20words
    BUFFER="${(j: :)args} "
  fi
}

zle -N delete_last_argument
bindkey "^Xw" delete_last_argument

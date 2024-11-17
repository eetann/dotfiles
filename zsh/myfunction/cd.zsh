function replace_multiple_dots() {
  local dots=$LBUFFER[-2,-1]
  if [[ $dots == ".." ]]; then
    LBUFFER=$LBUFFER[1,-3]'../.'
  fi
  zle self-insert
}

zle -N replace_multiple_dots
bindkey "." replace_multiple_dots
# ref: https://qiita.com/momo-lab/items/523fc83fbfa39fa5fd60

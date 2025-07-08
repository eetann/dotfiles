# Gスペース のように入力したら、勝手に | grep に置き換えてくれる
setopt extended_glob
typeset -A abbreviations
abbreviations=(
  "G"    "| grep"
  "T"    "| tail"
  "C"    "| cat"
  "W"    "| wc"
  "A"    "| awk"
  "S"    "| sed"
  "E"    "/mnt/c/windows/explorer.exe ."
  "N"    "> /dev/null"
  "DC"   "docker-compose"
  "CD"   "&& cd \$_"
  "CL"   "| clip.exe"
  "X"    "| xsel -ib"
  "PA"   "php artisan"
  "V"    "vagrant"
  "TN"   "tmux popup -E -w 95% -h 95% -d '#{pane_current_path}' 'nvim -c \"\"'"
  "TREE" "tree -a -I '.git|node_modules|dist' --charset unicode"
  "BLOG" "node bin/new.mjs --slug"
)

function magic_abbrev_expand() {
  local MATCH
  LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
  LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
  zle self-insert
}

function no_magic-abbrev-expand() {
  LBUFFER+=' '
}

# zle -N magic_abbrev_expand
# zle -N no_magic_abbrev_expand
# bindkey " " magic_abbrev_expand
# bindkey "^x " no_magic_abbrev_expand

# 展開------------------------------------------------------------
# Gスペース のように入力したら、勝手に | grep に置き換えてくれる
setopt extended_glob
typeset -A abbreviations
abbreviations=(
  "G"    "| grep"
  "X"    "| xargs"
  "T"    "| tail"
  "C"    "| cat"
  "W"    "| wc"
  "A"    "| awk"
  "S"    "| sed"
  "E"    "2>&1 > /dev/null"
  "N"    "> /dev/null"
  "DC"   "docker-compose"
  "CD"   "&& cd \$_"
  "CL"   "| clip.exe"
  "TREE" "tree -a -I '.git|node_modules|dist' --charset unicode"
)

function magic-abbrev-expand() {
  local MATCH
  LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
  LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
  zle self-insert
}

function no-magic-abbrev-expand() {
  LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand

# プラグインによる関数--------------------------------------------
# z ×fzf
function fz() {
  local fzf_command="fzf"
  if type fzf-tmux > /dev/null; then
    fzf_command="fzf-tmux -p 80%"
  fi
  fzf_command+=" "
  fzf_command+=$(cat << "EOF"
--preview '
  tree -aC -L 1 {} | head -200
' \
--preview-window 'right,wrap,~1'
EOF
)
  # zの出力の先頭12文字の頻度情報を使ってソートし、fzfに渡すときは削る
  local res=$(z | sort -rn | cut -c 12- | eval $fzf_command)
  if [ -n "$res" ]; then
    BUFFER+="cd $res"
    zle accept-line
  else
    return 1
  fi
}
zle -N fz
bindkey '^xz' fz

function fghq() {
  local fzf_command="fzf"
  if type fzf-tmux > /dev/null; then
    fzf_command="fzf-tmux -p 80%"
  fi
  fzf_command+=" "
  fzf_command+=$(cat << "EOF"
--preview '
  ( (type bat > /dev/null) &&
    bat --color=always \
      --theme="gruvbox-dark" \
      --line-range :200 $(ghq root)/{}/README.* \
    || (cat {} | head -200) ) 2> /dev/null
' \
--preview-window 'down,60%,wrap,+3/2,~3'
EOF
)

  local res=$(ghq list | eval $fzf_command)
  if [ -n "$res" ]; then
    BUFFER+="cd $(ghq root)/$res"
    zle accept-line
  else
    return 1
  fi
}
zle -N fghq
bindkey '^xg' fghq

function ghq-new() {
  local root=`ghq root`
  local user=`git config --get github.user`
  if [ -z "$user" ]; then
    echo "you need to set github.user."
    echo "git config --global github.user YOUR_GITHUB_USER_NAME"
    return 1
  fi
  local name=$1
  local repo="$root/github.com/$user/$name"
  if [ -e "$repo" ]; then
    echo "$repo is already exists."
    return 1
  fi
  git init $repo
  cd $repo
}

function my_fzf_completion() {
  # 入力をスペースで区切って配列に
  local ary=(`echo $LBUFFER`)
  local query
  local prebuffer
  # 単語を入力途中ならそれをクエリにする
  if [[ "${LBUFFER: -1}" == " " ]]; then
    query=""
    prebuffer=$ary
  else
    query=${ary[-1]}
    prebuffer=${ary[1,-2]}
  fi

  local fzf_command="fzf"
  if type fzf-tmux > /dev/null; then
    fzf_command="fzf-tmux -p 80%"
  fi
  fzf_command+=" "
  fzf_command+=$(cat << EOF
--query '$query' \
--preview '
  ( (type bat > /dev/null) &&
    bat --color=always \
      --theme="gruvbox-dark" \
      --line-range :200 {} \
    || (cat {} | head -200) ) 2> /dev/null
' \
--preview-window 'down,60%,wrap,+3/2,~3'
EOF
)

  selected=$(eval $FZF_CTRL_T_COMMAND | eval $fzf_command)
  # ファイルを選択した場合のみバッファを更新
  if [[ -n "$selected" ]]; then
    # 改行をスペースに置換
    selected=$(tr '\n' ' ' <<< "$selected")
    BUFFER="${prebuffer} ${selected}"
  fi
  # カーソル位置を行末にして更新
  CURSOR=$#BUFFER
  zle reset-prompt
}

zle -N my_fzf_completion
bindkey "^k" my_fzf_completion

function fzf_npm_scripts() {
  if [ ! -e package.json ]; then
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
  BUFFER="npm run $selected"
  zle accept-line
}
zle -N fzf_npm_scripts
bindkey "^Xn" fzf_npm_scripts

function fman() {
  # Mac以外: hoge (1) → 1 hoge
  # MAC:     hoge(1) → 1 hoge
  local selected=$(man -k . \
    | fzf-tmux -p 80% \
      -q "$1" \
      --prompt='man> ' \
      --preview-window 'down,70%,~1' \
      --preview "$(cat << "EOF"
echo {} \
| awk ' \
  { $0 = gensub(/\s?\(([1-9])\)/, " \\1", 1) }
  { printf "%s ", $2 }
  { print $1 }
' \
| xargs -r man \
| col -bx \
| bat --language=man --plain --theme="Monokai Extended Bright" --color always
EOF
)" \
    | tr -d '()' \
    | awk '{printf "%s ", $2} {print $1}')

  zle reset-prompt
  if [[ -z $selected ]]; then
    return 0
  fi


  # 再実行したくなるときのために履歴に残して実行
  BUFFER="man $selected"
  zle accept-line

}
zle -N fman
bindkey '^xf' fman

export MANPAGER="sh -c 'col -bx | bat --language=man --plain --theme=\"Monokai Extended Bright\" --paging always'"

function frg() {
  local initial_query=""
  local rg_prefix=$(cat << "EOF"
rg --line-number \
  --no-heading \
  --hidden \
  -g '!{.git,node_modules}' \
  --smart-case \
  --color=always
EOF
)
  local result=$(
    FZF_DEFAULT_COMMAND="$rg_prefix '$initial_query'" \
      fzf-tmux -p 80% --bind "change:reload:$rg_prefix {q} || true" \
          --ansi --disabled --query "$initial_query" \
          --delimiter : \
          --preview '
            ( (type bat > /dev/null) &&
              bat --color=always \
                --theme="gruvbox-dark" \
                --line-range :200 {1} \
                --highlight-line {2} \
              || (cat {} | head -200) ) 2> /dev/null
          ' \
          --preview-window 'down,60%,wrap,+{2}+3/2,~3' \
          --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up,ctrl-q:select-all+accept \
          --print-query
  )
  echo $result | awk 'NR!=1'
  echo '------------------------'
  local final_query=$(echo $result | awk 'NR==1')
  echo "$rg_prefix '$final_query'" | bat --color=always --language=sh --style=plain 
}

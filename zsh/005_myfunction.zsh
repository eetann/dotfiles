# 展開------------------------------------------------------------
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
  "TREE" "tree -a -I '.git|node_modules|dist' --charset unicode"
  "BLOG" "node bin/new.mjs --slug"
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

# https://github.com/junegunn/fzf/wiki/Examples#docker
# Select a docker container to start and attach to
function docker_start_attach() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
}

# Select a running docker container to stop
function docker_stop() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker stop "$cid"
}

# # Select a docker container to remove
function docker_rm() {
  docker ps -a | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $1 }' | xargs -r docker rm
}

# Select a docker image or images to remove
function docker_rmi() {
  docker images | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $3 }' | xargs -r docker rmi
}

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
      --theme=gruvbox-dark \
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
      --theme=gruvbox-dark \
      --line-range :200 {} \
    || (cat {} | head -200) ) 2> /dev/null
' \
--preview-window 'down,60%,wrap,+3/2,~3'
EOF
)

  selected=$(eval $FZF_CTRL_T_COMMAND | eval $fzf_command)
  # ファイルを選択した場合のみバッファを更新
  if [[ -n "$selected" ]]; then
    # 改行で区切った配列へ 変数展開フラグfを使う
    select_arr=(${(f)selected})
    escaped=""
    for val in $select_arr; do
      escaped+=" "
      escaped+=$(printf "%q" "$val")
    done
    BUFFER="${prebuffer}${escaped}"
  fi
  # カーソル位置を行末にして更新
  CURSOR=$#BUFFER
  zle reset-prompt
}

zle -N my_fzf_completion
bindkey "^k" my_fzf_completion

function fzf_npm_scripts() {
  local prefix="npm"
  if [ -e pnpm-lock.yaml ]; then
    prefix="pnpm"
  fi
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
  BUFFER="$prefix run $selected"
  zle accept-line
}
zle -N fzf_npm_scripts
bindkey "^Xn" fzf_npm_scripts

function fzf_mise_tasks() {
  # mise settings set experimental true
  if [ ! -e .mise.toml ]; then
    echo 'fzf_mise_tasks'
    echo 'There is no .mise.toml'
    zle send-break
    return 1
  fi
  if ! type yq > /dev/null; then
    echo 'fzf_mise_tasks'
    echo 'yq command is required'
    zle send-break
    return 1
  fi

  local tasks="yq -oj '.tasks | to_entries | .[] | .key + \" = \" + .value.run' .mise.toml 2>/dev/null || echo ''"
  if [[ -z $tasks ]]; then
    echo 'fzf_mise_tasks'
    echo 'There is no tasks in .mise.toml'
    zle send-break
    return 1
  fi
  local selected=`eval $tasks | sed 's/^"//;s/"$//' | FZF_DEFAULT_OPTS='' fzf --height=50% --reverse --exit-0 | awk -F ' = ' '{ print $1}'`

  zle reset-prompt
  if [[ -z $selected ]]; then
    return 0
  fi

  # 再実行したくなるときのために履歴に残して実行
  BUFFER="mise run $selected"
  zle accept-line
}
zle -N fzf_mise_tasks
bindkey "^Xm" fzf_mise_tasks

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
| bat --language=man --plain --color always --theme=gruvbox-dark
EOF
)" \
    | awk ' \
      { $0 = gensub(/\s?\(([1-9])\)/, " \\1", 1) }
      { printf "%s ", $2 }
      { print $1 }
    ')

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

export MANPAGER='nvim +Man!'

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
                --theme=gruvbox-dark \
                --line-range :200 {1} \
                --highlight-line {2} \
              || (cat {} | head -200) ) 2> /dev/null
          ' \
          --preview-window 'down,60%,wrap,+{2}+3/2,~3' \
          --print-query
  )
  echo $result | awk 'NR!=1'
  echo '------------------------'
  local final_query=$(echo $result | awk 'NR==1')
  echo "$rg_prefix '$final_query'" | bat --color=always --language=sh --style=plain --theme=gruvbox-dark
}

if [[ "$(uname -r)" == *microsoft* ]]; then
  function open() {
    if [ $# != 1 ]; then
      /mnt/c/windows/explorer.exe .
    else
      if [ -e $1 ]; then
        /mnt/c/windows/explorer.exe $(wslpath -w $1)
      else
        echo "open: $1 : No such file or directory"
      fi
    fi
  }
fi

function ftmux_resurrect() {
  local pre_dir=$(pwd);
  if [ -e "$HOME/.tmux/resurrect" ]; then
    cd ~/.tmux/resurrect
  elif [ -e "$HOME/.local/share/tmux/resurrect" ]; then
    cd ~/.local/share/tmux/resurrect
  else
    echo "resurrect directory not found"
    zle accept-line
    return 1
  fi
  local can_bat='type bat > /dev/null'
  local bat_command='bat \
    --color=always \
    --theme=gruvbox-dark {}'
  local alt_command='cat {} | head -200'
  local fzf_command="fzf-tmux -p 80% \
    --preview '( ($can_bat) && $bat_command || ($alt_command) ) 2> /dev/null' \
    --preview-window 'down,60%,wrap,+3/2,~3'"
  local result=$(
    find . -name 'tmux_resurrect_[0-9]*.txt' \
    | sort -r \
    | eval $fzf_command
  )
  if [ -n "$result" ]; then
    ln -sf $result last
    echo "link!"
  else
    echo "No link..."
  fi
  cd $pre_dir
  zle accept-line
}
zle -N ftmux_resurrect
bindkey '^xt' ftmux_resurrect

function fdir() {
  local fzf_command="fzf"
  if type fzf-tmux > /dev/null; then
    fzf_command="fzf-tmux -p 80%"
  fi

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

  fzf_command+=" "
  fzf_command+=$(cat << EOF
--query '$query' \
--preview '
  ( (type bat > /dev/null) &&
    bat --color=always \
      --theme=gruvbox-dark \
      --line-range :200 \$(ghq root)/{}/README.* \
    || (cat {} | head -200) ) 2> /dev/null
' \
--preview-window 'down,60%,wrap,+3/2,~3'
EOF
)

  local find_directory=$(cat <<"EOF"
( (type fd > /dev/null) &&
  fd --type d \
    --strip-cwd-prefix \
    --hidden \
    --exclude '{.git,node_modules}/**' ) \
  || $find_ignore d -print 2> /dev/null
EOF
)
  local res=$(eval $find_directory | eval $fzf_command)
  if [ -n "$res" ]; then
    BUFFER="${prebuffer} ${res}"
  else
    return 1
  fi
  # カーソル位置を行末にして更新
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N fdir
bindkey '^xd' fdir


function rg_fzf_nvim() {
  local query=$LBUFFER
  if [ -z $query ]; then
    echo "検索文字がありません。入力してから実行してください"
    zle send-break
    return 1
  fi
  BUFFER=""
  zle -I
  echo "rg_fzf_nvim $query"
  local fzf_command="fzf"
  if type fzf-tmux > /dev/null; then
    fzf_command="fzf-tmux -p 80%"
  fi
  fzf_command+=" "
  fzf_command+=$(cat << EOF
--ansi \
--delimiter : \
--preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
--preview-window 'down,60%,wrap,+{2}/2'
EOF
)

  # 入力途中の文字列をrgにわたす
  selected=$(rg --column --line-number --no-heading --color=always --smart-case -- $query | eval $fzf_command)
  # ファイルを選択した場合のみバッファを更新
  if [[ -n "$selected" ]]; then
    # 改行で区切った配列へ 変数展開フラグfを使う
    select_arr=(${(f)selected})
    escaped=""
    for val in $select_arr; do
      escaped+=" "
      escaped+=$(printf "%q" "$val" | cut -d':' -f1)
    done
    BUFFER="nvim${escaped}"
  fi
  # カーソル位置を行末にして更新
  CURSOR=$#BUFFER
  # zle reset-prompt
}

zle -N rg_fzf_nvim
bindkey '^xK' rg_fzf_nvim

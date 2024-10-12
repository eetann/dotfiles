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

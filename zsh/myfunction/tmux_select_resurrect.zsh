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

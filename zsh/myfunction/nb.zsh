function fzf_nb_edit() {
  if ! type nb > /dev/null; then
    echo 'fzf_nb_edit'
    echo 'nb command is required'
    zle send-break
    return 1
  fi
  # pinを優先表示したいのでnb ls
  local selected=`nb ls -a --no-id --filenames \
    | fzf-tmux -p 80% \
      --ansi \
      --preview 'bat --color=always --language=md --style=plain {-1}'`
  # 今後のパフォーマンスによっては
  #   普通にmarkdown取ってきて、最後に nb edit ファイルパス の方がいいかも
  # selected=$(eval $FZF_CTRL_T_COMMAND | eval $fzf_command)

  if [[ -z $selected ]]; then
    return 0
  fi

  zle reset-prompt
  # https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion:~:text=array%20element%20separately.-,%24%7Bname%23pattern%7D,-%24%7Bname%23%23
  # 再実行したくなるときのために履歴に残して実行
  BUFFER="nb edit ${selected#$'\U1F4CC '}"
  zle accept-line
}

zle -N fzf_nb_edit
bindkey "^Xe" fzf_nb_edit

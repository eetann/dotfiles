_prompt_executing=""

function after_command() {
  local ret="$?"
  if [[ "$_prompt_executing" -ne 0 ]]; then
    _PROMPT_SAVE_PS1="$PS1"
    _PROMPT_SAVE_PS2="$PS2"
    PS1=$'%{\e]133;P;k=i\a%}'$PS1$'%{\e]133;B\a\e]122;> \a%}'
    PS2=$'%{\e]133;P;k=s\a%}'$PS2$'%{\e]133;B\a%}'
  fi
  if [[ -n "$_prompt_executing" ]]; then
    printf "\033]133;D;%s;aid=%s\007" "$ret" "$$"
  fi
  printf "\033]133;A;cl=m;aid=%s\007" "$$"
  _prompt_executing=0
}

function before_command() {
  PS1="$_PROMPT_SAVE_PS1"
  PS2="$_PROMPT_SAVE_PS2"
  printf "\033]133;C;\007"
  _prompt_executing=1
}
autoload -U add-zsh-hook
add-zsh-hook preexec before_command
add-zsh-hook precmd after_command

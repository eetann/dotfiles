set PATH $HOME/.local/bin $PATH
export DISPLAY=localhost:0.0
set -x GOPATH $HOME/go
set -x PATH $GOPATH/bin $PATH

set -g theme_newline_cursor yes
set -g theme_display_git_master_branch yes
set -g theme_color_scheme gruvbox
set -g theme_powerline_fonts no
set -g theme_display_date no
set -g theme_display_cmd_duration no
set -g fish_prompt_pwd_dir_length 0

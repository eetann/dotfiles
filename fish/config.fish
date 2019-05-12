set PATH $HOME/.local/bin $PATH
set -x DISPLAY localhost:0.0
set -x GOPATH $HOME/go $GOPATH
set -x GOPATH /mnt/c/Users/admin/go $GOPATH
set -x PATH $GOPATH/bin $PATH
set -x PATH /mnt/c/Users/admin/go/bin/ $PATH
set -x PATH /mnt/c/Windows/System32 $PATH
#set -x FZF_DEFAULT_COMMAND 'jvgrep'
set -x FZF_LEGACY_KEYBINDINGS 0
set -x FZF_DEFAULT_OPTS "--height=60% --select-1 --exit-0 --reverse --no-unicode"
set -x FZF_FIND_FILE_OPTS "--preview 'head -n 100 {}'"
# a:ドットディレクトリもたどる
# l:シンボリックリンクをたどる
# C:色付きで表示
set -x FZF_CD_OPTS  "--preview 'tree -alC {} | head -n 100'"
#set -x FZF_PREVIEW_FILE_CMD "head -50 {}"
#set -x FZF_PREVIEW_DIR_CMD "tree -C {} | head -200"

set -x EDITOR vim

set -g theme_newline_cursor yes
set -g theme_display_git_master_branch yes
set -g theme_color_scheme gruvbox
# set -g theme_powerline_fonts no
set -g theme_display_date no
set -g theme_display_cmd_duration no
set -g fish_prompt_pwd_dir_length 0

set -x LSCOLORS  exfxcxdxbxegedabagacad

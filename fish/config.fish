set PATH $HOME/.local/bin $PATH
set -x DISPLAY localhost:0.0

# for python
alias python='/usr/bin/python3.7'
alias python3='/usr/bin/python3.7'
set PYLINTRC /mnt/c/Users/admin/dotfiles/vim/pylintrc $PYLINTRC

# for go
set GOPATH $HOME/go $GOPATH
set GOPATH /mnt/c/Users/admin/go $GOPATH
set PATH $GOPATH/bin $PATH
set PATH /usr/lib/go-1.12/bin $PATH
set PATH /mnt/c/Users/admin/go/bin $PATH
set PATH /mnt/c/Windows/System32 $PATH
# set -x PATH (echo $PATH | tr ' ' '\n' | sort -u)
#set FZF_DEFAULT_COMMAND 'jvgrep'
set PATH /home/eetann/.fzf/bin $PATH
set FZF_LEGACY_KEYBINDINGS 1
set FZF_DEFAULT_OPTS "-m --height=60% --select-1 --exit-0 --reverse --no-unicode"
# set FZF_FIND_FILE_OPTS "--preview 'head -n 100 {}'"
set FZF_FIND_FILE_OPTS "--preview 'test [(file {} | grep ASCII)=ASCII];and head -n 100 {}|nkf -Sw ;or head -n 100 {}'"
# a:ドットディレクトリもたどる
# l:シンボリックリンクをたどる
# C:色付きで表示
set FZF_CD_OPTS  "--preview 'tree -alC {} | head -n 100'"

set EDITOR vim

set -g theme_newline_cursor yes
set -g theme_display_git_master_branch yes
set -g theme_color_scheme gruvbox
# set -g theme_powerline_fonts no
set -g theme_display_date no
set -g theme_display_cmd_duration no
set -g fish_prompt_pwd_dir_length 0

# PATHの重複を削除
set -x PATH (echo $PATH | tr ' ' '\n' | sort -u)
# tmuxを自動起動する自作コマンド
tm

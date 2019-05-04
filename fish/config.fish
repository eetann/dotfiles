set PATH $HOME/.local/bin $PATH
set -x DISPLAY localhost:0.0
set -x GOPATH $HOME/go
set -x PATH $GOPATH/bin $PATH
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
set -g theme_powerline_fonts no
set -g theme_display_date no
set -g theme_display_cmd_duration no
set -g fish_prompt_pwd_dir_length 0

test -n "$TMUX" ;and set change "switch-client" ;or set change "attach-session"
if count $argv > /dev/null
	# 2>/dev/nullでブラックホールに出力を放り込む
	tmux $change -t $argv[1] 2>/dev/null ;or tmux new-session -d -s $argv[1] ;and tmux $change -t $argv[1]
else
	# -Fでフォーマット指定
	# #{}でフォーマット文字列
	set session (tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) ;and tmux $change -t "$session" ;or echo "No sessions found."
end

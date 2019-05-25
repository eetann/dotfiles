function tm -d "attach or new tmux sessions"
	if [ (echo $TMUX) = "" ]
		test -n "$TMUX" ;and set change "switch-client" ;or set change "attach-session"
		if count $argv > /dev/null
			# 2>/dev/nullでブラックホールに出力を放り込む
			tmux $change -t $argv[1] 2>/dev/null ;or tmux new-session -d -s $argv[1] ;and tmux $change -t $argv[1]; return
		end
		# -Fでフォーマット指定
		# #{}でフォーマット文字列
		set session (tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) ;and tmux $change -t "$session" ;or tmux
	end
end

function fish_user_key_bindings
	for mode in insert default visual
	fish_default_key_bindings -M $mode
	end
	fish_vi_key_bindings --no-erase

	bind \cr '__fzf_find_file'
	bind \cq '__fzf_reverse_isearch'
	bind \ce '__fzf_cd'
	if bind -M insert >/dev/null ^/dev/null
		bind -M insert \cr '__fzf_find_file'
		bind -M insert \cq '__fzf_reverse_isearch'
		bind -M insert \ce '__fzf_cd'
	end
end

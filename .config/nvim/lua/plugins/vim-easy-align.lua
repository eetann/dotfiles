return {
	"junegunn/vim-easy-align",
	keys = { { "ga", "<Plug>(LiveEasyAlign)", mode = { "n", "x" }, silent = true } },
	init = function()
		-- コメントや文字列中でも有効化
		vim.g.easy_align_ignore_groups = {}
	end,
}

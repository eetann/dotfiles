return {
	"simeji/winresizer",
	keys = { "<C-e>", mode = { "n" } },
	init = function()
		vim.g.winrisizer_vert_resize = 1
		vim.g.winresizer_horiz_resize = 1
	end,
}

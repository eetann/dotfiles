return {
	"machakann/vim-swap",
	kyes = {
		{ "<Plug>(swap-textobject-i)", mode = { "o", "x" } },
		{ "<Plug>(swap-textobject-a)", mode = { "o", "x" } },
		{ "g<", "<Plug>(swap-prev)", mode = "n" },
		{ "g>", "<Plug>(swap-next)", mode = "n" },
		{ "gs", "<Plug>(swap-interactive)", mode = "n" },
	},
	init = function()
		vim.keymap.set({ "o", "x" }, "i,", "<Plug>(swap-textobject-i)")
		vim.keymap.set({ "o", "x" }, "a,", "<Plug>(swap-textobject-a)")
	end,
}

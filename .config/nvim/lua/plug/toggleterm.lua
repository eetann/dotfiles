require("toggleterm").setup({
	persist_mode = true,
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.4
		end
	end,
})

vim.keymap.set("n", "<Leader>tt", "<Cmd>ToggleTerm<CR>")
vim.keymap.set("n", "<Leader>t-", "<Cmd>ToggleTerm direction=horizontal<CR>")
vim.keymap.set("n", "<Leader>t\\", "<Cmd>ToggleTerm direction=vertical<CR>")
vim.keymap.set("n", "<Leader>tf", "<Cmd>ToggleTerm direction=float<CR>")

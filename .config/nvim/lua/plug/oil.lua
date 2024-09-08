require("oil").setup()

-- oil fix relative path
-- https://github.com/stevearc/oil.nvim/issues/234
vim.api.nvim_create_augroup("OilRelPathFix", {})
vim.api.nvim_create_autocmd("BufLeave", {
	group = "OilRelPathFix",
	pattern = "oil:///*",
	callback = function()
		vim.cmd("cd .")
	end,
})
vim.keymap.set("n", "<Space>go", function()
	require("oil").open()
end, { desc = "Oil current buffer's directory" })
vim.keymap.set("n", "<Space>gO", function()
	require("oil").open(".")
end, { desc = "Oil ." })

require("oil").setup()

-- oil fix relative path
--https://github.com/stevearc/oil.nvim/issues/234
vim.api.nvim_create_augroup("OilRelPathFix", {})
vim.api.nvim_create_autocmd("BufLeave", {
	group = "OilRelPathFix",
	pattern = "oil:///*",
	callback = function()
		vim.cmd("cd .")
	end,
})
vim.keymap.set("n", "<Space>E", function()
	require("oil").open(vim.fn.expand("%:h"))
end, { desc = "Open Oil at the directory with current buffer" })

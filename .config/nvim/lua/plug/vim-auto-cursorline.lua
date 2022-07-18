vim.api.nvim_create_autocmd("FileType", {
	group = "my_nvim_rc",
	pattern = { "TelescopePrompt", "TelescopeResults", "gitblame", "css" },
	callback = function()
		vim.b.auto_cursorline_disabled = true
	end,
})

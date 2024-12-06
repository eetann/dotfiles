return {
	"delphinus/auto-cursorline.nvim",
	event = { "VeryLazy" },
	opts = {},
	config = function()
		require("auto-cursorline").setup()
		vim.api.nvim_create_autocmd("FileType", {
			group = "my_nvim_rc",
			pattern = { "TelescopePrompt", "TelescopeResults", "gitblame", "css" },
			callback = function()
				vim.b.auto_cursorline_disabled = true
			end,
		})
	end,
}

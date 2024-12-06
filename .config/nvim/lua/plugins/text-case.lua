return {
	"johmsalas/text-case.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{ "gt", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "v" }, desc = "Telescope textcase" },
	},
	config = function()
		require("textcase").setup({})
		require("telescope").load_extension("textcase")
	end,
}

return {
	"stevearc/overseer.nvim",
	dependencies = {
		{
			"stevearc/dressing.nvim",
			opts = {
				input = {
					enabled = false,
				},
			},
		},
		{ "nvim-telescope/telescope.nvim" },
	},
	keys = {
		{ "<space>r", "<CMD>OverseerRun<CR>" },
	},
	config = function()
		require("overseer").setup({
			templates = { "builtin", "blog.open-preview", "cpp.gpp-build-run" },
		})
	end,
}

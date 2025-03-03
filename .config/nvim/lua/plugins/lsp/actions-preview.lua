return {
	"aznhe21/actions-preview.nvim",
	lazy = true,
	keys = {
		{
			"<space>la",
			function()
				require("actions-preview").code_actions()
			end,
			mode = { "n", "v" },
			desc = "Code Actions",
		},
	},
	opts = {
		backend = { "snacks" },
	},
}

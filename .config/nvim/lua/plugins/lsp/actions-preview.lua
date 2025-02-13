return {
	"aznhe21/actions-preview.nvim",
	lazy = true,
	keys = {
		{
			"<space>ca",
			function()
				require("actions-preview").code_actions()
			end,
			mode = { "n", "v" },
			desc = "Code Actions",
		},
	},
	opts = {},
}

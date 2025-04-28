---@module "lazy"
---@type LazyPluginSpec
return {
	"rachartier/tiny-code-action.nvim",
	depen = {
		{ "nvim-lua/plenary.nvim" },
		{
			"folke/snacks.nvim",
			opts = {
				terminal = {},
			},
		},
	},
	keys = {
		{
			"gra",
			function()
				require("tiny-code-action").code_action({})
			end,
			mode = { "n", "v" },
			desc = "Code Actions",
		},
	},
	opts = {
		picker = {
			"snacks",
			opts = {},
		},
	},
}

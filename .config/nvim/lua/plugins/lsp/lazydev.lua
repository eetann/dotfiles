return {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			{ path = "overseer.nvim", words = { "overseer" } },
			{ path = "busted/library", words = { "it%(", "describe%(" } },
		},
	},
}

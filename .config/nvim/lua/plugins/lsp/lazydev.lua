return {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			{ path = "overseer.nvim", words = { "overseer" } },
			{ path = "${3rd}/busted/library", words = { "it%(", "describe%(" } },
			{ path = "${3rd}/luassert/library", words = { "assert" } },
		},
	},
}

return {
	"petertriho/nvim-scrollbar",
	event = { "VeryLazy" },
	opts = {
		excluded_filetypes = {
			"prompt",
			"cmp_docs",
			"cmp_menu",
			"TelescopePrompt",
			"noice",
			"LspsagaHover",
		},
	},
}

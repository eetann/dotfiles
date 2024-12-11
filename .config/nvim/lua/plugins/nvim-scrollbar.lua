return {
	"petertriho/nvim-scrollbar",
	event = { "VeryLazy" },
	opts = {
		-- TODO: nvim-cmpのウィンドウも指定
		excluded_filetypes = {
			"prompt",
			"TelescopePrompt",
			"noice",
			"LspsagaHover",
		},
	},
}

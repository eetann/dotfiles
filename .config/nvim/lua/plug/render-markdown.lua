require("render-markdown").setup({
	render_modes = true,
	heading = {
		width = "block",
		left_pad = 0,
		right_pad = 4,
		icons = {},
	},
	code = {
		width = "block",
	},
	checkbox = {
		checked = { scope_highlight = "@markup.strikethrough" },
		custom = {
			canceled = {
				raw = "[-]",
				rendered = "󱘹",
				scope_highlight = "@markup.strikethrough",
			},
		},
	},
})
vim.keymap.set("n", "<Space>sm", ":RenderMarkdown toggle<CR>")

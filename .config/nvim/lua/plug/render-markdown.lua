require("render-markdown").setup({
	heading = {
		width = "block",
		left_pad = 0,
		right_pad = 4,
		icons = {},
	},
	code = {
		width = "block",
	},
})
vim.keymap.set("n", "<Space>sm", ":RenderMarkdown toggle<CR>")

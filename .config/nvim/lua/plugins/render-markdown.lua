return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "md", "mdwn", "mkd", "mkdn", "mark", "mdx" },
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	opts = {
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
	},
	keys = {
		{ "<Space>sm", ":RenderMarkdown toggle<CR>" },
	},
}

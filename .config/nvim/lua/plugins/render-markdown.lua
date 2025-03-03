return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	ft = { "markdown", "md", "mdwn", "mkd", "mkdn", "mark", "mdx" },
	keys = {
		{ "<Space>sm", ":RenderMarkdown toggle<CR>" },
	},
	opts = {
		render_modes = true,
		file_types = { "markdown", "Avante", "codecompanion" },
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
				-- デフォルトの`[-]`であるtodoは削除
				todo = { raw = "", rendered = "", highlight = "" },
				canceled = {
					raw = "[-]",
					rendered = "󱘹",
					scope_highlight = "@markup.strikethrough",
				},
			},
		},
	},
}

return {
	"iamcco/markdown-preview.nvim",
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown", "pu", "plantuml" },
	init = function()
		-- WSL対応のため
		vim.g.mkdp_browserfunc = "g:OpenBrowser"
	end,
}

return {
	"iamcco/markdown-preview.nvim",
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown", "pu", "plantuml" },
	init = function()
		vim.cmd([[
      function OpenMarkdownPreview (url)
        echo luaeval('({vim.ui.open(_A)})[2] or _A', a:url)
      endfunction
]])
		vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
	end,
}

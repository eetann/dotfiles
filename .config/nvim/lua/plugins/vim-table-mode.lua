return {
	"dhruvasagar/vim-table-mode",
	ft = { "markdown", "md", "mdwn", "mkd", "mkdn", "mark", "mdx" },
	keys = {
		{ "<space>tb", "<CMD>TableModeToggle<CR>", buffer = true },
	},
	init = function()
		vim.g.table_mode_corner = "|"
		vim.g.table_mode_disable_mappings = 1
		vim.g.table_mode_disable_tableize_mappings = 1
	end,
}

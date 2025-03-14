return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },
		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "b0o/schemastore.nvim" },
			{ "saghen/blink.cmp" },
		},
		config = function()
			require("plugins.lsp.diagnostic")
			require("plugins.lsp.format")
			require("plugins.lsp.attach")
			require("plugins.lsp.code-actions")
			require("plugins.lsp.server-register")
		end,
	},
	-- { import = "plugins.lsp.tiny-inline-diagnostic" },
	{ import = "plugins.lsp.lspsaga" },
	{ import = "plugins.lsp.actions-preview" },
	{ import = "plugins.lsp.conform" },
	-- { import = "plugins.lsp.none-ls" },
	{ import = "plugins.lsp.nvim-lint" },
	{ import = "plugins.lsp.lazydev" },
}

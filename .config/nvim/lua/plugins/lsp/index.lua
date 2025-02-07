return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },
		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "b0o/schemastore.nvim" },
			{ "hrsh7th/cmp-nvim-lsp" },
		},
		config = function()
			require("plugins.lsp.diagnostic")
			require("plugins.lsp.format")
			require("plugins.lsp.attach")
			require("plugins.lsp.code-actions")
			require("plugins.lsp.server-register")
		end,
	},
	{ import = "plugins.lsp.lspsaga" },
	{ import = "plugins.lsp.conform" },
	{ import = "plugins.lsp.none-ls" },
	{ import = "plugins.lsp.lazydev" },
}

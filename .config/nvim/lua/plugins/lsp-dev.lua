return {
	dir = "~/ghq/github.com/eetann/lsp-dev.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<space>ls", ":LspDev showLog<CR>" },
		{ "<space>lc", ":LspDev changeLogLevel<CR>" },
	},
	opts = {},
}

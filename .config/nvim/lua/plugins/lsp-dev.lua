---@module "lazy"
---@type LazyPluginSpec
return {
	dir = "~/ghq/github.com/eetann/lsp-dev.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	cmd = { "LspDev" },
	keys = {
		{ "<space>ll", ":LspDev showLog<CR>" },
		{ "<space>lL", ":LspDev changeLogLevel<CR>" },
	},
	opts = {},
}

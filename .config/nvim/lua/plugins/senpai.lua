---@module "lazy"
---@type LazyPluginSpec
return {
	-- "eetann/senpai.nvim",
	dir = "~/ghq/github.com/eetann/senpai.nvim",
	dependencies = { "vim-denops/denops.vim" },
	keys = {
		{ "<space>ss", "<Cmd>Senpai toggleChat<CR>" },
	},
	cmd = { "Senpai" },
	ft = "gitcommit",
	---@module "senpai"
	---@type senpai.Config
	opts = {
		provider = vim.env.OPENROUTER_API_KEY and "openrouter" or "openai",
	},
}

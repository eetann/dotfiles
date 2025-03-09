---@module "lazy"
---@type LazyPluginSpec
return {
	"eetann/senpai.nvim",
	-- dir = "~/ghq/github.com/eetann/senpai.nvim",
	dependencies = { "vim-denops/denops.vim" },
	event = { "VeryLazy" },
	---@module "senpai"
	---@type senpai.Config
	opts = {
		-- provider = "openrouter",
	},
}

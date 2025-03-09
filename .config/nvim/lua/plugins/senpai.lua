---@module "lazy"
---@type LazyPluginSpec
return {
	"eetann/senpai.nvim",
	dependencies = { "vim-denops/denops.vim" },
	event = { "VeryLazy" },
	opts = {},
}

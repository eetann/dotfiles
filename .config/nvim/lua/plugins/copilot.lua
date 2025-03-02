---@module "lazy"
---@type LazyPluginSpec
return {
	"zbirenbaum/copilot.lua",
	lazy = true,
	opts = {
		suggestion = { enabled = false },
		panel = { enabled = false },
	},
}

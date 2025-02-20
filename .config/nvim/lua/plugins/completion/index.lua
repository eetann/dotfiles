---@module "lazy"
---@type LazyPluginSpec
return {
	"saghen/blink.cmp",
	event = { "InsertEnter", "CmdLineEnter" },
	dependencies = {
		{ import = "plugins.completion.luasnip" },
		{
			"Kaiser-Yang/blink-cmp-dictionary",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
	},
	-- use a release tag to download pre-built binaries
	version = "*",
	---@module "blink.cmp"
	---@type blink.cmp.Config
	opts = {
		keymap = require("plugins.completion.mappings"),

		snippets = { preset = "luasnip" },
		sources = require("plugins.completion.sources"),

		-- 見た目
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "normal",
		},
		completion = {
			documentation = { auto_show = true, auto_show_delay_ms = 500, window = { border = "single" } },
		},
		signature = { window = { border = "single" } },
	},
	opts_extend = { "sources.default" },
}

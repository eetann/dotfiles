---@module "lazy"
---@type LazyPluginSpec
return {
	"saghen/blink.cmp",
	event = { "InsertEnter", "CmdLineEnter" },
	dependencies = {
		{ import = "plugins.completion.luasnip" },
		"disrupted/blink-cmp-conventional-commits",
		"Kaiser-Yang/blink-cmp-avante",
		"Kaiser-Yang/blink-cmp-dictionary",
	},
	-- use a release tag to download pre-built binaries
	version = "*",
	---@module "blink.cmp"
	---@type blink.cmp.Config
	opts = {
		keymap = require("plugins.completion.mappings"),
		cmdline = {
			keymap = {
				preset = "super-tab",
				["<CR>"] = { "accept_and_enter", "fallback" },
			},
			completion = {
				ghost_text = { enabled = false },
			},
		},

		snippets = { preset = "luasnip" },
		sources = require("plugins.completion.sources"),

		-- 見た目
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "normal",
		},
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				window = { border = "double" },
			},
			menu = {
				auto_show = function(ctx)
					return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
				end,
			},
			ghost_text = { enabled = false },
		},
		signature = { window = { border = "single" } },
	},
	opts_extend = { "sources.default" },
}

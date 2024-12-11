return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		lazy = true,
		dependencies = { "rafamadriz/friendly-snippets" },
		build = "make install_jsregexp",
		config = function()
			require("luasnip").setup({
				load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft({
					astro = { "typescript" },
				}),
			})
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").load({ paths = { "~/dotfiles/.config/nvim/snippet" } })
			vim.api.nvim_create_user_command("LuaSnipEdit", ':lua require("luasnip.loaders").edit_snippet_files()', {})
		end,
	},
	{
		"saadparwaiz1/cmp_luasnip",
		lazy = true,
	},
}

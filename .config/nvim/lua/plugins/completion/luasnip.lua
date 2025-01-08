return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		dependencies = { "rafamadriz/friendly-snippets" },
		build = "make install_jsregexp",
		config = function()
			require("luasnip.loaders.from_lua").load({
				paths = { "~/dotfiles/.config/nvim/snippet" },
				default_priotity = 5000,
			})
			require("luasnip.loaders.from_vscode").lazy_load(
				-- { exclude = { "blade" } }
			)
			require("luasnip").filetype_extend("astro", { "javascript" })
			require("luasnip").filetype_extend("typescript", { "javascript" })
			vim.api.nvim_create_user_command("LuaSnipEdit", ':lua require("luasnip.loaders").edit_snippet_files()', {})
		end,
	},
	{
		"saadparwaiz1/cmp_luasnip",
	},
}

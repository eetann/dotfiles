return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		dependencies = { "rafamadriz/friendly-snippets" },
		build = "make install_jsregexp",
		config = function()
			-- https://github.com/L3MON4D3/LuaSnip/issues/458#issuecomment-1185267154
			-- あくまでもLuaSnipだけで展開させたときの優先度
			-- nvim-cmpで優先度はcom_luasnip側で実装されていそうだけど反映されてない？
			-- <CR>のマッピングにexpandable・expandを追加することで優先度を反映できる
			---@type LuaSnip.Loaders.LoadOpts
			require("luasnip.loaders.from_vscode").load({
				override_priority = 1000,
				-- exclude = {
				-- 	-- "blade",
				-- },
			})
			---@type LuaSnip.Loaders.LoadOpts
			require("luasnip.loaders.from_lua").lazy_load({
				paths = { "~/dotfiles/.config/nvim/snippet" },
				override_priority = 2000,
			})
			require("luasnip").filetype_extend("astro", { "javascript" })
			require("luasnip").filetype_extend("typescript", { "javascript" })
			vim.api.nvim_create_user_command("LuaSnipEdit", ':lua require("luasnip.loaders").edit_snippet_files()', {})
		end,
	},
	{
		"saadparwaiz1/cmp_luasnip",
	},
}

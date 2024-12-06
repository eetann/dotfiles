-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		-- bisectで問題のあったときに特定しやすいようにするため、一括では読み込まない
		-- 無効化したくなったらimportの行をコメントアウトするだけ
		-- { import = "plugins" },
		{ import = "plugins.cellwidths" },
		{ import = "plugins.nightfox" },
		{ import = "plugins.noice" },
		{ import = "plugins.lualine.index" },

		{ import = "plugins.mini-ai" },
		{ import = "plugins.mini-surround" },
		{ import = "plugins.auto-cursorline" },
		{ import = "plugins.nvim-autopairs" },

		{ import = "plugins.telescope" },
		{ import = "plugins.text-case" },

		{ import = "plugins.vim-highlightedyank" },
		{ import = "plugins.vim-swap" },

		{ import = "plugins.nvim-treesitter" },
		{
			"nvim-treesitter/nvim-treesitter-context",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
		},
		{ "nvim-tree/nvim-web-devicons" },
		{ import = "plugins.bufferline" },
		{ import = "plugins.nvim-colorizer" },
		{ "andymass/vim-matchup", dependencies = { "nvim-treesitter/nvim-treesitter" } }, -- %を拡張

		{ import = "plugins.nvim-hlslens" },
		{ import = "plugins.nvim-scrollbar" },
		{ import = "plugins.SmoothCursor" },
		{ import = "plugins.SmoothCursor" },
		{ "kshenoy/vim-signature", event = "VeryLazy" },
		{ import = "plugins.gitsigns" },
		{ "vim-jp/vimdoc-ja", event = "VeryLazy" },
		{ import = "plugins.winresizer" },
		{ import = "plugins.nvim-tree" },
		{ import = "plugins.outline" },
		{ import = "plugins.trouble" },
		{ import = "plugins.vim-translator" },

		{ import = "plugins.quicker" },
		{ import = "plugins.oil" },
		{ import = "plugins.comment" },
		{ import = "plugins.vim-sonictemplate" },
		{ import = "plugins.vim-easy-align" },
		{ import = "plugins.dial" },
		{ import = "plugins.CamelCaseMotion" },

		-- ファイルタイプ固有
		{ import = "plugins.rainbow_csv" },
		-- bladeのインデント用
		{ "jwalton512/vim-blade", ft = "blade" },
		{ import = "plugins.emmet-vim" },
		-- markdown
		{ import = "plugins.vim-table-mode" },
		{ import = "plugins.markdown-preview" },
		{ import = "plugins.render-markdown" },

		-- 外部連携など
		{ import = "plugins.open-browser" },
		{ import = "plugins.vim-quickrun" },

		-- AI系
		{ import = "plugins.gen" },
		{ import = "plugins.codecompanion" },

		-- TODO:
		{ import = "plugins.__WIP" },
	},
})

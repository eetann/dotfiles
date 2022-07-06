local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap
---@diagnostic disable-next-line: missing-parameter
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

return require("packer").startup(function(use)
	use({ "machakann/vim-highlightedyank" }) -- vim/plug/vim-highlightedyank.vim

	-- vim/plug/vim-textobj.vim
	use({ "kana/vim-textobj-user", event = "VimEnter" })
	use({ "kana/vim-textobj-jabraces", after = { "vim-textobj-user" } })
	use({ "osyo-manga/vim-textobj-multiblock", after = { "vim-textobj-user" } })

	use({ "machakann/vim-swap", on = { "<Plug>(swap-" } }) -- vim/plug/vim-swap.vim
	use({ "jiangmiao/auto-pairs" }) -- vim/plug/auto-pairs.vim
	use({ "andymass/vim-matchup" }) -- %を拡張
	use({ "machakann/vim-sandwich" }) -- vim/plug/vim-sandwich.vim

	use({ "nvim-lua/plenary.nvim" }) -- nvim
	use({ "nvim-telescope/telescope.nvim" }) -- vim/plug/telescope.vim
	-- vim/plug/nvim-lspconfig.vim
	use({ "neovim/nvim-lspconfig" })
	use({ "williamboman/nvim-lsp-installer" })
	use({ "ray-x/lsp_signature.nvim" }) -- signature help for insert mode
	use({ "tami5/lspsaga.nvim" })
	use({ "jose-elias-alvarez/null-ls.nvim" })
	use({ "simrat39/symbols-outline.nvim" })
	use({ "weilbith/nvim-code-action-menu" })

	-- vim/plug/nvim-cmp.vim
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-path" })
	use({ "hrsh7th/cmp-cmdline" })
	use({ "uga-rosa/cmp-dictionary" })
	use({ "hrsh7th/nvim-cmp" })
	use({ "folke/lua-dev.nvim" })
	use({ "onsails/lspkind-nvim" })
	use({ "SirVer/ultisnips" })
	use({ "honza/vim-snippets" })
	use({ "quangnguyen30192/cmp-nvim-ultisnips" })

	-- vim/plug/color-scheme.vim
	local colorscheme = "everforest"
	use({
		"sainnhe/everforest",
		event = { "VimEnter", "ColorSchemePre" },
		-- config = function()
		-- 	require("rc/pluginconfig/nightfox")
		-- end,
	})
	use({ "nvim-treesitter/nvim-treesitter", after = { colorscheme }, run = ":TSUpdate" })
	use({ "romgrk/nvim-treesitter-context" })
	use({ "kyazdani42/nvim-web-devicons" })
	use({ "romgrk/barbar.nvim" }) -- vim/plug/barbar.vim
	use({ "lambdalisue/vim-quickrun-neovim-job" }) -- quickrunをNeovimで使う
	use({ "norcalli/nvim-colorizer.lua" }) -- vim/plug/nvim-colorizer.vim
	use({ "folke/lsp-colors.nvim" })
	use({ "RRethy/vim-illuminate" })
	use({ "lukas-reineke/indent-blankline.nvim" }) -- vim/plug/indent-blankline.vim

	use({ "thinca/vim-quickrun" }) -- vim/plug/vim-quickrun.vim

	use({ "nvim-lualine/lualine.nvim" }) -- vim/plug/lualine.vim
	use({ "b0o/incline.nvim" }) -- vim/plug/incline.vim

	use({ "tyru/caw.vim" }) -- vim/plug/caw.vim
	use({ "tyru/open-browser.vim", on = { "<Plug>(openbrowser-smart-search)", "OpenBrowser" } }) -- vim/plug/open-browser.vim

	use({ "mattn/vim-sonictemplate", on = { "Tem", "Template" } }) -- vim/plug/vim-sonictemplate.vim
	use({ "junegunn/vim-easy-align", on = { "<Plug>(LiveEasyAlign)" } }) -- vim/plug/vim-easy-align.vim
	use({ "bkad/CamelCaseMotion", on = { "<Plug>CamelCaseMotion" } }) -- vim/plug/CamelCaseMotion.vim
	use({ "delphinus/vim-auto-cursorline" }) -- vim/plug/vim-auto-cursorline.vim
	use({ "kshenoy/vim-signature" }) -- マーク位置の表示
	use({ "lewis6991/gitsigns.nvim" }) -- vim/plug/gitsigns.vim
	use({ "vim-jp/vimdoc-ja", ft = { "help" } }) -- 日本語ヘルプ
	use({ "simeji/winresizer" }) -- vim/plug/winresizer.vim

	use({ "cespare/vim-toml", ft = { "toml" } }) -- TOMLのシンタックスハイライト
	use({ "mechatroner/rainbow_csv", ft = { "csv" } }) -- vim/plug/rainbow_csv.vim

	-- vim/plug/emmet-vim.vim
	use({
		"mattn/emmet-vim",
		ft = {
			"html",
			"css",
			"php",
			"xml",
			"javascript",
			"vue",
			"typescriptreact",
			"react",
			"javascriptreact",
			"markdown",
		},
	})

	-- vim/plug/vim-table-mode.vim
	use({ "dhruvasagar/vim-table-mode", ft = { "markdown", "md", "mdwn", "mkd", "mkdn", "mark" } })

	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && yarn install",
		ft = { "markdown", "md", "mdwn", "mkd", "mkdn", "mark" },
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)

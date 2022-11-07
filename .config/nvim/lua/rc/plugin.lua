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
	print("Installed packer!")
end

-- packerのconfigでは文字列を返すと評価
local function conf(name)
	return string.format('require("plug/%s")', name)
end

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "plugin.lua",
	command = "source <afile> | PackerCompile",
	group = "my_nvim_rc",
})

return require("packer").startup({
	function(use)
		use({ "wbthomason/packer.nvim" })
		use({ "machakann/vim-highlightedyank", config = conf("vim-highlightedyank") })

		-- .config/nvim/lua/plug/vim-textobj.lua
		use({ "kana/vim-textobj-user", config = conf("vim-textobj") })
		use({ "kana/vim-textobj-jabraces", requires = "kana/vim-textobj-user" })
		use({ "osyo-manga/vim-textobj-multiblock", requires = "kana/vim-textobj-user" })

		use({ "machakann/vim-swap", config = conf("vim-swap") })
		use({ "jiangmiao/auto-pairs", config = conf("auto-pairs") })
		use({ "andymass/vim-matchup" }) -- %を拡張
		use({ "machakann/vim-sandwich", config = conf("vim-sandwich") })

		use({ "nvim-lua/plenary.nvim" })
		use({ "nvim-telescope/telescope.nvim", config = conf("telescope") })

		-- .config/nvim/lua/plug/lsp.lua
		use({ "neovim/nvim-lspconfig", config = conf("lsp") })
		use({ "williamboman/mason.nvim" })
		use({ "williamboman/mason-lspconfig.nvim" })
		use({ "ray-x/lsp_signature.nvim" })
		use({ "kkharji/lspsaga.nvim" })
		use({ "jose-elias-alvarez/null-ls.nvim" })
		use({ "simrat39/symbols-outline.nvim" })
		use({ "weilbith/nvim-code-action-menu" })
		use({ "folke/neodev.nvim" })
		use({ "folke/lsp-colors.nvim" })
		use({ "RRethy/vim-illuminate" })

		-- .config/nvim/lua/plug/completion.lua
		use({ "SirVer/ultisnips", requires = { "honza/vim-snippets", "quangnguyen30192/cmp-nvim-ultisnips" } })
		use({ "hrsh7th/nvim-cmp", config = conf("completion") })
		use({ "hrsh7th/cmp-nvim-lsp", requires = "hrsh7th/nvim-cmp" })
		use({ "hrsh7th/cmp-buffer", requires = "hrsh7th/nvim-cmp" })
		use({ "hrsh7th/cmp-path", requires = "hrsh7th/nvim-cmp" })
		use({ "hrsh7th/cmp-cmdline", requires = "hrsh7th/nvim-cmp" })
		use({ "uga-rosa/cmp-dictionary", requires = "hrsh7th/nvim-cmp" })
		use({ "onsails/lspkind-nvim", requires = "hrsh7th/nvim-cmp" })

		-- .config/nvim/lua/plug/color-scheme.lua
		use({ "EdenEast/nightfox.nvim", config = conf("color-scheme") })

		-- .config/nvim/lua/plug/treesitter.lua
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = conf("treesitter"),
		})
		use({ "nvim-treesitter/nvim-treesitter-context", requires = "nvim-treesitter/nvim-treesitter" })
		use({ "kyazdani42/nvim-web-devicons" })
		use({
			"akinsho/bufferline.nvim",
			tag = "v2.*",
			requires = "kyazdani42/nvim-web-devicons",
			config = conf("bufferline"),
		})
		use({ "norcalli/nvim-colorizer.lua", config = conf("nvim-colorizer") })
		use({
			"lukas-reineke/indent-blankline.nvim",
			config = conf("indent-blankline"),
			requires = "nvim-treesitter/nvim-treesitter",
		})

		use({ "petertriho/nvim-scrollbar", config = conf("nvim-scrollbar") })

		use({ "MunifTanjim/nui.nvim" })
		use({ "rcarriga/nvim-notify" })
		use({
			"folke/noice.nvim",
			config = conf("noice"),
			requires = {
				"MunifTanjim/nui.nvim",
				"rcarriga/nvim-notify",
			},
		})

		use({ "lambdalisue/vim-quickrun-neovim-job" })
		use({ "thinca/vim-quickrun", config = conf("vim-quickrun") })

		use({ "nvim-lualine/lualine.nvim", config = conf("lualine"), requires = "folke/noice.nvim" })
		use({ "b0o/incline.nvim", config = conf("incline") })

		use({ "tyru/caw.vim", config = conf("caw") })
		use({
			"tyru/open-browser.vim",
			config = conf("open-browser"),
		})
		use({ "tyru/open-browser-github.vim", requires = "tyru/open-browser.vim" })

		use({ "mattn/vim-sonictemplate", opt = true, cmd = { "Tem", "Template" }, config = conf("vim-sonictemplate") })
		use({
			"junegunn/vim-easy-align",
			opt = true,
			event = "VimEnter",
			config = conf("vim-easy-align"),
		})
		use({ "bkad/CamelCaseMotion", opt = true, event = "VimEnter", config = conf("CamelCaseMotion") })
		use({ "delphinus/auto-cursorline.nvim", opt = true, event = "VimEnter", config = conf("auto-cursorline") })
		use({ "gen740/SmoothCursor.nvim", config = conf("SmoothCursor") })
		use({ "kshenoy/vim-signature" }) -- マーク位置の表示
		use({ "lewis6991/gitsigns.nvim", config = conf("gitsigns") })
		use({ "vim-jp/vimdoc-ja" })
		use({ "simeji/winresizer", config = conf("winresizer") })
		use({
			"folke/todo-comments.nvim",
			requires = "nvim-lua/plenary.nvim",
			config = function()
				require("todo-comments").setup({})
			end,
		})

		use({ "mechatroner/rainbow_csv", opt = true, ft = { "csv" }, config = conf("rainbow_csv") })

		use({
			"mattn/emmet-vim",
			opt = true,
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
			config = conf("emmet-vim"),
		})

		use({
			"dhruvasagar/vim-table-mode",
			opt = true,
			ft = { "markdown", "md", "mdwn", "mkd", "mkdn", "mark" },
			config = conf("vim-table-mode"),
		})

		use({
			"iamcco/markdown-preview.nvim",
			opt = true,
			ft = { "markdown", "md", "mdwn", "mkd", "mkdn", "mark" },
			run = "cd app && yarn install",
		})

		use({ "akinsho/toggleterm.nvim", tag = "v2.*", config = conf("toggleterm") })

		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = {
		display = {
			open_fn = require("packer.util").float,
		},
	},
})

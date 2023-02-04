local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

local function conf(name)
	return function()
		require("plug/" .. name)
	end
end

local colorscheme = "nightfox.nvim"

require("lazy").setup({
	-- .config/nvim/lua/plug/color-scheme.lua
	{ "EdenEast/nightfox.nvim", config = conf("color-scheme") },

	{ "machakann/vim-highlightedyank", config = conf("vim-highlightedyank") },

	-- .config/nvim/lua/plug/vim-textobj.lua
	{ "kana/vim-textobj-user", config = conf("vim-textobj") },
	{ "kana/vim-textobj-jabraces", dependencies = { "kana/vim-textobj-user" } },
	{ "osyo-manga/vim-textobj-multiblock", dependencies = { "kana/vim-textobj-user" } },

	{ "machakann/vim-swap", config = conf("vim-swap") },
	{ "jiangmiao/auto-pairs", config = conf("auto-pairs") },
	{ "andymass/vim-matchup" }, -- %を拡張
	{ "machakann/vim-sandwich", config = conf("vim-sandwich") },

	{ "nvim-lua/plenary.nvim" },
	{ "nvim-telescope/telescope.nvim", config = conf("telescope") },
	{ "johmsalas/text-case.nvim", dependencies = { "nvim-telescope/telescope.nvim" }, config = conf("text-case") },

	-- .config/nvim/lua/plug/treesitter.lua
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = conf("treesitter"),
		dependencies = { colorscheme },
	},
	{ "nvim-treesitter/nvim-treesitter-context", dependencies = { "nvim-treesitter/nvim-treesitter" } },
	{ "kyazdani42/nvim-web-devicons" },
	{
		"akinsho/bufferline.nvim",
		version = "v2.*",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		config = conf("bufferline"),
	},
	{ "norcalli/nvim-colorizer.lua", config = conf("nvim-colorizer") },
	{
		"lukas-reineke/indent-blankline.nvim",
		config = conf("indent-blankline"),
		dependencies = { "nvim-treesitter/nvim-treesitter", colorscheme },
	},

	-- .config/nvim/lua/plug/lsp.lua
	{ "neovim/nvim-lspconfig", config = conf("lsp") },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	-- { "ray-x/lsp_signature.nvim" },
	{ "glepnir/lspsaga.nvim", dependencies = { "nvim-treesitter/nvim-treesitter" } },
	{ "jose-elias-alvarez/null-ls.nvim" },
	{ "simrat39/symbols-outline.nvim" },
	{ "weilbith/nvim-code-action-menu" },
	{ "folke/neodev.nvim" },
	{ "folke/lsp-colors.nvim" },
	{ "RRethy/vim-illuminate" },

	-- .config/nvim/lua/plug/completion.lua
	{ "SirVer/ultisnips", dependencies = { "honza/vim-snippets", "quangnguyen30192/cmp-nvim-ultisnips" } },
	{
		"hrsh7th/nvim-cmp",
		config = conf("completion"),
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"uga-rosa/cmp-dictionary",
			"onsails/lspkind-nvim",
		},
	},

	{ "petertriho/nvim-scrollbar", config = conf("nvim-scrollbar") },

	{ "MunifTanjim/nui.nvim" },
	{ "rcarriga/nvim-notify" },
	{
		"folke/noice.nvim",
		config = conf("noice"),
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},

	{ "lambdalisue/vim-quickrun-neovim-job" },
	{ "thinca/vim-quickrun", config = conf("vim-quickrun") },

	{ "nvim-lualine/lualine.nvim", config = conf("lualine"), dependencies = { "folke/noice.nvim" } },
	{ "b0o/incline.nvim", config = conf("incline") },

	{ "JoosepAlviste/nvim-ts-context-commentstring", dependencies = { "nvim-treesitter/nvim-treesitter" } },
	{
		"numToStr/Comment.nvim",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = conf("comment"),
	},
	{
		"tyru/open-browser.vim",
		config = conf("open-browser"),
	},
	{ "tyru/open-browser-github.vim", dependencies = { "tyru/open-browser.vim" } },

	{ "mattn/vim-sonictemplate", lazy = true, cmd = { "Tem", "Template" }, config = conf("vim-sonictemplate") },
	{
		"junegunn/vim-easy-align",
		lazy = true,
		event = "VimEnter",
		config = conf("vim-easy-align"),
	},
	{ "bkad/CamelCaseMotion", lazy = true, event = "VimEnter", config = conf("CamelCaseMotion") },
	{ "delphinus/auto-cursorline.nvim", lazy = true, event = "VimEnter", config = conf("auto-cursorline") },
	{ "gen740/SmoothCursor.nvim", config = conf("SmoothCursor") },
	{ "kshenoy/vim-signature" }, -- マーク位置の表示
	{ "lewis6991/gitsigns.nvim", config = conf("gitsigns") },
	{ "vim-jp/vimdoc-ja" },
	{ "simeji/winresizer", config = conf("winresizer") },
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup({})
		end,
	},

	{ "mechatroner/rainbow_csv", lazy = true, ft = { "csv" }, config = conf("rainbow_csv") },

	{
		"mattn/emmet-vim",
		lazy = true,
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
	},

	{
		"dhruvasagar/vim-table-mode",
		lazy = true,
		ft = { "markdown", "md", "mdwn", "mkd", "mkdn", "mark" },
		config = conf("vim-table-mode"),
	},

	{
		"iamcco/markdown-preview.nvim",
		lazy = true,
		ft = { "markdown", "md", "mdwn", "mkd", "mkdn", "mark" },
		build = "cd app && yarn install",
	},

	{ "akinsho/toggleterm.nvim", version = "v2.*", config = conf("toggleterm") },
})

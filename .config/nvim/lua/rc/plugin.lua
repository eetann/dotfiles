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
	{
		"delphinus/cellwidths.nvim",
		build = ":CellWidthsRemove",
		config = conf("cellwidths"),
	},
	-- .config/nvim/lua/plug/color-scheme.lua
	{ "EdenEast/nightfox.nvim", config = conf("color-scheme") },

	{ "nvim-lua/plenary.nvim" },

	{ "machakann/vim-highlightedyank", config = conf("vim-highlightedyank") },

	{ "echasnovski/mini.ai", version = "*", config = conf("mini-ai") },
	{
		"echasnovski/mini.surround",
		version = "*",
		config = conf("mini-surround"),
	},

	{ "machakann/vim-swap", config = conf("vim-swap") },
	{ "jiangmiao/auto-pairs", config = conf("auto-pairs") },

	{ "nvim-telescope/telescope.nvim", config = conf("telescope") },
	{ "johmsalas/text-case.nvim", dependencies = { "nvim-telescope/telescope.nvim" }, config = conf("text-case") },

	-- .config/nvim/lua/plug/treesitter.lua
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = conf("treesitter"),
		dependencies = { colorscheme },
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{ "nvim-tree/nvim-web-devicons" },
	-- TODO: conceallevelをいじってくるので、設定変えるか消すか
	-- { "neovim/tree-sitter-vimdoc" },
	{
		"akinsho/bufferline.nvim",
		-- https://github.com/akinsho/bufferline.nvim/issues/903
		-- version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = conf("bufferline"),
	},
	{ "norcalli/nvim-colorizer.lua", config = conf("nvim-colorizer") },
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = conf("hlchunk"),
	},
	{ "andymass/vim-matchup", dependencies = { "nvim-treesitter/nvim-treesitter" } }, -- %を拡張
	{ "kevinhwang91/nvim-hlslens", config = conf("nvim-hlslens") },

	-- .config/nvim/lua/plug/lsp.lua
	{ "neovim/nvim-lspconfig", config = conf("lsp") },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "aznhe21/actions-preview.nvim" },
	{ "nvimdev/lspsaga.nvim", dependencies = { "nvim-treesitter/nvim-treesitter" } },
	{ "nvimtools/none-ls.nvim", dependencies = { "gbprod/none-ls-shellcheck.nvim" } },
	{ "hedyhli/outline.nvim" },
	-- TODO: https://github.com/folke/lazydev.nvim に書き換え
	{ "folke/neodev.nvim" },
	{ "folke/lsp-colors.nvim" },
	{ "stevearc/conform.nvim", event = { "BufWritePre" }, cmd = { "ConformInfo" } },

	-- .config/nvim/lua/plug/completion.lua
	{
		"SirVer/ultisnips",
		dependencies = { "honza/vim-snippets" },
	},
	{
		"hrsh7th/nvim-cmp",
		config = conf("completion"),
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			-- "hrsh7th/cmp-path",
			{ dir = "~/ghq/github.com/eetann/cmp-eetannpath" },
			"quangnguyen30192/cmp-nvim-ultisnips",
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

	{
		"tyru/open-browser.vim",
		config = conf("open-browser"),
	},
	{ "tyru/open-browser-github.vim", dependencies = { "tyru/open-browser.vim" } },
	{ "lambdalisue/vim-quickrun-neovim-job" },
	{ "thinca/vim-quickrun", config = conf("vim-quickrun") },

	{
		"nvim-lualine/lualine.nvim",
		config = conf("lualine"),
		dependencies = { "folke/noice.nvim" },
	},
	{ "b0o/incline.nvim", config = conf("incline") },

	{ "JoosepAlviste/nvim-ts-context-commentstring" },
	{
		"numToStr/Comment.nvim",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = conf("comment"),
	},

	{
		"mattn/vim-sonictemplate",
		lazy = true,
		cmd = { "Tem", "Template" },
		config = conf("vim-sonictemplate"),
	},
	{
		"junegunn/vim-easy-align",
		lazy = true,
		event = "VimEnter",
		config = conf("vim-easy-align"),
	},
	{
		"bkad/CamelCaseMotion",
		lazy = true,
		event = "VimEnter",
		config = conf("CamelCaseMotion"),
	},
	{
		"delphinus/auto-cursorline.nvim",
		lazy = true,
		event = "VimEnter",
		config = conf("auto-cursorline"),
	},
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
			"astro",
			"css",
			"html",
			"javascript",
			"javascriptreact",
			"markdown",
			"mdx",
			"php",
			"react",
			"typescriptreact",
			"vue",
			"xml",
			"svelte",
		},
		config = conf("emmet-vim"),
	},

	{
		"dhruvasagar/vim-table-mode",
		lazy = true,
		ft = { "markdown", "md", "mdwn", "mkd", "mkdn", "mark", "mdx" },
		config = conf("vim-table-mode"),
	},

	{
		"previm/previm",
		lazy = true,
		ft = { "markdown", "md", "mdwn", "mkd", "mkdn", "mark" },
		dependencies = { "open-browser.vim" },
		config = function()
			vim.g.previm_open_cmd = "wslview"
			-- vim.g.previm_wsl_mode = 1
		end,
	},

	{ "akinsho/toggleterm.nvim", version = "v2.*", config = conf("toggleterm") },
})

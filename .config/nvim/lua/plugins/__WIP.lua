local function conf(name)
	return function()
		require("plug/" .. name)
	end
end

return {
	-- TODO: 依存のところで消す
	{ "nvim-lua/plenary.nvim", lazy = true },

	-- TODO: conceallevelをいじってくるので、設定変えるか消すか
	-- { "neovim/tree-sitter-vimdoc" },
	-- TODO: 2024年11月13日時点でなぜかinsertモードでフリーズするので要確認
	-- {
	-- 	"shellRaining/hlchunk.nvim",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	config = conf("hlchunk"),
	-- },

	-- .config/nvim/lua/plug/lsp.lua
	{ "neovim/nvim-lspconfig", config = conf("lsp") },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "aznhe21/actions-preview.nvim" },
	{ "nvimdev/lspsaga.nvim", dependencies = { "nvim-treesitter/nvim-treesitter" } },
	{ "nvimtools/none-ls.nvim", dependencies = { "gbprod/none-ls-shellcheck.nvim" } },
	{ "b0o/schemastore.nvim" },
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
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
			-- { dir = "eetann/cmp-eetannpath" },
			"eetann/cmp-eetannpath",
			"quangnguyen30192/cmp-nvim-ultisnips",
			"hrsh7th/cmp-cmdline",
			"uga-rosa/cmp-dictionary",
			"onsails/lspkind-nvim",
		},
	},
	{
		"ricardoramirezr/blade-nav.nvim",
		dependencies = { -- totally optional
			"hrsh7th/nvim-cmp", -- if using nvim-cmp
		},
		ft = { "blade", "php" }, -- optional, improves startup time
		opts = {
			close_tag_on_complete = true, -- default: true
		},
	},
}

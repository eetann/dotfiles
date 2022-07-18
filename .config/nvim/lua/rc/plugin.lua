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
	print('Installed packer!')
end

-- packerのconfigでは文字列を返すと評価
local function conf(name)
	return string.format('require("plug/%s")', name)
end

vim.cmd([[packadd packer.nvim]])

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "plugin.lua",
	command = "PackerCompile",
	group = "my_nvim_rc",
})

return require("packer").startup({
	function(use)
		use({ "wbthomason/packer.nvim", opt = true })
		use({ "machakann/vim-highlightedyank", config = conf("vim-highlightedyank") })

		-- .config/nvim/lua/plug/vim-textobj.lua
		use({ "kana/vim-textobj-user", config = conf("vim-textobj") })
		use({ "kana/vim-textobj-jabraces", requires = "kana/vim-textobj-user" })
		use({ "osyo-manga/vim-textobj-multiblock", requires = "kana/vim-textobj-user" })

		use({ "machakann/vim-swap", config = conf("vim-swap") })
		use({ "jiangmiao/auto-pairs", config = conf("auto-pairs") })
		use({ "andymass/vim-matchup" }) -- %を拡張
		use({ "machakann/vim-sandwich", config = conf("vim-sandwich") })

		-- use({ "nvim-lua/plenary.nvim" }) -- nvim
		-- use({ "nvim-telescope/telescope.nvim", config = conf("telescope") })
  -- 
		-- -- .config/nvim/lua/plug/lsp.lua
		-- use({ "neovim/nvim-lspconfig", config = conf("lsp") })
		-- use({ "williamboman/nvim-lsp-installer" })
		-- use({ "ray-x/lsp_signature.nvim" })
		-- use({ "kkharji/lspsaga.nvim" })
		-- use({ "jose-elias-alvarez/null-ls.nvim" })
		-- use({ "simrat39/symbols-outline.nvim" })
		-- use({ "weilbith/nvim-code-action-menu" })
		-- use({ "folke/lua-dev.nvim" })
		-- use({ "folke/lsp-colors.nvim" })
		-- use({ "RRethy/vim-illuminate" })
  -- 
		-- -- .config/nvim/lua/plug/completion.lua
		-- use({ "SirVer/ultisnips", requires = { "honza/vim-snippets", "quangnguyen30192/cmp-nvim-ultisnips" } })
		-- use({ "hrsh7th/nvim-cmp" })
		-- use({ "hrsh7th/cmp-nvim-lsp", requires = "hrsh7th/nvim-cmp" })
		-- use({ "hrsh7th/cmp-buffer", requires = "hrsh7th/nvim-cmp" })
		-- use({ "hrsh7th/cmp-path", requires = "hrsh7th/nvim-cmp" })
		-- use({ "hrsh7th/cmp-cmdline", requires = "hrsh7th/nvim-cmp" })
		-- use({ "uga-rosa/cmp-dictionary", requires = "hrsh7th/nvim-cmp" })
		-- use({ "onsails/lspkind-nvim", requires = "hrsh7th/nvim-cmp" })
  -- 
		-- -- .config/nvim/lua/plug/color-scheme.lua
		-- use({ "sainnhe/everforest", config = conf("color-scheme") })
  -- 
		-- use({ "nvim-treesitter/nvim-treesitter", run = function() require('nvim-treesitter.install').update({ with_sync = true }) end })
		-- use({ "nvim-treesitter/nvim-treesitter-context", requires ="nvim-treesitter/nvim-treesitter" })
		-- use({ "kyazdani42/nvim-web-devicons" })
		-- use({ "romgrk/barbar.nvim", config = conf("barbar") })
		-- use({ "norcalli/nvim-colorizer.lua", config = conf("nvim-colorizer") })
		-- use({ "lukas-reineke/indent-blankline.nvim", config = conf("indent-blankline"), requires ="nvim-treesitter/nvim-treesitter" })
  -- 
		-- use({ "lambdalisue/vim-quickrun-neovim-job" })
		-- use({ "thinca/vim-quickrun", config = conf("vim-quickrun") })
  -- 
		-- use({ "nvim-lualine/lualine.nvim", config = conf("lualine") })
		-- use({ "b0o/incline.nvim", config = conf("incline") })
  -- 
		-- use({ "tyru/caw.vim", config = conf("caw") })
		-- use({ "tyru/open-browser.vim", event = "VimEnter", config = conf("open-browser") })
  -- 
		-- use({ "mattn/vim-sonictemplate", cmd = { "Tem", "Template" }, config = conf("vim-sonictemplate") })
		-- use({ "junegunn/vim-easy-align", cmd = { "<Plug>(LiveEasyAlign)" }, config = conf("vim-easy-align") })
		-- use({ "bkad/CamelCaseMotion", cmd = { "<Plug>CamelCaseMotion" }, config = conf("CamelCaseMotion") })
		-- use({ "delphinus/vim-auto-cursorline", config = conf("vim-auto-cursorline") })
		-- use({ "kshenoy/vim-signature" }) -- マーク位置の表示
		-- use({ "lewis6991/gitsigns.nvim", config = conf("gitsigns") })
		-- use({ "vim-jp/vimdoc-ja", ft = { "help" } }) -- 日本語ヘルプ
		-- use({ "simeji/winresizer", config = conf("winresizer") })
  -- 
		-- use({ "mechatroner/rainbow_csv", ft = { "csv" }, config = conf("rainbow_csv") })
  -- 
		-- use({
		-- 	"mattn/emmet-vim",
		-- 	ft = {
		-- 		"html",
		-- 		"css",
		-- 		"php",
		-- 		"xml",
		-- 		"javascript",
		-- 		"vue",
		-- 		"typescriptreact",
		-- 		"react",
		-- 		"javascriptreact",
		-- 		"markdown",
		-- 	},
		-- 	config = conf("emmet-vim"),
		-- })
  -- 
		-- use({
		-- 	"dhruvasagar/vim-table-mode",
		-- 	ft = { "markdown", "md", "mdwn", "mkd", "mkdn", "mark" },
		-- 	config = conf("vim-table-mode"),
		-- })
  -- 
		-- use({
		-- 	"iamcco/markdown-preview.nvim",
		-- 	run = "cd app && yarn install",
		-- 	cmd = "MarkdownPreview",
		-- })

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

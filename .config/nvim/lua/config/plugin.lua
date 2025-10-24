-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
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
    -- base
    { "nvim-lua/plenary.nvim", lazy = true },
    { import = "plugins.cellwidths" },
    { import = "plugins.nightfox" },

    -- リッチにする
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { import = "plugins.noice" },
    { import = "plugins.lualine.index" },
    { import = "plugins.nvim-treesitter" },
    { import = "plugins.bufferline" },
    { import = "plugins.nvim-colorizer" },
    { import = "plugins.nvim-hlslens" },
    { import = "plugins.nvim-scrollbar" },
    { import = "plugins.hlchunk" },
    { "kshenoy/vim-signature", event = "VeryLazy" },
    { import = "plugins.gitsigns" },

    -- 機能追加
    { import = "plugins.winresizer" },
    { import = "plugins.nvim-tree" },
    { import = "plugins.outline" },
    { import = "plugins.trouble" },

    -- 編集
    { import = "plugins.mini-ai" },
    { import = "plugins.mini-surround" },
    { import = "plugins.auto-cursorline" },
    { import = "plugins.nvim-autopairs" },
    { import = "plugins.lsp.index" },
    { import = "plugins.dap.index" },
    { import = "plugins.completion.index" },
    { import = "plugins.vim-swap" },
    { import = "plugins.quicker" },
    { import = "plugins.oil" },
    { import = "plugins.comment" },
    { import = "plugins.vim-sonictemplate" },
    { import = "plugins.mini-align" },
    { import = "plugins.dial" },

    -- fuzzy finder
    { import = "plugins.text-case" },
    { import = "plugins.snacks.index" },

    -- 移動
    { import = "plugins.CamelCaseMotion" },
    -- %を拡張
    {
      "andymass/vim-matchup",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      event = { "BufReadPre", "BufNewFile" },
    },

    -- ファイルタイプ固有
    { import = "plugins.emmet-vim" },
    { import = "plugins.csvview" },
    { "vim-jp/vimdoc-ja", event = "VeryLazy" },
    -- blade
    { "jwalton512/vim-blade", ft = "blade" }, -- インデント
    -- markdown
    { import = "plugins.vim-table-mode" },
    { import = "plugins.markdown-preview" },
    { import = "plugins.render-markdown" },
    { import = "plugins.clipboard-image-to-agent" },

    -- 外部連携など
    { import = "plugins.open-browser" },
    { import = "plugins.pantran" },
    { import = "plugins.overseer" },

    -- AI系
    -- { import = "plugins.codecompanion.index" },
    -- { import = "plugins.avante" },

    -- プラグイン開発
    { import = "plugins.lsp-dev" },
    { import = "plugins.mini-doc" },
    { import = "plugins.mini-test" },
    { import = "plugins.denops" },
    -- { import = "plugins.senpai.index" },
    -- {
    -- 	"grapp-dev/nui-components.nvim",
    -- 	dependencies = {
    -- 		"MunifTanjim/nui.nvim",
    -- 	},
    -- },
  },
})

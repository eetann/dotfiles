-- 文字関連の設定
vim.o.encoding = 'utf-8'
vim.o.fileencodings = 'utf-8'
vim.o.ambiwidth = 'single'
vim.o.backspace = 'indent,eol,start'
-- 数増減は10進数でハイフンを無視する
vim.o.nrformats = 'unsigned'

-- reset augroup--------------------------------------------------
local group_name = 'my_nvim_rc'
vim.api.nvim_create_augroup(group_name, { clear = true })

-- 移動系---------------------------------------------------------
vim.o.scrolloff = 3

-- コピペ関連-----------------------------------------------------
vim.o.clipboard = 'unnamedplus,unnamed'

-- タブ設定-------------------------------------------------------
vim.o.expandtab = true -- インデントはスペース
vim.o.tabstop = 2 -- タブ幅をスペース4つ分にする
vim.o.softtabstop = 2 -- 連続空白に対してTabやBackSpaceでcursorが動く幅

vim.o.autoindent = true -- 改行時に前の行のintentを継続する
vim.o.smartindent = true -- 次の行のintentを末尾に合わせて増減
vim.o.shiftwidth = 2 -- smartindentでずれる幅

-- 文字列検索-----------------------------------------------------
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
-- 検索時に検索件数メッセージを表示
vim.opt.shortmess = string.gsub(vim.opt.shortmess, 'S', '')
-- html記述に合わせてファイルの相対パスが/始まりでも認識できるようにする
-- vim.o.includeexpr =

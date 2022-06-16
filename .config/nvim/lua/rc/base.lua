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
vim.opt.tabstop = 2
vim.o.softtabstop = 2 -- 連続空白に対してTabやBackSpaceでcursorが動く幅

vim.o.autoindent = true -- 改行時に前の行のintentを継続する
vim.o.smartindent = true -- 次の行のintentを末尾に合わせて増減
vim.o.shiftwidth = 2 -- smartindentでずれる幅

-- 文字列検索-----------------------------------------------------
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
-- 検索時に検索件数メッセージを表示
vim.opt.shortmess:remove({ 'S' })
-- html記述に合わせてファイルの相対パスが/始まりでも認識
-- vim.cmd([[set includeexpr=substitute(v:fname,'^\\/','','')]])
vim.opt.includeexpr = string.gsub(vim.v.fname, '^\\/', '')

vim.api.nvim_create_autocmd({ 'QuickFixCmdPost' }, {
  group = group_name,
  pattern = { '*grep*' },
  command = 'cwindow',
})

if vim.fn.executable('jvgrep') then
  vim.o.grepprg = 'jvprep'
end
vim.opt.noswapfile = true
vim.opt.hidden = true
vim.opt.wildmenu = true
vim.opt.history = 1000
vim.opt.completeopt = { 'menuone', 'popup' }
vim.opt.mouse = a
vim.opt.ttimeoutlen = 100 -- ESCしてから挿入モード出るまでの時間を短縮
vim.opt.helplang = { 'ja', 'en' }
vim.opt.keywordprg = ':help'
vim.opt.formatoptions:remove({ 'r', 'o' })
vim.opt.formatoptions:append({ 'M', 'j' })
vim.opt.title = true -- 編集中のファイル名表示
vim.opt.relativenumber = true --  相対的な行番号の表示
vim.opt.number = true --  現在の行番号の表示
vim.opt.nowrap = true --  折り返さない
vim.opt.showmatch = true -- 括弧入力時に対応括弧表示
vim.opt.colorcolumn = 88 -- カラムラインを引く(Pythonのformatter'black'基準)
-- 行末から次の行へ移動できる
vim.opt.whichwrap = { 'b', 's', 'h', 'l', '[', ']', '<', '>', '~' }
vim.opt.signcolumn = 'yes'
vim.opt.list = true -- 空白文字の可視化
vim.opt.listchars = ('tab:| ') -- Tab
vim.opt.listchars = ('trail:-') -- 行末スペース
vim.opt.listchars = ('eol:↲') -- 改行
vim.opt.listchars = ('extends:»') -- ウィンドウ幅狭い時の後方省略
vim.opt.listchars = ('precedes:«') -- ウィンドウ幅狭い時の前方省略
vim.opt.listchars = ('nbsp:%') -- 不可視のスペース

vim.opt.display = 'lastline'
if vim.fn.has('termguicolors') == 1 then
  vim.opt.termguicolors = true
end
vim.opt.background = 'dark'

-- カーソル位置を復帰
vim.api.nvim_create_autocmd(
  'BufReadPost',
  {
    callback = function()
      local row, col = unpack(vim.api.nvim_buf_get_mark(0, '\"'))
      if { row, col } ~= { 0, 0 } then
        vim.api.nvim_win_set_cursor(0, { row, 0 })
      end
    end,
    group = group_name
  }
)

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.winwidth = 30
vim.opt.winminwidth = 30
vim.opt.noequalalways = true
vim.opt.belloff = 'all'

vim.cmd('filetype plugin indent on')
vim.cmd('syntax enable')

-- 文字関連の設定
vim.opt.ambiwidth = "single"
-- 数増減は10進数でハイフンを無視する
vim.opt.nrformats = "unsigned"

-- reset augroup--------------------------------------------------
local group_name = "my_nvim_rc"
vim.api.nvim_create_augroup(group_name, { clear = true })

-- 移動系---------------------------------------------------------
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 3

-- コピペ関連-----------------------------------------------------
vim.opt.clipboard = { "unnamedplus", "unnamed" }
if vim.fn.has("wsl") == 1 then
	vim.g.clipboard = {
		name = "WslClipboard",
		copy = {
			["+"] = "xsel -bi",
			["*"] = "xsel -bi",
		},
		paste = {
			-- https://stackoverflow.com/questions/75548458/copy-into-system-clipboard-from-neovim
			["+"] = function()
				return vim.fn.systemlist('xsel -bo | cat | tr -d "\r"', { "" }, 1) -- '1' keeps empty lines
			end,
			["*"] = function()
				return vim.fn.systemlist('xsel -bo | cat | tr -d "\r"', { "" }, 1) -- '1' keeps empty lines
			end,
		},
		cache_enabled = 1,
	}
end

-- タブ設定-------------------------------------------------------
vim.opt.expandtab = true -- インデントはスペース
vim.opt.tabstop = 2 -- タブ幅をスペース4つ分にする
vim.opt.softtabstop = 2 -- 連続空白に対してTabやBackSpaceでcursorが動く幅

vim.opt.autoindent = true -- 改行時に前の行のintentを継続する
vim.opt.smartindent = true -- 次の行のintentを末尾に合わせて増減
vim.opt.shiftwidth = 2 -- smartindentでずれる幅

-- 文字列検索-----------------------------------------------------
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- html記述に合わせてファイルの相対パスが/始まりでも認識
-- vim.cmd([[set includeexpr=substitute(v:fname,'^\\/','','')]])
vim.opt.includeexpr = string.gsub(vim.v.fname, "^\\/", "")

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = group_name,
	pattern = { "*grep*" },
	command = "cwindow",
})

vim.opt.swapfile = false
vim.opt.history = 1000
vim.opt.completeopt = { "menu", "menuone", "preview" }
vim.opt.mouse = "a"
vim.opt.ttimeoutlen = 100 -- ESCしてから挿入モード出るまでの時間を短縮
vim.opt.helplang = { "ja", "en" }
vim.opt.keywordprg = ":help"
-- cabによる展開だとnoiceでhelpだと認識できない(Lua Patternの制限)
vim.cmd([[cab H belowright vertical help]])
vim.opt.formatoptions:remove({ "r", "o" })
vim.opt.formatoptions:append({ "M", "j" })
vim.opt.title = true -- 編集中のファイル名表示
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.showmatch = true -- 括弧入力時に対応括弧表示
vim.wo.colorcolumn = "88" -- カラムラインを引く
-- 行末から次の行へ移動できる
vim.opt.whichwrap = "b,s,h,l,[,],<,>,~"
vim.opt.signcolumn = "yes"
vim.opt.list = true -- 空白文字の可視化
vim.opt.listchars = {
	tab = "| ", -- Tab
	trail = "-", -- 行末スペース
	eol = "↲", -- 改行
	extends = "»", -- ウィンドウ幅狭い時の後方省略
	precedes = "«", -- ウィンドウ幅狭い時の前方省略
	nbsp = "%", -- 不可視のスペース
}
-- minifyされたファイルを開いてしまったりプレビューに出てきたとき用に、
-- シンタックスの制限
vim.opt.synmaxcol = 150
vim.opt.display = "lastline"
if vim.fn.has("termguicolors") == 1 then
	vim.opt.termguicolors = true
end
vim.opt.background = "dark"

-- カーソル位置を復帰
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		if vim.bo.filetype == "Outline" or vim.bo.filetype == "gitcommit" then
			-- 早期リターン
			do
				return
			end
		end
		local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"'))
		if { row, col } ~= { 0, 0 } then
			pcall(vim.api.nvim_win_set_cursor, 0, { row, 0 })
		end
	end,
	group = group_name,
})

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.winwidth = 30
vim.opt.winminwidth = 30
vim.opt.equalalways = false

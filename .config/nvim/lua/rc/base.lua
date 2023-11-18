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
if vim.fn.has("wsl") then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe"
    },
    paste = {
      ["+"] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))",
      ["*"] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))",
    },
    cache_enable = 0,
  }
end

-- タブ設定-------------------------------------------------------
vim.opt.expandtab = true   -- インデントはスペース
vim.opt.tabstop = 2        -- タブ幅をスペース4つ分にする
vim.opt.softtabstop = 2    -- 連続空白に対してTabやBackSpaceでcursorが動く幅

vim.opt.autoindent = true  -- 改行時に前の行のintentを継続する
vim.opt.smartindent = true -- 次の行のintentを末尾に合わせて増減
vim.opt.shiftwidth = 2     -- smartindentでずれる幅

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

if vim.fn.executable("jvgrep") then
  vim.opt.grepprg = "jvprep"
end
vim.opt.swapfile = false
vim.opt.history = 1000
vim.opt.completeopt = { "menu", "menuone", "preview" }
vim.opt.mouse = "a"
vim.opt.ttimeoutlen = 100 -- ESCしてから挿入モード出るまでの時間を短縮
vim.opt.helplang = { "ja", "en" }
vim.opt.keywordprg = ":help"
vim.opt.formatoptions:remove({ "r", "o" })
vim.opt.formatoptions:append({ "M", "j" })
vim.opt.title = true -- 編集中のファイル名表示
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.showmatch = true  -- 括弧入力時に対応括弧表示
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

vim.opt.display = "lastline"
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end
vim.opt.background = "dark"

-- カーソル位置を復帰
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    if vim.bo.filetype == "Outline" then
      -- symbols-outlineなら早期リターン
      do
        return
      end
    end
    local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"'))
    if { row, col } ~= { 0, 0 } then
      vim.api.nvim_win_set_cursor(0, { row, 0 })
    end
  end,
  group = group_name,
})

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.winwidth = 30
vim.opt.winminwidth = 30
vim.opt.equalalways = false

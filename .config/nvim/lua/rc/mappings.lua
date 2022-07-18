vim.g.mapleader = " "

vim.keymap.set("n", "j", function()
	if vim.v.count == 0 then
		return "gj"
	else
		return "j"
	end
end, { expr = true })

vim.keymap.set("n", "k", function()
	if vim.v.count == 0 then
		return "gk"
	else
		return "k"
	end
end, { expr = true })

vim.keymap.set("x", "j", function()
	if vim.v.count == 0 and vim.fn.mode(0) == "v" then
		return "gj"
	else
		return "j"
	end
end, { expr = true })

vim.keymap.set("x", "k", function()
	if vim.v.count == 0 and vim.fn.mode(0) == "v" then
		return "gk"
	else
		return "k"
	end
end, { expr = true })

-- 誤爆防止
vim.keymap.set("i", "<C-@>", "<C-[>")
vim.keymap.set("n", "q", "<NOP>")
vim.keymap.set("n", "<Leader>q", "q")
vim.keymap.set("n", "s", "<NOP>")

-- フォーカス移動
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sl", "<C-w>l")
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sc", "<C-w>c")

vim.keymap.set("n", "ss", "<Cmd>sp<CR>", { desc = "水平分割" })
vim.keymap.set("n", "sv", "<Cmd>vs<CR>", { desc = "垂直分割" })

-- カーソル移動
vim.keymap.set("i", "<C-b>", "<left>")
vim.keymap.set("i", "<C-f>", "<right>")
vim.keymap.set("i", "<C-a>", "<C-o>^")
vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("c", "<C-b>", "<left>")
vim.keymap.set("c", "<C-f>", "<right>")
vim.keymap.set("c", "<C-a>", "<HOME>")
vim.keymap.set("c", "<C-e>", "<End>")
vim.keymap.set("c", "<C-p>", "<Up>")
vim.keymap.set("c", "<C-n>", "<Down>")
vim.keymap.set("c", "<C-k>", "<Up>")
vim.keymap.set("c", "<C-j>", "<Down>")
vim.keymap.set("n", "[q", "<Cmd>cprevious<CR>")
vim.keymap.set("n", "]q", "<Cmd>cnext<CR>")
vim.keymap.set("n", "[Q", "<Cmd>cfirst<CR>")
vim.keymap.set("n", "]Q", "<Cmd>clast<CR>")

-- カーソル前方の数字に対してインクリメント&デクリメント
-- TODO: luaに置き換え
vim.keymap.set("n", "s<C-a>", "<Cmd>call search('[0-9]','b', line('.'))<CR><C-a>")
vim.keymap.set("n", "s<C-x>", "<Cmd>call search('[0-9]','b', line('.'))<CR><C-x>")

vim.keymap.set("n", "Y", "mz0vg$y`z:delmarks z<CR>", { desc = "現在行を改行を含めずにヤンク" })
vim.keymap.set("x", "gy", "y`>", { desc = "選択範囲をヤンクしたら選択範囲の末尾へ移動" })
-- TODO: もっと賢そうな書き方あるかも
vim.keymap.set(
	"x",
	"p",
	[['pgv"'.v:register.'ygv<esc>']],
	{ expr = true, desc = "VisualModeで置換対象ペースト時のヤンク入れ替えを防ぐ" }
)
vim.keymap.set("n", "sgv", "`[v`]", { desc = "ペーストした範囲をvisualModeで選択" })
vim.keymap.set(
	"n",
	"sP",
	"mz:put!<CR>`[v`]=`zdmz",
	{ desc = "上の行に貼り付けてカーソル位置はそのまま" }
)
vim.keymap.set(
	"n",
	"sp",
	"mz:put<CR>`[v`]=`zdmz",
	{ desc = "下の行に貼り付けてカーソル位置はそのまま" }
)
vim.keymap.set(
	"n",
	"sgP",
	"<Cmd>put!<CR>`[v`]=`<^",
	{ desc = "下の行に貼り付けたら貼り付けの末尾へ" }
)
vim.keymap.set(
	"n",
	"sgp",
	"<Cmd>put<CR>`[v`]=`>$",
	{ desc = "上の行へ貼り付けたら貼り付けの先頭(インデントじゃない)へ" }
)
vim.keymap.set("n", "sy", "<Cmd>%y<CR>", { desc = "全選択してyank" })
vim.keymap.set(
	"n",
	"sgf",
	"<Cmd>let @+=expand('%')<CR>:echo 'Clipboard << ' . @+<CR>",
	{ desc = "現在のファイル名をyank" }
)
vim.keymap.set("n", "sge", function()
	vim.cmd([[
      let s:echo_hist = histget('cmd', -1)
      if s:echo_hist =~ '^echo '
          let @z = substitute(s:echo_hist, '^echo\s','echomsg ', '')
          execute "normal ;\<C-r>z\<CR>"
          let @+ = execute('1messages')
      endif
    ]])
	vim.cmd([[echo 'Clipboard << ' . @+]])
end, {
	desc = "直前のechoをyank",
})
vim.keymap.set(
	"n",
	"sg/",
	"<Cmd>let @+ = histget('search',-1)<CR>:echo 'Clipboard << ' . @+<CR>",
	{ desc = "直前の検索をヤンク" }
)
vim.keymap.set("n", "/", "/\\v", { desc = "検索でエスケープ減らすために very magic" })

local function set_vsearch()
	vim.cmd([[
    silent normal gv"zy
    let @/ = '\V' . substitute(escape(@z, '/\'), '\n', '\\n', 'g')
  ]])
end
vim.keymap.set("x", "*", function()
	set_vsearch()
	vim.cmd([[normal! mz/<C-r>/<CR>`zdmz]])
end, { noremap = true, silent = true, desc = "選択した文字列を検索" })
vim.keymap.set("x", "#", function()
	set_vsearch()
	vim.cmd([[normal! /<C-r>/<CR>:%s/<C-r>///g<Left><Left>]])
end, { noremap = true, silent = true, desc = "選択した文字列を検索" })

vim.cmd([[
" cursor下の単語をハイライトと置換
nnoremap * "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nnoremap # "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>:%s/<C-r>///g<Left><Left>
" function! s:set_vsearch() abort
"     silent normal gv"zy
"     let @/ = '\V' . substitute(escape(@z, '/\'), '\n', '\\n', 'g')
" endfunction
" xnoremap * <Cmd>call set_vsearch()<CR>mz/<C-r>/<CR>`zdmz
" xnoremap # <Cmd>call set_vsearch()<CR>/<C-r>/<CR>:%s/<C-r>///g<Left><Left>
]])

vim.keymap.set("n", "<ESC><ESC>", "<Cmd>set nohlsearch! hlsearch?<CR>", { silent = true })

-- digraph f<C-k>xxで対応文字に飛べる
vim.cmd([[
" カッコ
digraphs j( 65288  " （
digraphs j) 65289  " ）
digraphs j[ 12300  " 「
digraphs j] 12301  " 」
digraphs j{ 12302  " 『
digraphs j} 12303  " 』

" 句読点
digraphs j, 12289  " 、
digraphs j. 12290  " 。
digraphs j< 65292  " ，
digraphs j> 65294  " ．
digraphs j! 65281  " ！
digraphs j? 65311  " ？
digraphs j: 65306  " ：

" その他
digraphs j~ 12316  " 〜
digraphs j/ 12539  " ・
digraphs js 12288  " 　
digraphs jj 106  " 潰されるjのために
]])

-- fjde で 'で'に飛べる
vim.keymap.set("n", "fj", "f<C-k>")
vim.keymap.set("n", "Fj", "F<C-k>")
vim.keymap.set("n", "tj", "t<C-k>")
vim.keymap.set("n", "Tj", "T<C-k>")

-- 切り替え
vim.keymap.set("n", "[my-switch]", "<Nop>")
vim.keymap.set("n", "<Leader>s", "[my-switch]")
vim.keymap.set("n", "[my-switch]w", "<Cmd>setl wrap! wrap?<CR>")
vim.keymap.set("n", "[my-switch]p", "<Cmd>setl paste! paste?<CR>")

-- InsertModeでccc を入力し、エスケープでコメント線
vim.cmd([[inoreabbrev <expr> ccc repeat('-', 70 - virtcol('.'))]])

-- ----cursorの形をモードで変化(ターミナルによる)-----------------
vim.cmd([[
if has('vim_starting') " reloadableにするため
    " 挿入モード時に点滅の縦棒タイプのcursor
    let &t_SI .= "\e[5 q"
    " ノーマルモード時に非点滅のブロックタイプのcursor
    let &t_EI .= "\e[2 q"
    " 置換モード時に非点滅の下線タイプのcursor
    let &t_SR .= "\e[4 q"
endif
]])

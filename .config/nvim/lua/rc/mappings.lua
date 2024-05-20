vim.g.mapleader = " "

vim.keymap.set("n", "j", function()
	if vim.v.count == 0 then
		return "gj"
	else
		return "m'" .. vim.v.count .. "j"
	end
end, { expr = true })

vim.keymap.set("n", "k", function()
	if vim.v.count == 0 then
		return "gk"
	else
		return "m'" .. vim.v.count .. "k"
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

vim.keymap.set("n", "-", "<Cmd>split<CR>", { desc = "水平分割" })
vim.keymap.set("n", "<Bar>", "<Cmd>vsplit<CR>", { desc = "垂直分割" })
vim.keymap.set("n", "<Bslash>", "<Cmd>vsplit<CR>", { desc = "垂直分割" })

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
	"<Cmd>let @+=expand('%:t:r')<CR>:echo 'Clipboard << ' . @+<CR>",
	{ desc = "現在のファイル名(拡張子無し)をyank" }
)
vim.keymap.set(
	"n",
	"sgF",
	"<Cmd>let @+=expand('%')<CR>:echo 'Clipboard << ' . @+<CR>",
	{ desc = "現在のファイル名(相対パス)をyank" }
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
vim.keymap.set("n", "/", [[/\v]], { desc = "検索でエスケープ減らすために very magic" })

-- 履歴をバッファとして開くやつ
vim.keymap.set("n", "s:", "q:")
vim.keymap.set("n", "s?", "q?")
vim.keymap.set("n", "s/", "q/")

vim.keymap.set("n", "<ESC><ESC>", "<Cmd>set nohlsearch! hlsearch?<CR>", { silent = true })

local function register_digraph(key_pair, char)
	vim.cmd(("digraphs %s %s"):format(key_pair, vim.fn.char2nr(char, nil)))
end

-- digraph f<C-k>xxで対応文字に飛べる
-- 括弧
register_digraph("j(", "（")
register_digraph("j8", "（")
register_digraph("j)", "）")
register_digraph("j9", "）")
register_digraph("j[", "「")
register_digraph("j]", "」")
register_digraph("j{", "『")
register_digraph("j}", "』")

-- 句読点
register_digraph("j,", "、")
register_digraph("j.", "。")
register_digraph("j<", "，")
register_digraph("j>", "．")
register_digraph("j!", "！")
register_digraph("j?", "？")
register_digraph("j:", "：")

-- その他
register_digraph("j~", "〜")
register_digraph("j/", "・")
register_digraph("js", "　")
register_digraph("jj", "j") --潰されるjのために

-- fjde で 'で'に飛べる
vim.keymap.set({ "n", "x" }, "fj", "f<C-k>")
vim.keymap.set({ "n", "x" }, "Fj", "F<C-k>")
vim.keymap.set({ "n", "x" }, "tj", "t<C-k>")
vim.keymap.set({ "n", "x" }, "Tj", "T<C-k>")

-- 切り替え
vim.keymap.set("n", "<Leader>sw", "<Cmd>setl wrap! wrap?<CR>")
vim.keymap.set("n", "<Leader>sp", "<Cmd>setl paste! paste?<CR>")

-- terminal
vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { desc = "out of Term" })
vim.keymap.set("t", "<C-w>k", [[<Cmd>wincmd k<CR>]], { desc = "go to upper win" })
vim.keymap.set("t", "<C-w>j", [[<Cmd>wincmd j<CR>]], { desc = "go to bottom win" })
vim.keymap.set("t", "<C-w>h", [[<Cmd>wincmd h<CR>]], { desc = "go to left win" })
vim.keymap.set("t", "<C-w>l", [[<Cmd>wincmd l<CR>]], { desc = "go to right win" })
vim.keymap.set("t", "<C-w>c", [[<Cmd>wincmd c<CR>]], { desc = "close win" })

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

if vim.b.my_plugin_markdown ~= nil then
	return
end
vim.b.my_plugin_markdown = true

local function markdown_checkbox(from, to)
	local another = vim.fn.line("v")
	if from == to and from ~= another then
		if another < from then
			from = another
		else
			to = another
		end
	end

	local curpos = vim.fn.getcursorcharpos()
	-- LOVE: https://gitspartv.github.io/lua-patterns/?pattern=%5E%25s*(%5B*+-%5D%7C%25d+%25.)%25s+
	-- luaでは(a|b)が書けないのでvim.regex
	local list_pattern = "\\v^\\s*[*+-]\\s+"

	for lnum = from, to do
		local line = vim.fn.getline(lnum)

		if not vim.regex(list_pattern):match_str(line) then
			-- Not a list -> Add list marker and blank box
			line = vim.fn.substitute(line, "\\v\\S|$", "- [ ] \\0", "")
			if lnum == curpos[2] then
				curpos[3] = curpos[3] + 6
			end
		elseif vim.regex(list_pattern .. "\\[ \\]\\s+"):match_str(line) then
			-- Blank box -> Check
			line = vim.fn.substitute(line, "\\[ \\]", "[x]", "")
		elseif vim.regex(list_pattern .. "\\[x\\]\\s+"):match_str(line) then
			-- Checked box -> Uncheck
			line = vim.fn.substitute(line, "\\[x\\]", "[ ]", "")
		else
			-- List but no box -> Add box after list marker
			line = vim.fn.substitute(line, "\\v\\S+", "\\0 [ ]", "")
			if lnum == curpos[2] then
				curpos[3] = curpos[3] + 4
			end
		end

		vim.fn.setline(lnum, line)
	end

	vim.fn.setcursorcharpos(curpos[2], curpos[3])
end

local function is_in_num_list()
	local current_line = vim.api.nvim_get_current_line()
	return current_line:match("^%s*%d+%.%s") ~= nil
end

vim.api.nvim_buf_create_user_command(0, "MarkdownCheckbox", function(opts)
	markdown_checkbox(opts.line1, opts.line2)
end, { range = true })
-- Macだとcontrol + Enterに割当ができないので妥協
vim.keymap.set(
	{ "n", "i", "x" },
	"<C-q>",
	"<Cmd>MarkdownCheckbox<CR>",
	{ buffer = true, desc = "Markdownのチェックボックスのトグル" }
)
vim.keymap.set("i", "<CR>", function()
	if is_in_num_list() then
		local line = vim.api.nvim_get_current_line()
		local modified_line = line:gsub("^%s*(%d+)%.%s.*$", function(numb)
			numb = tonumber(numb) + 1
			return tostring(numb)
		end)
		return "<CR>" .. modified_line .. ". "
	else
		return "<CR>"
	end
end, {
	desc = "Markdownの時は番号リストのインクリメントを追加",
	buffer = true,
	expr = true,
	silent = true,
})

-- ref: https://vi.stackexchange.com/questions/9344/open-markdown-filename-under-cursor-like-gf-and-jump-to-the-section
vim.keymap.set("n", "gf", function()
	local cfile = vim.fn.expand("<cfile>")
	-- ([^#]*) -> ファイル名 -> %1
	-- (#+) -> 見出しのシャープ -> %2
	-- ([^#]*) -> 見出しテキスト -> %3
	local arg = cfile:gsub("([^#]*)(#+)([^#]*)", function(filename, hashes, heading)
		-- 見出しテキストの`-`をエスケープ
		local escaped_heading = heading:gsub("-", ".")
		return "+/" .. hashes .. "\\ " .. escaped_heading .. " " .. filename
	end)
	vim.cmd("edit " .. arg)
end, { desc = "gfを拡張: 見出しリンクも辿れる", buffer = true })

-- 現在の箇所をwikilink化
vim.keymap.set("n", "<space>mw", function()
	-- 現在の位置をmで記録
	vim.cmd("mark z")

	-- 現在のテキストの見出しに移動
	vim.fn.search("^#", "b")

	-- 見出しテキストを取得してエスケープする
	local heading_link = ""
	if vim.fn.line(".") ~= 1 then
		local line = vim.api.nvim_get_current_line()
		heading_link = line:gsub("(#+)%s+([^#]*)", function(hashes, heading)
			-- 見出しテキストをエスケープ
			local escaped_heading = heading:gsub("[][%s^$*(){}|]", "-")
			return hashes .. escaped_heading
		end)
		-- 一行目に移動
		vim.api.nvim_win_set_cursor(0, { 1, 0 })
	end

	-- タイトルの取得
	local line = vim.api.nvim_get_current_line()
	local title = line:match("#%s+([^#]*)")

	-- リンクの取得
	local current_file = vim.fn.expand("%")
	local link = "[[" .. current_file .. heading_link .. "|" .. title .. "]]"
	vim.fn.setreg("+", link)
	vim.print("yank '" .. link .. "'")

	-- 元の位置に戻る
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("`z", true, false, true), "in", false)
end, { desc = "現在行のwikilinkを取得", buffer = true })

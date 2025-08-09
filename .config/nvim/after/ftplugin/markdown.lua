if vim.b.my_plugin_markdown ~= nil then
	return
end
vim.b.my_plugin_markdown = true

local function is_in_num_list()
	local current_line = vim.api.nvim_get_current_line()
	return current_line:match("^%s*%d+%.%s") ~= nil
end
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
		-- 1行目に移動
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
	vim.cmd("normal `z")
end, { desc = "現在行のwikilinkを取得", buffer = true })

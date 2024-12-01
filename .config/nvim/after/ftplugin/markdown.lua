if vim.b.my_plugin_markdown ~= nil then
	return
end
vim.b.my_plugin_markdown = true

-- ref: https://zenn.dev/vim_jp/articles/4564e6e5c2866d
vim.opt_local.comments = {
	"b:- [ ]",
	"b:- [x]",
	-- "b:1.",
	"b:*",
	"b:-",
	"b:+",
}

local fmt = vim.opt_local.formatoptions
fmt:remove("c")
fmt:append("jro")

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

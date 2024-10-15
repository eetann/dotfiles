vim.g.tex_flavor = "latex"
local group_name = "my_nvim_rc"

vim.filetype.add({
	extension = {
		mdx = "mdx",
	},
})

vim.filetype.add({
	pattern = {
		[".*%.blade%.php"] = "blade",
	},
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "qf", "help", "man" },
	callback = function()
		vim.cmd([[
      nnoremap <silent><buffer> q <Cmd>:quit<CR>
      set nobuflisted
    ]])
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "make" },
	callback = function()
		vim.opt_local.expandtab = false
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "cpp", "python", "php" },
	callback = function()
		vim.cmd([[
    setlocal sw=4 sts=4 ts=4
    ]])
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "css", "help" },
	callback = function()
		vim.cmd([[
    setlocal iskeyword+=-
    ]])
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "text", "qf", "quickrun", "markdown", "tex" },
	callback = function()
		vim.opt_local.wrap = true
	end,
})

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

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "markdown", "mdx" },
	callback = function()
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

		vim.api.nvim_buf_create_user_command(0, "MarkdownCheckbox", function(opts)
			markdown_checkbox(opts.line1, opts.line2)
		end, { range = true })
		-- Macだとcontrol + Enterに割当ができないので妥協
		vim.keymap.set(
			{ "n", "x" },
			"<C-x>",
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
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "json" },
	callback = function()
		vim.cmd([[
    syntax match Comment +\/\/.\+$+
    ]])
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "json5" },
	callback = function()
		vim.bo.commentstring = [[// %s]]
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "mdx" },
	callback = function()
		-- comment.luaで設定している
		-- vim.bo.commentstring = [[{/* %s */}]]
		vim.opt_local.wrap = true
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = group_name,
	pattern = { "*.tex" },
	callback = function()
		vim.opt_local.indentexpr = ""
	end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = group_name,
	pattern = { "*.csv" },
	callback = function()
		vim.opt_local.filetype = "csv"
	end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = group_name,
	pattern = { ".envrc" },
	callback = function()
		vim.opt_local.filetype = "sh"
	end,
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
	group = group_name,
	pattern = { "/tmp/*" },
	callback = function()
		vim.opt_local.wrap = true
	end,
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
	group = group_name,
	command = "startinsert",
})

-- gitcommit settings
local git_commit_prefixs = {
	{ word = "feat: ", menu = "機能追加", kind = "pre" },
	{ word = "fix: ", menu = "バグ修正", kind = "pre" },
	{ word = "docs: ", menu = "ドキュメント", kind = "pre" },
	{ word = "style: ", menu = "デザイン変更のみ", kind = "pre" },
	{ word = "refactor: ", menu = "リファクタリング ", kind = "pre" },
	{ word = "perf: ", menu = "パフォーマンス改善 ", kind = "pre" },
	{ word = "test: ", menu = "テスト関連の変更 ", kind = "pre" },
	{ word = "build: ", menu = "ビルドシステムの変更", kind = "pre" },
	{ word = "ci: ", menu = "CI関連の変更", kind = "pre" },
	{ word = "chore: ", menu = "その他の変更", kind = "pre" },
}

---@diagnostic disable-next-line: undefined-field
_G.complete_git_commit = function()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	if row == 1 and col == 0 then
		vim.fn.complete(col + 1, git_commit_prefixs)
	end
	return ""
end

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "gitcommit" },
	callback = function()
		vim.cmd("startinsert")
		vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-R>=v:lua.complete_git_commit()<CR>", true, true, true))
	end,
})

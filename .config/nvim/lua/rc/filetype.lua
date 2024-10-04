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
	pattern = { "cpp", "python" },
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

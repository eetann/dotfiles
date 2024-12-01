if vim.b.my_plugin_gitcommit ~= nil then
	return
end
vim.b.my_plugin_gitcommit = true

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

vim.cmd("startinsert")
vim.cmd("sleep 500ms")
vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-R>=v:lua.complete_git_commit()<CR>", true, true, true))

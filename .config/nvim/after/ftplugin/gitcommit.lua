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

vim.api.nvim_buf_create_user_command(0, "CompleteGitCommit", function()
	vim.cmd("startinsert")
	vim.cmd("sleep 500ms")
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	if row == 1 and col == 0 then
		vim.fn.complete(col + 1, git_commit_prefixs)
	end
end, {})

vim.keymap.set("n", "<C-g><C-g>", function()
	if vim.env.COMMIT_MESSAGE_ENGLISH == "1" then
		vim.cmd("Senpai commitMessage English")
	else
		vim.cmd("Senpai commitMessage Japanese")
	end
end, { buffer = true, desc = "コミットメッセージの生成" })

vim.keymap.set("n", "<C-g><C-c>", function()
	vim.api.nvim_create_autocmd("User", {
		pattern = "CodeCompanionDiffAttached",
		group = "my_nvim_rc",
		callback = function()
			vim.schedule(function()
				vim.cmd("normal ga")
			end)
		end,
	})
	if os.getenv("COMMIT_MESSAGE_ENGLISH") == "1" then
		vim.cmd("CodeCompanion /english-commit")
	else
		vim.cmd("CodeCompanion /japanese-commit")
	end
end, { buffer = true, desc = "コミットメッセージの生成" })

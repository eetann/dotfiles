if not vim.env.EDITPROMPT then
	return
end

vim.opt.wrap = true

vim.keymap.set("n", "<Space>E", function()
	vim.cmd("silent write")
	-- バッファの内容を取得
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local content = table.concat(lines, "\n")

	-- editpromptコマンドを実行
	vim.system(
		{ "bun", "run", vim.fn.expand("~/ghq/github.com/eetann/editprompt/dist/index.js"), "--", content },
		{ text = true },
		function(obj)
			vim.schedule(function()
				if obj.code == 0 then
					-- 成功したらバッファを空にする
					vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
				else
					-- 失敗したら通知
					vim.notify("editprompt failed: " .. (obj.stderr or "unknown error"), vim.log.levels.ERROR)
				end
			end)
		end
	)
end, { silent = true, desc = "Send buffer content to editprompt" })

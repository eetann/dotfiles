if vim.b.my_plugin_qf ~= nil then
	return
end
vim.b.my_plugin_qf = true

vim.bo.buflisted = false

vim.keymap.set("n", "q", "<CMD>quit<CR>", { silent = true, buffer = true })

-- 削除後は戻せない
-- ref: https://github.com/rmarganti/.dotfiles/blob/39574127c150bfada50bcaa9381fc2c95694cc6b/dots/.config/nvim/lua/rmarganti/core/autocommands.lua#L9-L53
local function delete_qf_items()
	local mode = vim.api.nvim_get_mode()["mode"]

	local start_idx
	local count

	if mode == "n" then
		-- Normal mode
		start_idx = vim.fn.line(".")
		count = vim.v.count > 0 and vim.v.count or 1
	else
		-- Visual mode
		local v_start_idx = vim.fn.line("v")
		local v_end_idx = vim.fn.line(".")

		start_idx = math.min(v_start_idx, v_end_idx)
		count = math.abs(v_end_idx - v_start_idx) + 1

		-- Go back to normal
		vim.api.nvim_feedkeys(
			vim.api.nvim_replace_termcodes(
				"<esc>", -- what to escape
				true, -- Vim leftovers
				false, -- Also replace `<lt>`?
				true -- Replace keycodes (like `<esc>`)?
			),
			"x", -- Mode flag
			false -- Should be false, since we already `nvim_replace_termcodes()`
		)
	end

	local qflist = vim.fn.getqflist()

	for _ = 1, count, 1 do
		table.remove(qflist, start_idx)
	end

	vim.fn.setqflist(qflist, "r")
	vim.fn.cursor(start_idx, 1)
end

vim.keymap.set("n", "dd", delete_qf_items, { buffer = true })
vim.keymap.set("x", "d", delete_qf_items, { buffer = true })

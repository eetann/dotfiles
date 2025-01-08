local M = {}

function M.insert_text_at_cursor(text)
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local current_line = vim.api.nvim_get_current_line()
	local new_line = current_line:sub(1, col) .. text .. current_line:sub(col + 1)
	vim.api.nvim_set_current_line(new_line)
	vim.api.nvim_win_set_cursor(0, { row, col + #text })
end

function M.get_visual_selection()
	vim.cmd('noau normal! "vy')
	---@diagnostic disable-next-line: missing-parameter
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ""
	end
end

return M

local M = {}

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

function M._multiopen(prompt_bufnr, open_cmd)
	local picker = action_state.get_current_picker(prompt_bufnr)
	if picker.manager:num_results() == 0 then
		actions.close(prompt_bufnr)
		do
			return
		end
	end
	local num_selections = #picker:get_multi_selection()
	if not num_selections or num_selections <= 1 then
		actions.add_selection(prompt_bufnr)
	end

	actions.close(prompt_bufnr)
	if open_cmd ~= "edit" then
		vim.api.nvim_command(open_cmd)
	end
	local cwd = picker.cwd
	if cwd == vim.fn.getcwd() then
		cwd = ""
	elseif cwd == nil then
		cwd = ""
	else
		cwd = cwd .. "/"
	end
	for _, entry in ipairs(picker:get_multi_selection()) do
		local filename, row, col

		if entry.filename then
			filename = entry.filename
			row = entry.row or entry.lnum
			col = entry.col
		elseif not entry.bufnr then
			local value = entry.value
			if not value then
				return
			end
			if type(value) == "table" then
				value = entry.display
			end

			local sections = vim.split(value, ":")
			filename = sections[1]
			row = tonumber(sections[2])
			col = tonumber(sections[3])
		end

		vim.api.nvim_command("edit" .. " " .. cwd .. filename)
		if row and col then
			vim.api.nvim_win_set_cursor(0, { row, col })
		end
	end
end

function M.multi_selection_open_vsplit(prompt_bufnr)
	M._multiopen(prompt_bufnr, "vsplit")
end

function M.multi_selection_open_split(prompt_bufnr)
	M._multiopen(prompt_bufnr, "split")
end

function M.multi_selection_open(prompt_bufnr)
	M._multiopen(prompt_bufnr, "edit")
end

return M

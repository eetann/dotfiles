local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local telescope_custom_actions = {}

function telescope_custom_actions._multiopen(prompt_bufnr, open_cmd)
	local picker = action_state.get_current_picker(prompt_bufnr)
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

function telescope_custom_actions.multi_selection_open_vsplit(prompt_bufnr)
	telescope_custom_actions._multiopen(prompt_bufnr, "vsplit")
end
function telescope_custom_actions.multi_selection_open_split(prompt_bufnr)
	telescope_custom_actions._multiopen(prompt_bufnr, "split")
end
function telescope_custom_actions.multi_selection_open(prompt_bufnr)
	telescope_custom_actions._multiopen(prompt_bufnr, "edit")
end

local function getVisualSelection()
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

local telescope = require("telescope")
telescope.setup({
	defaults = {
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			prompt_position = "top",
			preview_width = 0.5,
		},
	},
	pickers = {
		find_files = {
			mappings = {
				i = {
					["<esc>"] = actions.close,
					["<CR>"] = telescope_custom_actions.multi_selection_open,
					["<C-v>"] = telescope_custom_actions.multi_selection_open_vsplit,
					["<C-x>"] = telescope_custom_actions.multi_selection_open_split,
					["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				},
			},
		},
		git_files = {
			file_ignore_patterns = { "node_modules/", ".git/" },
			mappings = {
				i = {
					["<esc>"] = actions.close,
					["<CR>"] = telescope_custom_actions.multi_selection_open,
					["<C-v>"] = telescope_custom_actions.multi_selection_open_vsplit,
					["<C-x>"] = telescope_custom_actions.multi_selection_open_split,
				},
			},
		},
		live_grep = {
			mappings = {
				i = {
					["<esc>"] = actions.close,
					["<CR>"] = telescope_custom_actions.multi_selection_open,
					["<C-v>"] = telescope_custom_actions.multi_selection_open_vsplit,
					["<C-x>"] = telescope_custom_actions.multi_selection_open_split,
				},
			},
		},
	},
})

local telescope_custom = {
	project_files = function(text)
		local ok = pcall(require("telescope.builtin").git_files, { default_text = text })
		if not ok then
			require("telescope.builtin").find_files({ default_text = text, hidden = true })
		end
	end,
}

vim.keymap.set({ "n", "x" }, "[fzf-p]", "<Nop>")
vim.keymap.set({ "n", "x" }, "<Leader>f", "[fzf-p]")

vim.keymap.set("n", "[fzf-p]b", "<Cmd>Telescope buffers<CR>")
vim.keymap.set("n", "[fzf-p]h", "<Cmd>Telescope help_tags<CR>")
vim.keymap.set("n", "<F6>", "<Cmd>Telescope git_files cwd=~/dotfiles<CR>")

vim.keymap.set("n", "[fzf-p]f", function()
	telescope_custom.project_files("")
end)

vim.keymap.set("v", "[fzf-p]f", function()
	local text = getVisualSelection()
	telescope_custom.project_files(text)
end)

vim.keymap.set("n", "[fzf-p]g", function()
	require("telescope.builtin").live_grep()
end)

vim.keymap.set("v", "[fzf-p]g", function()
	local text = getVisualSelection()
	require("telescope.builtin").live_grep({ default_text = text })
end)

vim.keymap.set("n", "[fzf-p]t", function()
	require("telescope.builtin").live_grep({ default_text = "todo:" })
end)

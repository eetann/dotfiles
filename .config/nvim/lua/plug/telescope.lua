local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local telescope_custom_actions = {}

function telescope_custom_actions._multiopen(prompt_bufnr, open_cmd)
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
			width = 0.95,
			preview_width = 0.5,
		},
		file_ignore_patterns = {
			"git/",
			"node_modules/",
			"dist/",
			"dst/",
			".DS_Store",
			"%.jpg",
			"%.jpeg",
			"%.png",
			"%.svg",
			"%.gif",
			"%.zip",
			"%.o",
			"%.out",
		},
	},
	pickers = {
		find_files = {
			mappings = {
				i = {
					["<esc>"] = actions.close,
					["<C-c>"] = actions.close,
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
					["<C-c>"] = actions.close,
					["<CR>"] = telescope_custom_actions.multi_selection_open,
					["<C-v>"] = telescope_custom_actions.multi_selection_open_vsplit,
					["<C-x>"] = telescope_custom_actions.multi_selection_open_split,
					["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				},
			},
		},
		live_grep = {
			additional_args = function()
				return { "--hidden" }
			end,
			mappings = {
				i = {
					["<esc>"] = actions.close,
					["<C-c>"] = actions.close,
					["<CR>"] = telescope_custom_actions.multi_selection_open,
					["<C-v>"] = telescope_custom_actions.multi_selection_open_vsplit,
					["<C-x>"] = telescope_custom_actions.multi_selection_open_split,
					["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				},
			},
		},
	},
})

local telescope_custom = {
	project_files = function(text)
		local ok = pcall(require("telescope.builtin").git_files, { default_text = text, show_untracked = true })
		if not ok then
			require("telescope.builtin").find_files({ default_text = text, hidden = true })
		end
	end,
}

vim.keymap.set("n", "<Leader>fb", "<Cmd>Telescope buffers<CR>")
vim.keymap.set("n", "<Leader>fh", "<Cmd>Telescope help_tags<CR>")
vim.keymap.set("n", "<F6>", "<Cmd>Telescope git_files cwd=~/dotfiles<CR>")
vim.keymap.set("n", "<Leader>fl", "<Cmd>Telescope highlights<CR>")
vim.keymap.set("n", "<Leader>fd", "<Cmd>Telescope diagnostics<CR>")

vim.keymap.set("n", "<Leader>ff", function()
	telescope_custom.project_files("")
end)

vim.keymap.set("v", "<Leader>ff", function()
	local text = getVisualSelection()
	telescope_custom.project_files(text)
end)

vim.keymap.set("n", "<Leader>fg", function()
	require("telescope.builtin").live_grep()
end)

vim.keymap.set("v", "<Leader>fg", function()
	local text = getVisualSelection()
	require("telescope.builtin").live_grep({ default_text = text })
end)

vim.keymap.set("n", "<Leader>fG", function()
	require("telescope.builtin").live_grep({
		prompt_title = "Live Grep(no regexp)",
		additional_args = function()
			return { "--hidden", "--fixed-strings" }
		end,
	})
end)

vim.keymap.set("v", "<Leader>fG", function()
	local text = getVisualSelection()
	require("telescope.builtin").live_grep({
		prompt_title = "Live Grep(no regexp)",
		default_text = text,
		additional_args = function()
			return { "--hidden", "--fixed-strings" }
		end,
	})
end)

vim.keymap.set("n", "<Leader>ft", function()
	require("telescope.builtin").live_grep({ default_text = "todo:" })
end)

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local utils = require("plugins.telescope.utils")

local function process_markdown_file(filename)
	local file = io.open(filename, "r")
	if not file then
		return
	end
	local first_line = file:read("*l")
	file:close()
	local heading = first_line:match("^#%s+(.+)")
	if heading then
		local wikilink = "[[" .. filename .. "|" .. heading .. "]]"
		utils.insert_text_at_cursor(wikilink)
	end
end

local function process_entry(entry)
	local filename
	if entry.filename then
		filename = entry.filename
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
	end
	if filename:match("%.md$") then
		process_markdown_file(filename)
	end
end

local function insert_wikilink_from_telescope()
	require("telescope.builtin").live_grep({
		file_ignore_patterns = { ".index", ".pindex", ".git" },
		attach_mappings = function(prompt_bufnr, map)
			map("i", "<CR>", function()
				local picker = action_state.get_current_picker(prompt_bufnr)
				if picker.manager:num_results() == 0 then
					actions.close(prompt_bufnr)
					return
				end
				local num_selections = #picker:get_multi_selection()
				if not num_selections or num_selections <= 1 then
					actions.add_selection(prompt_bufnr)
				end
				actions.close(prompt_bufnr)
				for _, entry in ipairs(picker:get_multi_selection()) do
					process_entry(entry)
				end
			end)
			return true
		end,
	})
end

-- nbのディレクトリ配下でのみキーマップを設定
if vim.fn.getcwd():match("^" .. vim.fn.expand("~/.nb")) then
	vim.keymap.set("n", "<Leader>fw", function()
		insert_wikilink_from_telescope()
	end, { desc = "live greps wikilinkで書く(nb用)" })
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function show_codelens()
	vim.lsp.codelens.refresh({ bufnr = 0 })
	vim.cmd("sleep 1000m")
	local codelens = vim.lsp.codelens.get(0)

	if #codelens == 0 then
		vim.notify("No CodeLens available")
		return
	else
		local items = {}
		for _, lens in ipairs(codelens) do
			table.insert(items, {
				text = lens.command and lens.command.title or "No Command",
				lens = lens,
			})
		end

		pickers
			.new({}, {
				prompt_title = "LSP CodeLens",
				finder = finders.new_table({
					results = items,
					entry_maker = function(entry)
						return {
							value = entry.lens,
							display = entry.text,
							ordinal = entry.text,
						}
					end,
				}),
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						if selection and selection.value.command then
							vim.lsp.codelens.run(selection.value)
						end
					end)
					return true
				end,
			})
			:find()
	end
end

-- Lsp〇〇で統一する
vim.api.nvim_create_user_command("LspCodeLens", show_codelens, {})

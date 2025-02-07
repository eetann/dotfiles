local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- TODO: プラグインへ移行
local function show_lsp_capabilities()
	local clients = vim.lsp.get_clients()
	if #clients == 0 then
		vim.notify("No LSP clients attached", vim.log.levels.INFO)
		return
	end

	pickers
		.new({}, {
			prompt_title = "LSP Clients",
			finder = finders.new_table({
				results = vim.tbl_map(function(client)
					return {
						name = client.name,
						id = client.id,
						capabilities = client.server_capabilities,
					}
				end, clients),
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.name,
						ordinal = entry.name,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection and selection.value then
						local capabilities = vim.inspect(selection.value.capabilities)
						vim.notify(capabilities, vim.log.levels.INFO)
					end
				end)
				return true
			end,
		})
		:find()
end

-- Lsp〇〇で統一する
vim.api.nvim_create_user_command("LspCapabilities", show_lsp_capabilities, {})

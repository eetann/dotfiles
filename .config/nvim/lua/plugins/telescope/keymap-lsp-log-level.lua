local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- ログレベルのオプション
local log_levels = {
	"DEBUG",
	"INFO",
	"TRACE",
	"WARN",
	"ERROR",
	"OFF",
}

local function set_lsp_log_level()
	pickers
		.new({}, {
			prompt_title = "Select LSP Log Level",
			finder = finders.new_table({
				results = log_levels,
			}),
			attach_mappings = function()
				actions.select_default:replace(function(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					if selection then
						local log_level = selection[1]
						vim.lsp.set_log_level(log_level)
						print("LSP Log Level set to: " .. log_level)
					end
				end)
				return true
			end,
		})
		:find()
end

vim.api.nvim_create_user_command("SetLSPLogLevel", set_lsp_log_level, {})

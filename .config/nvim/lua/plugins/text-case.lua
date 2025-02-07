return {
	"johmsalas/text-case.nvim",
	dependencies = {
		"folke/snacks.nvim",
	},
	keys = {
		{ "gt", mode = { "n", "v" }, desc = "Picker: textcase" },
	},
	config = function()
		require("textcase").setup({})
		local plugin = require("textcase.plugin.plugin")
		local picker = require("snacks.picker")
		local constants = require("textcase.shared.constants")
		local api = require("textcase").api
		local api_list = {
			api.to_upper_case,
			api.to_lower_case,
			api.to_snake_case,
			api.to_dash_case,
			api.to_title_dash_case,
			api.to_constant_case,
			api.to_dot_case,
			api.to_comma_case,
			api.to_phrase_case,
			api.to_camel_case,
			api.to_pascal_case,
			api.to_title_case,
			api.to_path_case,
		}

		---@param mode string
		---@return snacks.picker.Item[]
		local function create_items(mode)
			---@type snacks.picker.Item[]
			local items = {}

			---@type { prefix: string, type: string }[]
			local conversion_dict = {}
			if mode ~= "n" then
				table.insert(conversion_dict, { prefix = "Convert to ", type = constants.change_type.VISUAL })
			else
				table.insert(conversion_dict, { prefix = "Convert to ", type = constants.change_type.CURRENT_WORD })
				table.insert(conversion_dict, { prefix = "Lsp rename ", type = constants.change_type.LSP_RENAME })
			end

			local i = 1
			for _, conversion in pairs(conversion_dict) do
				for _, method in pairs(api_list) do
					---@type snacks.picker.Item
					local item = {
						idx = i,
						score = 0,
						text = conversion.prefix .. method.desc,
						method_name = method.method_name,
						type = conversion.type,
					}
					table.insert(items, item)
					i = i + 1
				end
			end
			return items
		end

		---@type snacks.picker.Action.spec
		local function invoke_replacement(the_picker, item)
			the_picker:close()
			if item.type == constants.change_type.CURRENT_WORD then
				plugin.current_word(item.method_name)
			elseif item.type == constants.change_type.LSP_RENAME then
				plugin.lsp_rename(item.method_name)
			elseif item.type == constants.change_type.VISUAL then
				plugin.visual(item.method_name)
			end
		end

		vim.keymap.set({ "n", "v" }, "gt", function()
			local mode = vim.api.nvim_get_mode().mode
			picker({
				finder = function()
					return create_items(mode)
				end,
				confirm = invoke_replacement,
				format = "text",
				preview = "none",
				layout = { preset = "vscode" },
			})
		end, { desc = "Picker: textcase" })
	end,
}

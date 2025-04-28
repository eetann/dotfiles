---@type overseer.TemplateDefinition
return {
	name = "run this file",
	builder = function()
		local file = vim.fn.expand("%:p")
		vim.cmd("luafile %")
		---@type overseer.TaskDefinition
		return {
			cmd = { "echo" },
			args = { file },
			components = {
				{ "on_complete_notify", statuses = {} },
				{ "on_output_quickfix", open_on_exit = "failure" },
				"default",
			},
		}
	end,
	condition = {
		filetype = { "lua" },
	},
}

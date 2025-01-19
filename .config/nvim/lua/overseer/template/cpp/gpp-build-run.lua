---@type overseer.TemplateDefinition
return {
	name = "g++ build and run",
	builder = function()
		local outfile = vim.fn.expand("%:p:r") .. ".out"
		---@type overseer.TaskDefinition
		return {
			cmd = { outfile },
			components = {
				{
					"dependencies",
					task_names = { "g++ build only" },
				},
				{ "open_output", focus = true, direction = "vertical" },
				"default",
			},
		}
	end,
	condition = {
		filetype = { "cpp" },
	},
}

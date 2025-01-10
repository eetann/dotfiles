---@type overseer.TemplateDefinition
return {
	name = "g++ build only",
	builder = function()
		local file = vim.fn.expand("%:p")
		local outfile = vim.fn.expand("%:p:r") .. ".out"
		---@type overseer.TaskDefinition
		return {
			cmd = "g++",
			args = { file, "-o", outfile },
			components = {
				{ "on_exit_set_status", success_codes = { 0 } },
				{ "on_output_quickfix", open_on_exit = "failure" },
			},
		}
	end,
	condition = {
		filetype = { "cpp" },
	},
}

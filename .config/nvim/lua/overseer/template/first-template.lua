---@type overseer.TemplateDefinition
return {
	name = "First Template",
	builder = function()
		local file = vim.fn.expand("%")
		---@type overseer.TaskDefinition
		return {
			cmd = { "pwd" },
			cwd = vim.fn.expand("%:p:h"),
		}
	end,
}

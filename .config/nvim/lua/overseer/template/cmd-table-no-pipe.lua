---@type overseer.TemplateDefinition
return {
	name = "cmd table no pipe",
	builder = function()
		---@type overseer.TaskDefinition
		return {
			cmd = "echo foo | sed 's/f/o/'",
			-- cmd = { "echo foo | sed 's/f/o/'" },
		}
	end,
}

---@type overseer.TemplateDefinition
return {
	name = "bun run this file",
	builder = function()
		local file = vim.fn.expand("%:p")
		---@type overseer.TaskDefinition
		return {
			cmd = { "bun" },
			args = { "run", file },
			cwd = vim.fn.getcwd(),
			components = {
				"open_output",
				"default",
			},
		}
	end,
	condition = {
		callback = function()
			if vim.fn.filereadable("bun.lock") == 1 and vim.bo.filetype == "typescript" then
				return true
			end
			return false
		end,
	},
}

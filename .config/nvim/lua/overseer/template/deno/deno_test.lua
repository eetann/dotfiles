---@type overseer.TemplateDefinition
return {
	name = "deno test this file",
	builder = function()
		local file = vim.fn.expand("%:p")
		---@type overseer.TaskDefinition
		return {
			cmd = { "deno" },
			args = { "test", "-A", file },
			cwd = vim.fn.expand("%:p:h"),
			components = {
				"open_output",
				"default",
			},
		}
	end,
	condition = {
		callback = function()
			local denols = vim.iter(vim.lsp.get_clients({ bufnr = 0 })):find(function(c)
				return c.name == "denols"
			end)
			return not not denols
		end,
	},
}

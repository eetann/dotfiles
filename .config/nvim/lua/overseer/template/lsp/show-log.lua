---@type overseer.TemplateDefinition
return {
	name = "show lsp log",
	builder = function()
		vim.lsp.set_log_level("INFO")
		local logfile = vim.lsp.get_log_path()
		---@type overseer.TaskDefinition
		return {
			cmd = { "lnav" },
			args = { logfile },
			components = {
				{ "open_output", direction = "horizontal" },
				"default",
			},
		}
	end,
	priority = 1,
	condition = {
		dir = "~/ghq/github.com/eetann/markdown-language-server",
	},
}

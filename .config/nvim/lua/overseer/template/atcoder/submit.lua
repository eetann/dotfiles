---@type overseer.TemplateDefinition
return {
	name = "atcoder submit",
	builder = function()
		---@type overseer.TaskDefinition
		return {
			cmd = "acc",
			args = { "submit", "main.cpp", "--", "-y" },
			cwd = vim.fn.expand("%:p:h"),
			components = {
				{ "on_exit_set_status" },
				{ "open_output", direction = "vertical", on_complete = "failure", on_start = "never", focus = true },
			},
		}
	end,
	condition = {
		dir = "~/ghq/github.com/eetann/myatcoder",
	},
}

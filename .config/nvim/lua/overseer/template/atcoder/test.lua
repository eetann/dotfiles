---@type overseer.TemplateDefinition
return {
	name = "atcoder test",
	builder = function()
		---@type overseer.TaskDefinition
		return {
			cmd = "oj",
			args = { "test", "-d", "tests", "-c", "./main.out" },
			components = {
				{ "on_exit_set_status", success_codes = { 0 } },
				{ "on_output_quickfix", open = true },
			},
		}
	end,
	condition = {
		dir = "~/ghq/github.com/eetann/myatcoder",
	},
}

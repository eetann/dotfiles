---@type overseer.TemplateDefinition
return {
	name = "atcoder test and submit",
	builder = function()
		---@type overseer.TaskDefinition
		return {
			-- TODO: これだとsubmitが表示されないので修正する
			cmd = "",
			components = {
				{
					"dependencies",
					task_names = { "g++ build only", "atcoder test", "atcoder submit" },
				},
				{ "on_exit_set_status", success_codes = { 0 } },
				{ "on_output_quickfix", open_on_exit = "failure" },
			},
		}
	end,
	priority = 20,
	condition = {
		dir = "~/ghq/github.com/eetann/myatcoder",
	},
}

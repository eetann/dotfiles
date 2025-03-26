---@type overseer.TemplateDefinition
return {
	name = "MiniTest run this file",
	builder = function()
		local file = vim.fn.expand("%")
		---@type overseer.TaskDefinition
		return {
			cmd = { "nvim" },
			args = {
				"--headless",
				"--noplugin",
				"-u",
				"./scripts/test/minimal_init.lua",
				"-c",
				[["lua MiniTest.run_file(']]
					.. file
					.. [[', {execute = { reporter = MiniTest.gen_reporter.stdout() }})"]],
			},
			cwd = vim.fn.getcwd(),
			components = {
				{ "on_exit_set_status", success_codes = { 0 } },
				{ "on_complete_notify", statuses = {} },
				{ "on_output_quickfix", open_on_exit = "failure" },
				"default",
			},
		}
	end,
	condition = {
		callback = function()
			if vim.fn.expand("%"):match("test.*.lua") then
				return true
			end
			return false
		end,
	},
}

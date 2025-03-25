---@type overseer.TemplateDefinition
return {
	name = "MiniTest run this file",
	builder = function()
		vim.cmd("lua MiniTest.run_file()")
		---@type overseer.TaskDefinition
		return {
			cmd = { "echo" },
			args = { "MiniTest" },
			cwd = vim.fn.expand("%:p:h"),
			components = {
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

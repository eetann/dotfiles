---@type overseer.TemplateDefinition
return {
	name = "MiniTest run this file",
	builder = function()
		local file = vim.fn.expand("%")
		---@type overseer.TaskDefinition
		return {
			cmd = [[nvim --headless --noplugin -u ./scripts/test/minimal_init.lua -c "lua MiniTest.run_file(']]
				.. file
				.. [[')"]],
			cwd = vim.fn.getcwd(),
			components = {
				"open_output",
				{ "on_complete_notify", statuses = {} },
				"restart_on_save",
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

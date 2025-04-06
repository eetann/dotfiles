---@type overseer.TemplateDefinition
return {
	name = "MiniTest run at location",
	builder = function()
		local file = vim.fn.expand("%")
		local line = vim.fn.line(".")
		---@type overseer.TaskDefinition
		return {
			cmd = [[nvim --headless --noplugin -u ./scripts/test/minimal_init.lua -c "lua MiniTest.run_at_location]]
				.. [[({file = ']]
				.. file
				.. "',line="
				.. line
				.. [[})"]],
			cwd = vim.fn.getcwd(),
			components = {
				"open_output",
				{ "on_complete_notify", statuses = {} },
				"default",
			},
		}
	end,
	pronotify = 1,
	condition = {
		callback = function()
			if vim.fn.expand("%"):match("test.*.lua") then
				return true
			end
			return false
		end,
	},
}

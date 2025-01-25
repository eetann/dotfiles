---@type overseer.TemplateDefinition
return {
	name = "g++ debug build",
	builder = function()
		local file = vim.fn.expand("%:p")
		local outfile = vim.fn.expand("%:p:r") .. ".out"
		---@type overseer.TaskDefinition
		return {
			cmd = { "g++" },
			-- デバッグフラグgをつける
			args = { "-g", file, "-o", outfile },
			components = {
				{ "on_output_quickfix", open_on_exit = "failure" },
				"default",
			},
		}
	end,
	-- DapのpreLaunchTaskから自動呼ぶため、優先度は低い
	priority = 1000,
	condition = {
		filetype = { "cpp" },
	},
}

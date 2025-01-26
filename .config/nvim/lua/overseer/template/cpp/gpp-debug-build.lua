---@type overseer.TemplateDefinition
return {
	name = "g++ debug build",
	builder = function()
		local file = vim.fn.expand("%:p")
		local outfile = vim.fn.expand("%:p:r") .. ".out"
		---@type overseer.TaskDefinition
		return {
			cmd = { "g++" },
			-- デバッグフラグ-g、最適化無効-O0
			args = { "-g", "-O0", file, "-o", outfile },
			components = {
				{ "on_output_quickfix", open_on_exit = "failure" },
				-- 通知しない
				{ "on_complete_notify", statuses = {} },
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

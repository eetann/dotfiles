return {
	name = "g++ build and run",
	builder = function()
		-- Full path to current file (see :help expand())
		local file = vim.fn.expand("%:p")
		local outfile = vim.fn.expand("%:p:r") .. ".out"
		return {
			cmd = { outfile },
			components = {
				-- Note that since we're using the "raw task parameters" format for the dependency,
				-- we don't have to define a separate build task.
				{
					"dependencies",
					task_names = {
						{
							cmd = "g++",
							args = { file, "-o", outfile },
							components = {
								{ "on_exit_set_status", success_codes = { 0 } },
								{ "on_output_quickfix", open_on_exit = "failure" },
							},
						},
					},
				},
				{ "on_output_quickfix", open = true },
				"default",
			},
		}
	end,
	condition = {
		filetype = { "cpp" },
	},
}

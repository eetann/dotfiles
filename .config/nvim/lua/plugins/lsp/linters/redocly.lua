local lint = require("lint")

local severities = {
	warning = vim.diagnostic.severity.WARN,
	error = vim.diagnostic.severity.ERROR,
}
lint.linters.redocly = {
	name = "redocly",
	cmd = "pnpm",
	args = { "redocly", "lint", "--format", "checkstyle" },
	stdin = true, -- or false if it doesn't support content input via stdin. In that case the filename is automatically added to the arguments.
	stream = "stdout", -- ('stdout' | 'stderr' | 'both') configure the stream to which the linter outputs the linting result.
	ignore_exitcode = true, -- set this to true if the linter exits with a code != 0 and that's considered normal.
	parser = function(output)
		if output == "" then
			return {}
		end
		local target_filename = vim.fn.expand("%:.")
		local pattern = [[<error line="(%d+)" column="(%d+)" severity="(%w+)" message="(.+)" source="(.+)" />]]
		local lines = vim.fn.split(output, "\n")
		local inside_target_file = false
		---@type vim.Diagnostic[]
		local diagnostics = {}
		for _, line in ipairs(lines) do
			if line:find('<file name="') then
				inside_target_file = line:find(target_filename) ~= nil
			elseif inside_target_file then
				if line:find("<error") then
					local row, col, severity, message, source = string.match(line, pattern)
					table.insert(diagnostics, {
						message = message,
						lnum = row - 1,
						col = col - 1,
						severity = severities[severity],
						source = "redocly: " .. source,
					})
				elseif line:find("</file>") then
					break
				end
			end
		end
		return diagnostics
	end,
}
-- null-ls
-- local severities = {
-- 	warning = vim.diagnostic.severity.WARN,
-- 	error = vim.diagnostic.severity.ERROR,
-- }
--
-- return {
-- 	method = require("null-ls").methods.DIAGNOSTICS,
-- 	filetypes = { "yaml" },
--
-- 	generator = require("null-ls").generator({
-- 		ignore_stderr = true,
-- 		command = "pnpm",
-- 		args = { "redocly", "lint", "--format", "checkstyle" },
-- 		format = "raw",
-- 		multiple_files = true,
-- 		on_output = function(params, done)
-- 			local output = params.output
-- 			if output == nil or output == "" then
-- 				return done({})
-- 			end
-- 			local target_filename = vim.fn.expand("%:.")
-- 			local pattern = [[<error line="(%d+)" column="(%d+)" severity="(%w+)" message="(.+)" source="(.+)" />]]
-- 			local lines = vim.fn.split(output, "\n")
-- 			local inside_target_file = false
-- 			---@type vim.Diagnostic[]
-- 			local diagnostics = {}
-- 			for _, line in ipairs(lines) do
-- 				if line:find('<file name="') then
-- 					inside_target_file = line:find(target_filename) ~= nil
-- 				elseif inside_target_file then
-- 					if line:find("<error") then
-- 						local row, col, severity, message, source = string.match(line, pattern)
-- 						table.insert(diagnostics, {
-- 							message = message,
-- 							row = row,
-- 							col = col,
-- 							severity = severities[severity],
-- 							source = "redocly: " .. source,
-- 							bufnr = 0,
-- 						})
-- 					elseif line:find("</file>") then
-- 						break
-- 					end
-- 				end
-- 			end
-- 			return done(diagnostics)
-- 		end,
-- 	}),
-- }

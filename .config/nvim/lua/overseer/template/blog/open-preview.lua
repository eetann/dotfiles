return {
	name = "open blog preview",
	builder = function()
		vim.defer_fn(function()
			local basename = vim.fn.expand("%:t:r")
			vim.ui.open("http://localhost:4321/blog/" .. basename)
		end, 10)
		---@type overseer.TaskDefinition
		return {
			cmd = "",
		}
	end,
	condition = {
		dir = "~/ghq/github.com/eetann/cyber-blog",
	},
}

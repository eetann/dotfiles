local cmp = require("cmp")

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{
			name = "path",
			option = {
				get_cwd = function(params)
					-- NOTE: ZLEのedit-command-lineで使いやすいようにcwdを変更
					---@diagnostic disable-next-line: missing-parameter
					local dir_name = vim.fn.expand(("#%d:p:h"):format(params.context.bufnr))
					if dir_name == "/tmp" then
						-- body
						return vim.fn.getcwd()
					end
					return dir_name
				end,
			},
		},
		{
			name = "buffer",
			option = {
				get_bufnrs = function()
					return vim.api.nvim_list_bufs()
				end,
			},
		},
	}),
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline({
		["<C-k>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<BS>", true, false, true) .. "", "m", true)
				cmp.close()
				vim.cmd("sleep 100m")
				local last_char = string.sub(vim.fn.getcmdline(), -1)
				vim.api.nvim_feedkeys(last_char, "i", false)
			else
				fallback()
			end
		end, { "c" }),
	}),
	sources = cmp.config.sources({
		{
			name = "path",
			option = {
				get_cwd = function(params)
					-- NOTE: ZLEのedit-command-lineで使いやすいようにcwdを変更
					---@diagnostic disable-next-line: missing-parameter
					local dir_name = vim.fn.expand(("#%d:p:h"):format(params.context.bufnr))
					if dir_name == "/tmp" then
						-- body
						return vim.fn.getcwd()
					end
					return dir_name
				end,
			},
		},
	}, {
		{ name = "cmdline" },
	}),
})

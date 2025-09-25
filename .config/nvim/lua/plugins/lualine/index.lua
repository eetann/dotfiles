return {
	"nvim-lualine/lualine.nvim",
	cond = not vim.g.vscode,
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/noice.nvim" },
	event = "VeryLazy",
	config = function()
		vim.o.laststatus = 3
		vim.o.showmode = false
		vim.o.showcmd = true
		vim.o.ruler = true

		local function is_table_mode()
			local ok, is_active = pcall(vim.fn["tablemode#IsActive"])
			if not ok or is_active ~= 1 then
				return ""
			end
			return "TABLE"
		end

		-- https://zenn.dev/glaucus03/articles/ff710d27de4e55
		local function selectionCount()
			local mode = vim.fn.mode()
			local start_line, end_line, start_pos, end_pos

			-- 選択モードでない場合には無効
			if not (mode:find("[vV\22]") ~= nil) then
				return ""
			end
			start_line = vim.fn.line("v")
			end_line = vim.fn.line(".")

			if mode == "V" then
				-- 行選択モードの場合は、各行全体をカウントする
				start_pos = 1
				end_pos = vim.fn.strlen(vim.fn.getline(end_line)) + 1
			else
				start_pos = vim.fn.col("v")
				end_pos = vim.fn.col(".")
			end

			local chars = 0
			for i = start_line, end_line do
				local line = vim.fn.getline(i)
				local line_len = vim.fn.strlen(line)
				local s_pos = (i == start_line) and start_pos or 1
				local e_pos = (i == end_line) and end_pos or line_len + 1
				chars = chars + vim.fn.strchars(line:sub(s_pos, e_pos - 1))
			end

			local lines = math.abs(end_line - start_line) + 1
			return tostring(lines) .. " lines, " .. tostring(chars) .. " characters"
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "powerline",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					winbar = {
						"dap-repl",
						"dapui_breakpoints",
						"dapui_console",
						"dapui_scopes",
						"dapui_watches",
						"dapui_stacks",
						"Avante",
						"AvanteSelectedFiles",
						"AvanteInput",
						"senpai_chat_log",
						"senpai_chat_input",
						"senpai_ai_buffer",
						"snacks_layout_box",
					},
				},
				always_divide_middle = true,
				globalstatus = true,
			},
			sections = {
				lualine_a = {
					"mode",
					[[vim.o.paste and 'PASTE' or '']],
					is_table_mode,
				},
				lualine_b = { "branch", "diff" },
				lualine_c = {
					{
						"filename",
						file_status = true, -- readonly, modified
						path = 1, -- Relative path
						shorting_target = 40,
						symbols = {
							modified = " ●",
							readonly = " ",
							unnamed = "[No Name]",
						},
						cond = function()
							return not vim.env.EDITPROMPT
						end,
					},
				},
				lualine_x = {
					{
						-- for `@recording messsages`
						---@diagnostic disable-next-line: undefined-field
						require("noice").api.status.mode.get,
						---@diagnostic disable-next-line: undefined-field
						cond = require("noice").api.status.mode.has,
						color = { fg = "#ff9e64" },
					},
					{
						-- https://www.reddit.com/r/neovim/comments/1aseug5/comment/kqq026j
						function()
							return require("dap").status()
						end,
						icon = { "", color = { fg = "#afdf00" } },
						cond = function()
							if not package.loaded.dap then
								return false
							end
							local session = require("dap").session()
							return session ~= nil
						end,
					},
					"overseer",
					selectionCount,
					"location",
				},
				lualine_y = {
					"encoding",
					"fileformat",
					"filetype",
				},
				lualine_z = {
					{ require("plugins.lualine.cc-component") },
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			winbar = {
				-- lspsagaのwinbarは被って見づらくなる & そもそも活用していないので非表示へ
				lualine_a = {},
				lualine_b = {
					{
						"diagnostics",
						sources = { "nvim_lsp" },
						cond = function()
							return not vim.env.EDITPROMPT
						end,
					},
				},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					{
						"filetype",
						icon_only = true,
						cond = function()
							return not vim.env.EDITPROMPT
						end,
					},
					{
						"filename",
						path = 1,
						newfile_status = true,
						symbols = {
							modified = "● ",
							readonly = "󰌾 ",
						},
						cond = function()
							return not vim.env.EDITPROMPT
						end,
					},
				},
			},
			inactive_winbar = {
				lualine_a = {
					{
						"diagnostics",
						sources = { "nvim_lsp" },
						cond = function()
							return not vim.env.EDITPROMPT
						end,
					},
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {
					{
						"filetype",
						icon_only = true,
						cond = function()
							return not vim.env.EDITPROMPT
						end,
					},
				},
				lualine_z = {
					{
						"filename",
						path = 1,
						newfile_status = true,
						symbols = {
							modified = "● ",
							readonly = "󰌾 ",
						},
						cond = function()
							return not vim.env.EDITPROMPT
						end,
					},
				},
			},
			tabline = {},
			extensions = {},
		})
		-- transparent
		vim.cmd("highlight lualine_c_inactive guibg=NONE")
		vim.cmd("highlight lualine_c_normal guibg=NONE")
	end,
}

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		{ "rcarriga/nvim-notify", opts = { top_down = false, stages = "static" } },
	},
	config = function()
		local noice = require("noice")

		local function myMiniView(pattern, kind)
			kind = kind or ""
			return {
				view = "mini",
				filter = {
					event = "msg_show",
					kind = kind,
					find = pattern,
				},
			}
		end

		local function skipMessage(pattern, event, kind)
			return {
				filter = {
					event = event or "notify",
					kind = kind,
					find = pattern,
				},
				opts = { skip = true },
			}
		end

		noice.setup({
			presets = {
				bottom_search = false, -- use a classic bottom cmdline for search
				command_palette = false, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
			cmdline = {
				format = {
					myhelp = {
						pattern = "^:%s*belowright vertical help%s+",
						icon = "",
						title = "help (open to the right)",
					},
				},
			},
			messages = {
				view_search = false,
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				skipMessage("failed to run generator.*is not executable"),
				skipMessage("no matching language servers"),
				skipMessage("is not supported by any of the servers registered for the current buffer"),
				skipMessage("query: invalid node type"),
				skipMessage("No code actions available", "info"),
				skipMessage("DiagnosticChanged Autocommands for.*Invalid", "msg_show"),
				myMiniView("Already at .* change"),
				myMiniView("written"),
				myMiniView("yanked"),
				myMiniView("more lines?"),
				myMiniView("fewer lines?"),
				myMiniView("fewer lines?", "lua_error"),
				myMiniView("change;%sbefore"),
				myMiniView("change;%safter"),
				myMiniView("line less"),
				myMiniView("lines indented"),
				myMiniView("No lines in buffer"),
				myMiniView("search hit .*, continuing at", "wmsg"),
				myMiniView("E486: Pattern not found", "emsg"),
				{
					view = "notify",
					filter = { event = "msg_show", kind = "echo", find = "%(mini%.align%)" },
					opts = { title = "mini.align", replace = true, timeout = 10 * 1000 },
				},
			},
		})

		vim.cmd("highlight! link LspSignatureActiveParameter @text.warning")

		vim.keymap.set("i", "<C-g>d", function()
			require("noice.lsp.docs").get("signature"):focus()
		end, { desc = "Focus noice docs" })
		vim.keymap.set("n", "<Space>nd", function()
			vim.cmd("NoiceDismiss")
		end, { desc = "NoiceDismiss" })
	end,
}

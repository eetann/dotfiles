---@module "blink-cmp"
---@type blink.cmp.KeymapConfig
return {
	preset = "super-tab",
	["<C-u>"] = { "scroll_documentation_up", "fallback" },
	["<C-d>"] = { "scroll_documentation_down", "fallback" },
	["<C-b>"] = {},
	["<C-f>"] = {},
	-- 補完候補を無視して、もっとも優先度の高いスニペットを展開する
	["<C-y>"] = {
		function(cmp)
			if require("luasnip").expandable() then
				cmp.hide()
				vim.schedule(function()
					require("luasnip").expand()
				end)
				return true
			end
			return false
		end,
		"fallback",
	},
	-- 先頭の大文字小文字を切り替えて補完
	["<C-v>"] = {
		function(cmp)
			cmp.accept()
			vim.schedule(function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>mzBvg~`za", true, false, true), "in", false)
			end)
		end,
	},
	-- setState, defaultDate のような prefixの後に続く所を書く時に使う
	["<C-g>"] = {
		function(cmp)
			cmp.cancel()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "in", false)
			vim.schedule(function()
				vim.ui.input({ prompt = "Enter keyword: " }, function(text)
					if not text or text == "" then
						return
					end
					text = text:sub(1, 1):upper() .. text:sub(2)
					local row, col = unpack(vim.api.nvim_win_get_cursor(0))
					vim.api.nvim_buf_set_text(0, row - 1, col + 1, row - 1, col + 1, { text })
					vim.cmd("normal " .. #text .. "l")
				end)
			end)
		end,
	},
}

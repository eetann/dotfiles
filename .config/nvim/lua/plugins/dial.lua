---@module "lazy"
---@type LazyPluginSpec
return {
	"monaqa/dial.nvim",
	keys = {
		{
			"<C-a>",
			function()
				require("dial.map").manipulate("increment", "normal")
			end,
			mode = "n",
		},
		{
			"<C-x>",
			function()
				require("dial.map").manipulate("decrement", "normal")
			end,
			mode = "n",
		},
		-- normalのg<C-a>では、ドットリピートでの操作時のみインクリメント
		{
			"g<C-a>",
			function()
				require("dial.map").manipulate("increment", "gnormal")
			end,
			mode = "n",
		},
		{
			"g<C-x>",
			function()
				require("dial.map").manipulate("decrement", "gnormal")
			end,
			mode = "n",
		},
		{
			"<C-a>",
			function()
				require("dial.map").manipulate("increment", "visual")
			end,
			mode = "v",
		},
		{
			"<C-x>",
			function()
				require("dial.map").manipulate("decrement", "visual")
			end,
			mode = "v",
		},
		{
			"g<C-a>",
			function()
				require("dial.map").manipulate("increment", "gvisual")
			end,
			mode = "v",
		},
		{
			"g<C-x>",
			function()
				require("dial.map").manipulate("decrement", "gvisual")
			end,
			mode = "v",
		},
		{
			"<C-q>",
			function()
				require("dial.map").manipulate("increment", "normal", "checkbox")
			end,
			ft = { "markdown", "mdx" },
			desc = "チェックボックスのトグル",
		},
	},
	config = function()
		local augend = require("dial.augend")
		require("dial.config").augends:register_group({
			-- default augends used when no group name is specified
			default = {
				augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
				augend.constant.alias.bool,
				augend.constant.alias.ja_weekday,
				augend.date.alias["%Y/%m/%d"],
				augend.date.alias["%Y-%m-%d"],
				augend.date.alias["%Y年%-m月%-d日"],
				augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
				augend.constant.new({
					elements = { "xs", "sm", "md", "lg", "xl", "2xl", "3xl" },
					word = false,
					cyclic = false,
				}),
			},
			checkbox = {
				-- チェックボックスのトグル（なし→[ ]→[x]→なし）
				augend.user.new({
					---@type fun(line: string, cursor?: integer): textrange?
					find = function(line)
						-- リストアイテムの行を検索
						local list_pattern = "^%s*[-+*] "
						local list_start, list_end = line:find(list_pattern)
						if list_start == nil or list_end == nil then
							return
						end

						-- チェックボックスがある場合
						local checkbox_start = line:find("%[", list_end)
						if checkbox_start and checkbox_start == list_end + 1 then
							-- チェックボックスの後のスペースも含める
							local checkbox_end = checkbox_start + 2
							return { from = checkbox_start, to = checkbox_end + 1 } --[[@as textrange]]
						end

						-- チェックボックスがない場合（リストアイテムの直後の位置を返す）
						return { from = list_end + 1, to = list_end } --[[@as textrange]]
					end,
					---@type fun(self: Augend, text: string, addend: integer, cursor?: integer): addresult
					add = function(text)
						if text == "" then
							-- チェックボックスなし → [ ]
							return { text = "[ ] ", cursor = 4 } --[[@as addresult]]
						elseif text == "[ ]" or text == "[ ] " then
							-- [ ] → [x]
							return { text = "[x] " } --[[@as addresult]]
						elseif text == "[x]" or text == "[x] " then
							-- [x] → チェックボックスなし（削除）
							return { text = "", cursor = 0 } --[[@as addresult]]
						end
						return {}
					end,
				}),
			},
		})
	end,
}

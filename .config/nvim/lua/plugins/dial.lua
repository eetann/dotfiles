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

						-- リストアイテムの場合
						if list_start ~= nil and list_end ~= nil then
							-- チェックボックスがある場合
							local checkbox_start = line:find("%[", list_end)
							if checkbox_start and checkbox_start == list_end + 1 then
								-- チェックボックスの後のスペースも含める
								local checkbox_end = checkbox_start + 2
								return { from = checkbox_start, to = checkbox_end + 1 } --[[@as textrange]]
							end
							-- チェックボックスがない場合（リストアイテムの直後の位置を返す）
							return { from = list_end + 1, to = list_end } --[[@as textrange]]
						end

						-- リストアイテムじゃない場合（行の先頭を返す）
						local first_non_space = line:match("^%s*()")
						if first_non_space then
							return { from = first_non_space, to = first_non_space - 1 } --[[@as textrange]]
						end
						return { from = 1, to = 0 } --[[@as textrange]]
					end,
					---@type fun(self: Augend, text: string, addend: integer, cursor?: integer): addresult
					add = function(text, addend, cursor)
						-- カーソル位置の行全体を取得するためのハック
						-- （textは選択範囲の文字列だけなので、行全体の情報が必要）
						local line = vim.api.nvim_get_current_line()
						local list_pattern = "^%s*[-+*] "
						local is_list = line:find(list_pattern) ~= nil

						if is_list then
							-- リストアイテムの場合の既存処理
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
						else
							-- リストアイテムじゃない場合
							-- 行頭のインデントを取得
							local indent = line:match("^(%s*)")
							-- 元のテキストを取得（インデント以降）
							local content = line:sub(#indent + 1)
							-- チェックボックス付きリストに変換
							return { text = "- [ ] " .. content, cursor = 6 + #content } --[[@as addresult]]
						end
						return {}
					end,
				}),
			},
		})
	end,
}

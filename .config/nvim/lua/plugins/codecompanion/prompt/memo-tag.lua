---@type CompanionPrompt
return {
	strategy = "workflow",
	description = "write tags for memo",
	condition = function()
		return vim.fn.getcwd():match("^" .. vim.fn.expand("~/.nb"))
	end,
	opts = {
		mapping = "<space>ct",
		ignore_system_prompt = true,
		is_slash_cmd = true,
		short_name = "memo-tag",
		auto_submit = true,
		placement = "replace",
	},
	prompts = {
		{
			{
				role = "user",
				content = function()
					return [[
次の手順・使用例に従って処理を実行してください。

### 手順

1. @editor メモ #buffer の主題を解析し、適切な内容タグを5つまで提案する。
2. @files 提案するタグは`./tags.md`から取得するか、新しいタグを自動生成する。
3. 新しいタグを生成する際、まず既存タグの類似・同義タグを`tags.md`でチェックする。
4. 新しいタグ生成のルール:
   - 小文字の半角アルファベット、半角数字、半角ハイフン`-`を使用。
   - 基本的に単数形を使用。
   - 内容タグに限定。
5. タグとして認められない例:
   - 状態タグ（例：`#未整理`、`#要修正`）
   - 時間タグ（例：`#2023`、`#Q1`）
   - 場所タグ（例：`#東京`、`#オフィス`）
6. メモの1行目と2行目の間にタグを空白で区切って書き込む。
7. 新タグが生成された場合は`./tags.md`に追加する。

### 使用例

#### 実行前
##### メモ
```markdown
# NeovimのLuaSnipの使い方
- とりあえず`fmt`を使えば良さそう
```

##### tags.md
```markdown
# Tags

- ai
- neovim
- crx
- ios
- android
```

#### 実行後
##### メモ
```markdown
# NeovimのLuaSnipの使い方
#neovim #luasnip
- とりあえず`fmt`を使えば良さそう
```

##### tags.md
```markdown
# Tags

- ai
- neovim
- crx
- ios
- android
- luasnip
```
]]
				end,
				opts = {
					contains_code = true,
					auto_submit = true,
				},
			},
		},
	},
}

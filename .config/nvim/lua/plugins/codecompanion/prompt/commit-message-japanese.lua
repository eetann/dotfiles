---@type CompanionPrompt
return {
	strategy = "inline",
	description = "Generate Japanese commit message",
	opts = {
		is_slash_cmd = true,
		short_name = "japanese-commit",
		auto_submit = true,
		placement = "replace",
	},
	prompts = {
		{
			role = "system",
			content = "You are an expert at following the Conventional Commit specification.",
		},
		{
			role = "user",
			content = function()
				local git_diff = vim.fn.system("git diff --no-ext-diff --staged")

				return [[
あなたの使命は、commitizenコミット規約に従って、変更内容と主に変更理由を説明する、クリーンで包括的なコミットメッセージを作成することです。
合計80文字以内に収めるようにしてください。
コミットのサブカテゴリ（`fix(deps):`）ではなく、カテゴリ（`fix:`）のみを指定してください。
ステージされたgit diff: ```
]] .. git_diff .. [[
```.
コミットメッセージの後に改行を追加し、変更理由を1〜4文で簡潔に説明してください。
「このコミット」のような主語で始めず、変更を説明してください。
現在形を使用してください。
行は74文字を超えないようにしてください。
コミットメッセージの本文は日本語で書いてください。

]]
			end,
			opts = {
				contains_code = true,
			},
		},
	},
}

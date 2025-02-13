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
Your mission is to create clean and comprehensive commit messages as per the conventional commit convention and explain WHAT were the changes and mainly WHY the changes were done.
Try to stay below 80 characters total.
Don't specify the commit subcategory (`fix(deps):`), just the category (`fix:`).
Staged git diff: ```
]] .. git_diff .. [[
```.
After an additional newline, add a short description in 1 to 4 sentences of WHY the changes are done after the commit message.
Don't start it with "This commit", just describe the changes.
Use the present tense.
Lines must not be longer than 74 characters.
Write the commit message in Japanese.

]]
			end,
			opts = {
				contains_code = true,
			},
		},
	},
}

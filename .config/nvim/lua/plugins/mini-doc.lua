return {
	"echasnovski/mini.doc",
	-- 開発プラグイン側でclone・setupしているが
	-- ヘルプを見たいのでプラグインマネージャー側でも追加
	cmd = "MiniDocHelp",
	config = function()
		-- プラグインとしては使わないのでsetupはしない
		vim.api.nvim_create_user_command("MiniDocHelp", ":belowright vertical help mini.doc", {})
	end,
}

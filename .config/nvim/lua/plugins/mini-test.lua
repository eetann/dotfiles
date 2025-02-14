return {
	"echasnovski/mini.test",
	-- 開発プラグイン側でclone・setupしているが
	-- ヘルプを見たい＆補完のためにプラグインマネージャー側でも追加
	ft = "lua",
	config = function()
		-- プラグインとしては使わないのでsetupはしない
		vim.api.nvim_create_user_command("MiniTestHelp", ":belowright vertical help mini.test", {})
	end,
}

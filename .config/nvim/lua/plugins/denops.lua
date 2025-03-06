return {
	"vim-denops/denops.vim",
	-- 開発プラグイン側でclone・setupしているが
	-- ヘルプを見たいのでプラグインマネージャー側でも追加
	cmd = "DenopsHelp",
	config = function()
		-- プラグインとしては使わないのでsetupはしない
		vim.api.nvim_create_user_command("DenopsHelp", ":belowright vertical help denops", {})
	end,
}

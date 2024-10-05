-- local util = require("lspconfig.util")

---@type lspconfig.Config
return {
	-- root_dir = util.root_pattern("package.json", "node_modules"),
	-- opts.autostart = detected_root_dir(root_dir)
	on_new_config = function(new_config)
		-- プロジェクトのTypeScriptが古すぎてLSPが動かないとき、グローバルな方を優先させる
		-- 環境変数TS_LS_GLOBAL=1のときのみ実行
		-- miseの場合は以下
		-- mise set TS_LS_GLOBAL=1
		-- mise trust
		if os.getenv("TS_LS_GLOBAL") == "1" then
			new_config.init_options = {
				tsserver = {
					path = vim.fn.expand("~/.local/share/pnpm/global/5/node_modules/typescript/lib"),
				},
			}
		end
	end,
}

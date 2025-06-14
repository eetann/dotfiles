local util = require("lspconfig.util")
local server_path = vim.fn.expand("~/.local/share/pnpm/global/5")

-- ref: https://www.reddit.com/r/neovim/comments/18ywqvp/angular_lsp_configuration_errors/
local cmd = {
	"ngserver",
	"--stdio",
	"--tsProbeLocations",
	table.concat({
		server_path,
		vim.uv.cwd(),
	}, ","),
	"--ngProbeLocations",
	table.concat({
		server_path,
		vim.uv.cwd(),
	}, ","),
	"--includeCompletionsWithSnippetText",
	"--includeAutomaticOptionalChainCompletions",
}

---@type vim.lsp.Config
return {
	-- 古すぎてangularのLSPのバージョンと合わない？のもあるっぽいので環境変数で抑制
	root_dir = function(fname)
		if os.getenv("ANGULAR_LS_DISABLE") == "1" then
			---@diagnostic disable-next-line: redundant-return-value
			return nil
		end
		---@diagnostic disable-next-line: redundant-return-value
		return util.root_pattern("angular.json")(fname)
	end,
	cmd = cmd,
}

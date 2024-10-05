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

---@type lspconfig.Config
return {
	-- TODO:angular.jsonが無いプロジェクトはどうなっている???調査
	root_dir = util.root_pattern("angular.json", "package.json"),
	cmd = cmd,
	on_new_config = function(new_config)
		new_config.cmd = cmd
	end,
}

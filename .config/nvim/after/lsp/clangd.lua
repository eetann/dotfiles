---@type vim.lsp.Config
return {
	cmd = {
		"clangd",
		"--clang-tidy", -- code check
	},
	filetypes = { "c", "cpp", "objc", "objcpp" },
}

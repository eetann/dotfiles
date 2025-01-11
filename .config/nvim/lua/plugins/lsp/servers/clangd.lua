---@type lspconfig.Config
return {
	cmd = {
		"clangd",
		"--clang-tidy", -- code check
	},
	filetypes = { "c", "cpp", "objc", "objcpp" },
}

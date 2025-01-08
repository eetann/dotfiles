if vim.b.my_plugin_mdx ~= nil then
	return
end
vim.b.my_plugin_mdx = true

vim.cmd.runtime({ "after/ftplugin/markdown.lua", bang = true })

vim.opt_local.wrap = true

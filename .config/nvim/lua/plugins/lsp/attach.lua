vim.api.nvim_create_autocmd("LspAttach", {
	group = "my_nvim_rc",
	callback = function(ev)
		local bufopts = { noremap = true, silent = true, buffer = ev.buf }
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
		vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", bufopts)
		vim.keymap.set("n", "gd", function()
			-- 書き込みが走るとlivereloadなどで面倒なので一旦止める
			-- vim.api.nvim_create_autocmd("CursorMoved", {
			-- 	once = true,
			-- 	callback = function()
			-- 		local bufnr = vim.api.nvim_get_current_buf()
			-- 		local absolute_path = vim.api.nvim_buf_get_name(bufnr)
			-- 		local relative_path = vim.fn.fnamemodify(absolute_path, ":.")
			-- 		vim.api.nvim_buf_set_name(bufnr, relative_path)
			-- 		-- `E13: File exists`が出てしまうので、サイレントで書き込み
			-- 		--   書き込み時のフォーマットは一時的に止めておく
			-- 		local buf_disable_autoformat = vim.b.disable_autoformat
			-- 		vim.b.disable_autoformat = false
			-- 		vim.cmd("silent! write!")
			-- 		vim.b.disable_autoformat = buf_disable_autoformat
			-- 	end,
			-- })
			vim.lsp.buf.definition()
		end, bufopts)
		vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
		vim.keymap.set("n", "gp", "<cmd>Lspsaga peek_definition<CR>", bufopts)
		vim.keymap.set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", bufopts)
		vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", bufopts)
		vim.keymap.set("n", "<C-g>", "<cmd>Lspsaga hover_doc<CR>", bufopts)
		vim.keymap.set("i", "<C-g>h", "<cmd>Lspsaga hover_doc<CR>", bufopts)
		vim.keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", bufopts)
		vim.keymap.set("n", "gh", "<cmd>Lspsaga hover_doc<CR>", bufopts)
		vim.keymap.set("n", "<leader>cr", "<cmd>Lspsaga rename<CR>", bufopts)
		vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", bufopts)
		vim.keymap.set("n", "<leader>cc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", bufopts)
		vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", bufopts)
		vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", bufopts)
	end,
})

-- vim.lsp.log.set_format_func(function(item)
-- 	return (vim.inspect(item):gsub("[\r\n]+", ""))
-- end)

vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd(string.format("edit %s", vim.lsp.get_log_path()))
end, {
	desc = "Opens the Nvim LSP client log.",
})

vim.api.nvim_create_user_command("LspInfo", function()
	vim.cmd("vertical checkhealth lspconfig")
end, {})

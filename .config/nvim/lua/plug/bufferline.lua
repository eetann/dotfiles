require("bufferline").setup({
	options = {
		right_mouse_command = nil,
	},
})

local map = vim.keymap.set
local opts = {}

-- Move to previous/next
map("n", "[b", ":BufferLineCyclePrev<CR>", opts)
map("n", "]b", ":BufferLineCycleNext<CR>", opts)
-- Re-order to previous/next
map("n", "[B", ":BufferLineMovePrev<CR>", opts)
map("n", "]B", " :BufferLineMoveNext<CR>", opts)
-- Goto buffer in position...
map("n", "<Space>1", "<Cmd>BufferLineGoToBuffer 1<CR>", opts)
map("n", "<Space>2", "<Cmd>BufferLineGoToBuffer 2<CR>", opts)
map("n", "<Space>3", "<Cmd>BufferLineGoToBuffer 3<CR>", opts)
map("n", "<Space>4", "<Cmd>BufferLineGoToBuffer 4<CR>", opts)
map("n", "<Space>5", "<Cmd>BufferLineGoToBuffer 5<CR>", opts)
map("n", "<Space>6", "<Cmd>BufferLineGoToBuffer 6<CR>", opts)
map("n", "<Space>7", "<Cmd>BufferLineGoToBuffer 7<CR>", opts)
map("n", "<Space>8", "<Cmd>BufferLineGoToBuffer 8<CR>", opts)
map("n", "<Space>9", "<Cmd>BufferLineGoToBuffer 9<CR>", opts)
map("n", "<Space>0", "<Cmd>BufferLineGoToBuffer -1<CR>", opts)

map("n", "sq", function()
	local now_bufnr = vim.fn.bufnr()
	vim.cmd([[BufferLineCycleNext]])
	vim.cmd(("bdelete %d"):format(now_bufnr))
end, { desc = "Close current buffer without closing the current window" })
map("n", "sQ", function()
	local now_bufnr = vim.fn.bufnr()
	vim.cmd([[BufferLineCycleNext]])
	vim.cmd(("bdelete! %d"):format(now_bufnr))
end, { desc = "Close! current buffer without closing the current window" })
map("n", "<Space><Space>", ":BufferLinePick<CR>", opts)

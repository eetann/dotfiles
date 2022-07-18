local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map("n", "[b", ":BufferPrevious<CR>", opts)
map("n", "]b", ":BufferNext<CR>", opts)
-- Re-order to previous/next
map("n", "[B", ":BufferMovePrevious<CR>", opts)
map("n", "]B", " :BufferMoveNext<CR>", opts)
-- Goto buffer in position...
map("n", "<Space>1", ":BufferGoto 1<CR>", opts)
map("n", "<Space>2", ":BufferGoto 2<CR>", opts)
map("n", "<Space>3", ":BufferGoto 3<CR>", opts)
map("n", "<Space>4", ":BufferGoto 4<CR>", opts)
map("n", "<Space>5", ":BufferGoto 5<CR>", opts)
map("n", "<Space>6", ":BufferGoto 6<CR>", opts)
map("n", "<Space>7", ":BufferGoto 7<CR>", opts)
map("n", "<Space>8", ":BufferGoto 8<CR>", opts)
map("n", "<Space>9", ":BufferGoto 9<CR>", opts)
map("n", "<Space>0", ":BufferLast<CR>", opts)

map("n", "sq", ":BufferClose<CR>", opts)
map("n", "<Space><Space>", ":BufferPick<CR>", opts)

vim.g.bufferline = {
	animation = true,
	auto_hide = false,
	tabpages = true,
	closable = true,
	clickable = true,

	icons = true,
	icon_custom_colors = false,
	icon_separator_active = "▎",
	icon_separator_inactive = "▎",
	icon_close_tab = "x",
	icon_close_tab_modified = "●",
	icon_pinned = "車",

	insert_at_end = false,
	insert_at_start = false,

	maximum_padding = 2,
	maximum_length = 30,
	semantic_letters = true,
	letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",
	no_name_title = "[no name]",
}

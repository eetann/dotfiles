local mopt = { noremap = true, silent = true }
vim.g.caw_dollarpos_sp_left = " "
-- TODO: コメントアウト時にカーソル位置を移動しない
vim.keymap.set("n", "gc", "<Plug>(caw:prefix)", mopt)
vim.keymap.set("n", "gcc", "<Plug>(caw:hatpos:toggle)", mopt)
vim.keymap.set("x", "gcc", "<Plug>(caw:hatpos:toggle)", mopt)
vim.keymap.set("n", "<C-_>", "<Plug>(caw:hatpos:toggle)", mopt)
vim.keymap.set("n", "gci", "<Plug>(caw:hatpos:comment)", mopt)
vim.keymap.set("n", "gcui", "<Plug>(caw:hatpos:uncomment)", mopt)
vim.keymap.set("n", "gcI", "<Plug>(caw:zeropos:comment)", mopt)
vim.keymap.set("n", "gcuI", "<Plug>(caw:zeropos:uncomment)", mopt)
vim.keymap.set("n", "gca", "<Plug>(caw:dollarpos:comment)", mopt)
vim.keymap.set("n", "gcua", "<Plug>(caw:dollarpos:uncomment)", mopt)
vim.keymap.set("x", "gcw", "<Plug>(caw:wrap:comment)", mopt)
vim.keymap.set("n", "gco", "<Plug>(caw:jump:comment-next)", mopt)
vim.keymap.set("n", "gcO", "<Plug>(caw:jump:comment-prev)", mopt)
vim.keymap.set("n", "gct", "<Plug>(caw:jump:comment-next)TODO:<Space>", mopt)
vim.keymap.set("n", "gcT", "<Plug>(caw:jump:comment-prev)TODO:<Space>", mopt)

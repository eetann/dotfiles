vim.keymap.set({ "n", "x" }, "ga", "<Plug>(LiveEasyAlign)", { noremap = true, silent = true })

-- コメントや文字列中でも有効化
vim.g.easy_align_ignore_groups = {}

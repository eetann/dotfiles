require("textcase").setup({})
require("telescope").load_extension("textcase")
vim.api.nvim_set_keymap("n", "gt", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
vim.api.nvim_set_keymap("v", "gt", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })

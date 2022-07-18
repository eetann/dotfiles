vim.g["sandwich#recipes"] = vim.deepcopy(vim.g["sandwich#default_recipes"])
vim.g["sandwich#recipes"] = vim.tbl_extend("force", vim.g["sandwich#recipes"], {
	{ buns = { "（", "）" }, input = { "jb" } },
	{ buns = { "（", "）" }, input = { "j(" } },
	{ buns = { "（", "）" }, input = { "j)" } },
	{ buns = { "（", "）" }, input = { "j8" } },
	{ buns = { "（", "）" }, input = { "j9" } },
	{ buns = { "［", "］" }, input = { "j[" } },
	{ buns = { "［", "］" }, input = { "j[" } },
	{ buns = { "［", "］" }, input = { "jB" } },
	{ buns = { "｛", "｝" }, input = { "j}" } },
	{ buns = { "｛", "｝" }, input = { "j{" } },
	{ buns = { "＜", "＞" }, input = { "j<" } },
	{ buns = { "＜", "＞" }, input = { "j>" } },
	{ buns = { "＜", "＞" }, input = { "ja" } },
	{ buns = { "≪", "≫" }, input = { "jA" } },
	{ buns = { "「", "」" }, input = { "jk" } },
	{ buns = { "『", "』" }, input = { "jK" } },
	{ buns = { "〈", "〉" }, input = { "jy" } },
	{ buns = { "《", "》" }, input = { "jY" } },
	{ buns = { "【", "】" }, input = { "jr" } },
	{ buns = { "【", "】" }, input = { "js" } },
	{ buns = { "〔", "〕" }, input = { "jt" } },
})

vim.g["sandwich_no_default_key_mappings"] = 1

vim.keymap.set({ "n", "o", "x" }, "sa", "<Plug>(sandwich-add)")
vim.keymap.set({ "n", "o", "x" }, "sd", "<Plug>(sandwich-delete)")
vim.keymap.set({ "n", "o", "x" }, "sr", "<Plug>(sandwich-replace)")
vim.keymap.set({ "o", "x" }, "is", "<Plug>(textobj-sandwich-query-i)")
vim.keymap.set({ "o", "x" }, "as", "<Plug>(textobj-sandwich-query-a)")

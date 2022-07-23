vim.g["sandwich#recipes"] = vim.list_extend(vim.deepcopy(vim.g["sandwich#default_recipes"]), {
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

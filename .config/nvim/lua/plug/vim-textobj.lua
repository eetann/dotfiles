vim.g.textobj_multitextobj_textobjects_i = {
	"\\<Plug>(textobj-multiblock-i)",
	"\\<Plug>(textobj-jabraces-parens-i)",
	"\\<Plug>(textobj-jabraces-braces-i)",
	"\\<Plug>(textobj-jabraces-brackets-i)",
	"\\<Plug>(textobj-jabraces-angles-i)",
	"\\<Plug>(textobj-jabraces-double-angles-i)",
	"\\<Plug>(textobj-jabraces-kakko-i)",
	"\\<Plug>(textobj-jabraces-double-kakko-i)",
	"\\<Plug>(textobj-jabraces-yama-kakko-i)",
	"\\<Plug>(textobj-jabraces-double-yama-kakko-i)",
	"\\<Plug>(textobj-jabraces-kikkou-kakko-i)",
	"\\<Plug>(textobj-jabraces-sumi-kakko-i)",
}

vim.g.textobj_multitextobj_textobjects_a = {
	"\\<Plug>(textobj-multiblock-a)",
	"\\<Plug>(textobj-jabraces-parens-a)",
	"\\<Plug>(textobj-jabraces-braces-a)",
	"\\<Plug>(textobj-jabraces-brackets-a)",
	"\\<Plug>(textobj-jabraces-angles-a)",
	"\\<Plug>(textobj-jabraces-double-angles-a)",
	"\\<Plug>(textobj-jabraces-kakko-a)",
	"\\<Plug>(textobj-jabraces-double-kakko-a)",
	"\\<Plug>(textobj-jabraces-yama-kakko-a)",
	"\\<Plug>(textobj-jabraces-double-yama-kakko-a)",
	"\\<Plug>(textobj-jabraces-kikkou-kakko-a)",
	"\\<Plug>(textobj-jabraces-sumi-kakko-a)",
}

vim.keymap.set({ "o", "x" }, "ab", "<Plug>(textobj-multiblock-a)")
vim.keymap.set({ "o", "x" }, "ib", "<Plug>(textobj-multiblock-i)")

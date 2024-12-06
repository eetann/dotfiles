return {
	{
		"thinca/vim-quickrun",
		dependencies = {
			{ "lambdalisue/vim-quickrun-neovim-job" },
			{ "tyru/open-browser.vim" },
		},
		keys = {
			{ "<space>r", "<Cmd>:write<CR>:QuickRun -mode n<CR>", silent = true },
			{ "<space>R", "<Cmd>:write<CR>:QuickRun -runner terminal<CR>", silent = true },
			{ "<space>r", ":<C-U>write<CR>gv:QuickRun -mode v<CR>", mode = "x", silent = true },
		},
		init = function()
			vim.g.quickrun_config = {
				_ = {
					runner = "neovim_job",
					outputter = "error",
					["runner/terminal/into"] = true,
					["outputter/error/success"] = "buffer",
					["outputter/error/error"] = "quickfix",
					["outputter/buffer/close_on_empty"] = true,
					["outputter/buffer/into"] = true,
					["outputter/buffer/split"] = '%{winwidth(0) * 2 < winheight(0) * 5 ? winheight(0)/4 : "vertical"}',
					["outputter/quickfix/into"] = true,
				},
				mdx = {
					runner = "vimscript",
					exec = ":call v:lua.open_blog()",
					outputter = "null",
				},
			}
			vim.cmd([[
    set errorformat=%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
    command! -nargs=+ -complete=command Capture QuickRun -type vim -src <q-args>
    nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
]])
		end,
	},
}

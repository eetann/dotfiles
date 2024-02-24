vim.g.UltiSnipsSnippetDirectories = { "~/dotfiles/.config/nvim/snippet" }
local lspkind = require("lspkind")

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

cmp.setup({
	window = {
		documentation = cmp.config.window.bordered(),
	},
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	mapping = {
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-e>"] = cmp.mapping.abort(),
		["<C-n>"] = function()
			if cmp.visible() then
				cmp.select_next_item()
			end
		end,
		["<C-p>"] = function()
			if cmp.visible() then
				cmp.select_prev_item()
			end
		end,
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<C-k>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({ select = true })
			elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
				cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	sources = cmp.config.sources({
		{ name = "ultisnips" },
		{ name = "nvim_lsp" },
		{
			name = "path",
			option = {
				get_cwd = function(params)
					-- NOTE: ZLEのedit-command-lineで使いやすいようにcwdを変更
					---@diagnostic disable-next-line: missing-parameter
					local dir_name = vim.fn.expand(("#%d:p:h"):format(params.context.bufnr))
					if dir_name == "/tmp" then
						-- body
						return vim.fn.getcwd()
					end
					return dir_name
				end,
			},
		},
		{
			name = "buffer",
			option = {
				get_bufnrs = function()
					return vim.api.nvim_list_bufs()
				end,
			},
		},
		{ name = "dictionary" },
	}),
	formatting = {
		format = lspkind.cmp_format(),
	},
})

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{
			name = "path",
			option = {
				get_cwd = function(params)
					-- NOTE: ZLEのedit-command-lineで使いやすいようにcwdを変更
					---@diagnostic disable-next-line: missing-parameter
					local dir_name = vim.fn.expand(("#%d:p:h"):format(params.context.bufnr))
					if dir_name == "/tmp" then
						-- body
						return vim.fn.getcwd()
					end
					return dir_name
				end,
			},
		},
		{
			name = "buffer",
			option = {
				get_bufnrs = function()
					return vim.api.nvim_list_bufs()
				end,
			},
		},
	}),
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline({
		["<C-k>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<BS>", true, false, true) .. "", "m", true)
				cmp.close()
				vim.cmd("sleep 100m")
				local last_char = string.sub(vim.fn.getcmdline(), -1)
				vim.api.nvim_feedkeys(last_char, "i", false)
			else
				fallback()
			end
		end, { "c" }),
	}),
	sources = cmp.config.sources({
		{
			name = "path",
			option = {
				get_cwd = function(params)
					-- NOTE: ZLEのedit-command-lineで使いやすいようにcwdを変更
					---@diagnostic disable-next-line: missing-parameter
					local dir_name = vim.fn.expand(("#%d:p:h"):format(params.context.bufnr))
					if dir_name == "/tmp" then
						-- body
						return vim.fn.getcwd()
					end
					return dir_name
				end,
			},
		},
	}, {
		{ name = "cmdline" },
	}),
})

require("cmp_dictionary").setup({
	dic = {
		["*"] = { "/usr/share/dict/words" },
	},
	exact_length = 2,
	first_case_insensitive = false,
  document = {
    enable = false,
    command = { "wn", "${label}", "-over" },
  },
})

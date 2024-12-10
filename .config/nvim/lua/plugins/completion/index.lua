return {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdLineEnter" },
	dependencies = {
		-- TODO: luasnipに移行する
		{ import = "plugins.completion.ultisnips" },
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		-- "hrsh7th/cmp-path",
		-- { dir = "eetann/cmp-eetannpath" },
		"eetann/cmp-eetannpath",
		{
			"quangnguyen30192/cmp-nvim-ultisnips",
			opts = {
				filetype_source = "ultisnips_default",
			},
		},
		"hrsh7th/cmp-cmdline",
		"uga-rosa/cmp-dictionary",
		"onsails/lspkind-nvim",
	},
	config = function()
		local cmp = require("cmp")
		cmp.setup({
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			snippet = {
				expand = function(args)
					vim.fn["UltiSnips#Anon"](args.body)
				end,
			},
			mapping = require("plugins.completion.cmp-mapping"),
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
				{
					name = "lazydev",
					group_index = 0, -- set group index to 0 to skip loading LuaLS completions
				},
			}),
			---@diagnostic disable-next-line: missing-fields
			formatting = {
				format = require("lspkind").cmp_format({
					maxwidth = 35,
				}),
			},
		})
		require("plugins.completion.cmdline")
		require("cmp_dictionary").setup({
			paths = { "/usr/share/dict/words" },
			exact_length = 2,
			first_case_insensitive = false,
			document = {
				enable = false,
				command = { "wn", "${label}", "-over" },
			},
		})
		vim.api.nvim_create_autocmd({ "FileType" }, {
			group = "my_nvim_rc",
			pattern = { "gitcommit" },
			callback = function()
				require("plugins.completion.gitcommit")
			end,
		})
	end,
}

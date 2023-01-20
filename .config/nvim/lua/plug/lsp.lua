require("symbols-outline").setup()
vim.keymap.set("n", "<Leader>o", "<Cmd>SymbolsOutline<CR>", { noremap = true })

require("illuminate").configure({
	modes_allowlist = { "n" },
	delay = 100,
})

local saga = require("lspsaga")

saga.setup({
	-- Options with default value
	-- "single" | "double" | "rounded" | "bold" | "plus"
	border_style = "single",
	--the range of 0 for fully opaque window (disabled) to 100 for fully
	--transparent background. Values between 0-30 are typically most useful.
	saga_winblend = 0,
	-- when cursor in saga window you config these to move
	move_in_saga = { prev = "<C-u>", next = "<C-d>" },
	-- Error, Warn, Info, Hint
	-- use emoji like
	-- { "🙀", "😿", "😾", "😺" }
	-- or
	-- { "😡", "😥", "😤", "😐" }
	-- and diagnostic_header can be a function type
	-- must return a string and when diagnostic_header
	-- is function type it will have a param `entry`
	-- entry is a table type has these filed
	-- { bufnr, code, col, end_col, end_lnum, lnum, message, severity, source }
	diagnostic_header = { " ", " ", " ", "ﴞ " },
	-- preview lines above of lsp_finder
	preview_lines_above = 0,
	-- preview lines of lsp_finder and definition preview
	max_preview_lines = 10,
	-- use emoji lightbulb in default
	code_action_icon = "💡",
	-- if true can press number to execute the codeaction in codeaction window
	code_action_num_shortcut = true,
	-- same as nvim-lightbulb but async
	code_action_lightbulb = {
		enable = true,
		enable_in_insert = true,
		cache_code_action = true,
		sign = true,
		update_time = 150,
		sign_priority = 20,
		virtual_text = true,
	},
	-- finder icons
	finder_icons = {
		def = "  ",
		ref = "諭 ",
		link = "  ",
	},
	-- finder do lsp request timeout
	-- if your project big enough or your server very slow
	-- you may need to increase this value
	finder_request_timeout = 1500,
	finder_action_keys = {
		open = { "o", "<CR>" },
		vsplit = "s",
		split = "i",
		tabe = "t",
		quit = { "q", "<ESC>" },
	},
	code_action_keys = {
		quit = "q",
		exec = "<CR>",
	},
	definition_action_keys = {
		edit = "<C-c>o",
		vsplit = "<C-c>v",
		split = "<C-c>x",
		tabe = "<C-c>t",
		quit = "q",
	},
	rename_action_quit = "<C-c>",
	rename_in_select = true,
	-- show symbols in winbar must nightly
	-- in_custom mean use lspsaga api to get symbols
	-- and set it to your custom winbar or some winbar plugins.
	-- if in_cusomt = true you must set in_enable to false
	symbol_in_winbar = {
		in_custom = false,
		enable = true,
		separator = " ",
		show_file = true,
		-- define how to customize filename, eg: %:., %
		-- if not set, use default value `%:t`
		-- more information see `vim.fn.expand` or `expand`
		-- ## only valid after set `show_file = true`
		file_formatter = "",
		click_support = false,
	},
	-- show outline
	show_outline = {
		win_position = "right",
		--set special filetype win that outline window split.like NvimTree neotree
		-- defx, db_ui
		win_with = "",
		win_width = 30,
		auto_enter = true,
		auto_preview = true,
		virt_text = "┃",
		jump_key = "o",
		-- auto refresh when change buffer
		auto_refresh = true,
	},
	-- custom lsp kind
	-- usage { Field = 'color code'} or {Field = {your icon, your color code}}
	custom_kind = {},
	-- if you don't use nvim-lspconfig you must pass your server name and
	-- the related filetypes into this table
	-- like server_filetype_map = { metals = { "sbt", "scala" } }
	server_filetype_map = {},
})

local on_attach = function(client, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
	vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", bufopts)
	vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", bufopts)
	vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", bufopts)
	vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
	vim.keymap.set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", bufopts)
	vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", bufopts)
	vim.keymap.set("n", "<C-g>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", bufopts)
	vim.keymap.set("i", "<C-g>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", bufopts)
	vim.keymap.set("n", "gh", "<cmd>Lspsaga signature_help<CR>", bufopts)
	vim.keymap.set("n", "<leader>cr", "<cmd>Lspsaga rename<CR>", bufopts)
	vim.keymap.set("n", "<space>ca", "<cmd>CodeActionMenu<CR>", bufopts)
	vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", bufopts)
	vim.keymap.set("n", "<leader>cc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", bufopts)
	vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", bufopts)
	vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", bufopts)

	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			group = "my_nvim_rc",
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ timeout_ms = 2000 })
			end,
		})
	end
end

local function on_attach_disable_format(client, buffer)
	client.server_capabilities.documentFormattingProvider = false
	on_attach(client, buffer)
end

require("mason").setup()
local nvim_lsp = require("lspconfig")

local function detected_root_dir(root_dir)
	return not not (root_dir(vim.api.nvim_buf_get_name(0), vim.api.nvim_get_current_buf()))
end

require("neodev").setup({})
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup_handlers({
	function(server_name)
		local opts = {}
		opts.on_attach = on_attach
		opts.capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
		opts.capabilities.textDocument.completion.completionItem.snippetSupport = true

		if server_name == "tsserver" or server_name == "eslint" then
			local root_dir = nvim_lsp.util.root_pattern("package.json", "node_modules")
			opts.root_dir = root_dir
			opts.autostart = detected_root_dir(root_dir)
			opts.on_attach = on_attach_disable_format
		elseif server_name == "denols" then
			local root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", "deps.ts")
			opts.root_dir = root_dir
			opts.autostart = detected_root_dir(root_dir)
			opts.init_options = { lint = true, unstable = true }
		elseif server_name == "sumneko_lua" then
			opts.on_attach = on_attach_disable_format
			opts.settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
				},
			}
		end

		nvim_lsp[server_name].setup(opts)
	end,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	update_in_insert = false,
	virtual_text = {
		format = function(diagnostic)
			return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
		end,
	},
})

local null_ls = require("null-ls")

local eslint_condition = function(utils)
	return utils.root_has_file({
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.yaml",
		".eslintrc.yml",
		".eslintrc.json",
	})
end

local prettier_condition = function(utils)
	return utils.root_has_file({
		".prettierrc",
		".prettierrc.json",
		".prettierrc.yml",
		".prettierrc.yaml",
		".prettierrc.json5",
		".prettierrc.js",
		".prettierrc.cjs",
		"prettier.config.js",
		"prettier.config.cjs",
		".prettierrc.toml",
	})
end

local sources = {
	null_ls.builtins.code_actions.eslint.with({
		condition = eslint_condition,
	}),
	null_ls.builtins.diagnostics.eslint.with({
		condition = eslint_condition,
	}),
	null_ls.builtins.formatting.prettier.with({
		condition = prettier_condition,
	}),
	null_ls.builtins.diagnostics.textlint.with({
		filetypes = { "markdown" },
		condition = function(utils)
			local is_mdn = utils.root_matches("translated%-content")
			local is_not_dotfiles = not utils.root_matches("dotfiles")
			return is_mdn
				or (
					is_not_dotfiles
					and utils.root_has_file({
						".textlintrc",
						".textlintrc.js",
						".textlintrc.json",
						".textlintrc.yml",
						".textlintrc.yaml",
					})
				)
		end,
		cwd = function(params)
			local is_mdn = params.root:find("translated%-content")
			return is_mdn and vim.fn.expand("~/ghq/github.com/mozilla-japan/translation/MDN/textlint")
		end,
	}),
	null_ls.builtins.diagnostics.shellcheck.with({
		condition = function()
			---@diagnostic disable-next-line: missing-parameter
			return vim.fn.expand("%:t") ~= ".envrc"
		end,
	}),
	null_ls.builtins.code_actions.shellcheck,
	null_ls.builtins.formatting.shfmt,
	null_ls.builtins.formatting.stylua,
}
null_ls.setup({
	sources = sources,
	diagnostics_format = "#{m} (#{s}: #{c})",
	on_attach = function(client, buffer)
		on_attach(client, buffer)
	end,
})

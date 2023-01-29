vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

require("symbols-outline").setup()
vim.keymap.set("n", "<Leader>o", "<Cmd>SymbolsOutline<CR>", { noremap = true })

require("illuminate").configure({
	modes_allowlist = { "n" },
	delay = 100,
})

local saga = require("lspsaga")

saga.setup({
	scroll_preview = {
		scroll_down = "<C-d>",
		scroll_up = "<C-u>",
	},
	finder = {
		edit = { "o", "<CR>" },
		vsplit = { "\\", "|", "<C-v>" },
		split = { "-", "<C-x>" },
		tabe = "t",
		quit = { "q", "<ESC>" },
	},
	definition = {
		edit = "o",
		vsplit = "<C-v>",
		split = "<C-x>",
		tabe = "t",
		quit = "q",
		close = "<Esc>",
	},
	lightbulb = {
		enable_in_insert = false,
	},
})

local on_attach = function(client, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
	vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", bufopts)
	vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", bufopts)
	vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", bufopts)
	vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
	vim.keymap.set("n", "gp", "<cmd>Lspsaga peek_definition<CR>", bufopts)
	vim.keymap.set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", bufopts)
	vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", bufopts)
	vim.keymap.set("n", "<C-g>", "<cmd>Lspsaga hover_doc<CR>", bufopts)
	vim.keymap.set("i", "<C-g>h", "<cmd>Lspsaga hover_doc<CR>", bufopts)
	vim.keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", bufopts)
	vim.keymap.set("n", "gs", "<cmd>Lspsaga hover_doc<CR>", bufopts)
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

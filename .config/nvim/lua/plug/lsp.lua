vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	virtual_text = {
		prefix = "●",
		format = function(diagnostic)
			return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
		end,
	},
	-- NOTE: 未対応のプラグインがあるため
	-- signs = {
	-- 	text = {
	-- 		[vim.diagnostic.severity.ERROR] = "",
	-- 		[vim.diagnostic.severity.WARN] = "",
	-- 		[vim.diagnostic.severity.INFO] = "",
	-- 		[vim.diagnostic.severity.HINT] = "",
	-- 	},
	-- 	numhl = {
	-- 		[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
	-- 		[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
	-- 		[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
	-- 		[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
	-- 	},
	-- },
})
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

require("outline").setup({
	providers = {
		markdown = {
			filetypes = { "markdown", "mdx" },
		},
	},
	symbols = {
		icons = {
			File = { icon = "󰈔", hl = "Identifier" },
			Module = { icon = "󰆧", hl = "Include" },
			Namespace = { icon = "󰅪", hl = "Include" },
			Package = { icon = "󰏗", hl = "Include" },
			Class = { icon = "C", hl = "Type" },
			Method = { icon = "ƒ", hl = "Function" },
			Property = { icon = "", hl = "Identifier" },
			Field = { icon = "󰆨", hl = "Identifier" },
			Constructor = { icon = "", hl = "Special" },
			Enum = { icon = "ℰ", hl = "Type" },
			Interface = { icon = "󰜰", hl = "Type" },
			Function = { icon = "", hl = "Function" },
			Variable = { icon = "", hl = "Constant" },
			Constant = { icon = "", hl = "Constant" },
			String = { icon = "Aa", hl = "String" },
			Number = { icon = "#", hl = "Number" },
			Boolean = { icon = "⊨", hl = "Boolean" },
			Array = { icon = "󰅪", hl = "Constant" },
			Object = { icon = "⦿", hl = "Type" },
			Key = { icon = "🔐", hl = "Type" },
			Null = { icon = "NULL", hl = "Type" },
			EnumMember = { icon = "", hl = "Identifier" },
			Struct = { icon = "{}", hl = "Structure" },
			Event = { icon = "E", hl = "Type" },
			Operator = { icon = "+", hl = "Identifier" },
			TypeParameter = { icon = "T", hl = "Identifier" },
			Component = { icon = "󰅴", hl = "Function" },
			Fragment = { icon = "󰅴", hl = "Constant" },
			TypeAlias = { icon = " ", hl = "Type" },
			Parameter = { icon = " ", hl = "Identifier" },
			StaticMethod = { icon = " ", hl = "Function" },
			Macro = { icon = " ", hl = "Function" },
		},
	},
})

vim.keymap.set("n", "<Leader>o", "<Cmd>Outline<CR>", { noremap = true })

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
		enable = false,
	},
	diagnostic = {
		jump_num_shortcut = false,
		keys = {
			exec_action = "o",
			quit = "q",
			toggle_or_jump = "<CR>",
			quit_in_show = { "q", "<Esc>" },
		},
	},
})

require("actions-preview").setup({
	telescope = {
		sorting_strategy = "ascending",
		layout_strategy = "vertical",
		layout_config = {
			width = 0.8,
			height = 0.9,
			prompt_position = "top",
			preview_cutoff = 20,
			preview_height = function(_, _, max_lines)
				return max_lines - 15
			end,
		},
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
	vim.keymap.set("n", "gh", "<cmd>Lspsaga hover_doc<CR>", bufopts)
	vim.keymap.set("n", "<leader>cr", "<cmd>Lspsaga rename<CR>", bufopts)
	vim.keymap.set({ "n", "v" }, "<space>ca", require("actions-preview").code_actions, bufopts)
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
		vim.api.nvim_create_user_command("Format", function()
			vim.lsp.buf.format({ timeout_ms = 2000 })
		end, {})
	end
end

local function on_attach_disable_format(client, buffer)
	client.server_capabilities.documentFormattingProvider = false
	on_attach(client, buffer)
end

require("mason").setup()
local nvim_lsp = require("lspconfig")
nvim_lsp.biome.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	on_attach = on_attach,
	cmd = { "biome", "lsp-proxy" },
	on_new_config = function(new_config)
		local pnpm = nvim_lsp.util.root_pattern("pnpm-lock.yml", "pnpm-lock.yaml")(vim.api.nvim_buf_get_name(0))
		local cmd = { "npm", "biome", "lsp-proxy" }
		if pnpm then
			cmd = { "pnpm", "biome", "lsp-proxy" }
		end
		new_config.cmd = cmd
	end,
})

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

		if server_name == "tsserver" then
			local root_dir = nvim_lsp.util.root_pattern("package.json", "node_modules")
			opts.root_dir = root_dir
			opts.autostart = detected_root_dir(root_dir)
			opts.on_attach = on_attach_disable_format
		elseif server_name == "denols" then
			local root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", "deps.ts")
			opts.root_dir = root_dir
			opts.autostart = detected_root_dir(root_dir)
			opts.init_options = { lint = true, unstable = true }
		elseif server_name == "bashls" then
			opts.settings = {
				bashIde = {
					globPattern = "*@(.sh|.inc|.bash|.command|.envrc)",
				},
			}
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
	null_ls.builtins.formatting.prettier.with({
		condition = prettier_condition,
		extra_filetypes = { "json5", "astro" },
	}),
	null_ls.builtins.diagnostics.textlint.with({
		filetypes = { "markdown", "mdx" },
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
	null_ls.builtins.formatting.shfmt,
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.formatting.biome,
}
require("null-ls").register(require("none-ls-shellcheck.diagnostics"))
require("null-ls").register(require("none-ls-shellcheck.code_actions"))
null_ls.setup({
	sources = sources,
	diagnostics_format = "#{m} (#{s}: #{c})",
	on_attach = function(client, buffer)
		on_attach(client, buffer)
	end,
})

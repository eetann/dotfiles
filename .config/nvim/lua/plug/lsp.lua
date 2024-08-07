vim.diagnostic.config({
	severity_sort = true,
	virtual_text = {
		prefix = "●",
		format = function(diagnostic)
			return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
		end,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
})

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
	symbol_in_winbar = {
		enable = false,
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

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

-- TODO: ブログに書く
local js_formatters = { "biome", "prettierd", "prettier", stop_after_first = true }
require("conform").setup({
	format_on_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			---@diagnostic disable-next-line: missing-return-value
			return
		end
		return {
			timeout_ms = 2000,
			lsp_fallback = true,
			quiet = false,
		}
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		json = js_formatters,
		javascript = js_formatters,
		javascriptreact = js_formatters,
		typescript = js_formatters,
		typescriptreact = js_formatters,
		astro = js_formatters,
		-- NOTE: svelteのformatはsvelteserverのやつを使う。
		-- LSPのFormatterは`lsp_fallback=true`をしたのでOK
		-- svelte = { { "svelteserver" } },
	},
	formatters = {
		shfmt = {
			prepend_args = { "-i", "2" },
		},
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = "my_nvim_rc",
	callback = function(ev)
		local bufopts = { noremap = true, silent = true, buffer = ev.buf }
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
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
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client == nil then
			return
		end
	end,
})

require("mason").setup()
local lspconfig = require("lspconfig")
lspconfig.biome.setup({
	cmd = { "biome", "lsp-proxy" },
	on_new_config = function(new_config)
		local pnpm = lspconfig.util.root_pattern("pnpm-lock.yml", "pnpm-lock.yaml")(vim.api.nvim_buf_get_name(0))
		local cmd = { "npx", "biome", "lsp-proxy" }
		if pnpm then
			cmd = { "pnpm", "biome", "lsp-proxy" }
		end
		new_config.cmd = cmd
	end,
})
require("lspconfig").eslint.setup({})

local function detected_root_dir(root_dir)
	return not not (root_dir(vim.api.nvim_buf_get_name(0), vim.api.nvim_get_current_buf()))
end

require("neodev").setup({})
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup_handlers({
	function(server_name)
		local opts = {}
		opts.capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
		opts.capabilities.textDocument.completion.completionItem.snippetSupport = true

		if server_name == "tsserver" then
			local root_dir = lspconfig.util.root_pattern("package.json", "node_modules")
			opts.root_dir = root_dir
			opts.autostart = detected_root_dir(root_dir)
		elseif server_name == "denols" then
			local root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts")
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
		elseif server_name == "tailwindcss" then
			opts.settings = {
				tailwindCSS = {
					experimental = {
						classRegex = {
							{ "tv\\((([^()]*|\\([^()]*\\))*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
						},
					},
				},
			}
		end

		lspconfig[server_name].setup(opts)
	end,
})

local null_ls = require("null-ls")

local sources = {
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
	null_ls.builtins.formatting.stylua,
}
require("null-ls").register(require("none-ls-shellcheck.diagnostics"))
require("null-ls").register(require("none-ls-shellcheck.code_actions"))
null_ls.setup({
	sources = sources,
})

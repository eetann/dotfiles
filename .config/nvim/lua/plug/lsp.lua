local mopt = { noremap = true, silent = true }
vim.g.Illuminate_delay = 50
vim.keymap.set("n", "<Leader>o", "<Cmd>SymbolsOutline<CR>", { noremap = true })

require("lspsaga").setup({
	debug = false,
	use_saga_diagnostic_sign = true,
	-- diagnostic sign
	-- error_sign = "E",
	-- warn_sign = "w",
	-- hint_sign = "H",
	-- infor_sign = "i",
	-- diagnostic_header_icon = "d",
	-- code action title icon
	-- code_action_icon = "@",
	code_action_prompt = {
		enable = true,
		sign = true,
		sign_priority = 40,
		virtual_text = true,
	},
	-- finder_definition_icon = "Def ",
	-- finder_reference_icon = "Ref ",
	max_preview_lines = 10,
	finder_action_keys = {
		open = "o",
		vsplit = "v",
		split = "s",
		quit = "q",
		scroll_down = "<C-d>",
		scroll_up = "<C-u>",
	},
	code_action_keys = {
		quit = "q",
		exec = "<CR>",
	},
	rename_action_keys = {
		quit = "<C-c>",
		exec = "<CR>",
	},
	definition_preview_icon = "Def ",
	border_style = "single",
	rename_prompt_prefix = ">",
	rename_output_qflist = {
		enable = false,
		auto_open_qflist = false,
	},
	server_filetype_map = {},
	diagnostic_prefix_format = "%d. ",
	diagnostic_message_format = "%m %c",
	highlight_prefix = false,
})
vim.keymap.set("n", "<C-d>", function()
	require("lspsaga.action").smart_scroll_with_saga(1)
end, mopt)
vim.keymap.set("n", "<C-u>", function()
	require("lspsaga.action").smart_scroll_with_saga(-1)
end, mopt)

require("lsp_signature").setup({
	debug = false,
	log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log",
	-- default is  ~/.cache/nvim/lsp_signature.log
	verbose = false,

	bind = false,
	doc_lines = 10,

	floating_window = true,
	floating_window_above_cur_line = false,
	floating_window_off_x = 1,
	floating_window_off_y = 0,

	fix_pos = false,
	hint_enable = true,
	hint_prefix = "🐼 ",
	hint_scheme = "String",
	hi_parameter = "LspSignatureActiveParameter",
	max_height = 12,
	max_width = 80,
	handler_opts = {
		border = "single",
	},

	always_trigger = false,

	auto_close_after = nil,
	extra_trigger_chars = {},
	zindex = 200,

	padding = "",

	transparency = nil,
	shadow_blend = 36,
	shadow_guibg = "Black",
	timer_interval = 200,
	toggle_key = nil,
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
	vim.keymap.set("n", "<leader>cc", "<cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>", bufopts)
	vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", bufopts)
	vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", bufopts)

	require("illuminate").on_attach(client)
	if client.resolved_capabilities.document_formatting then
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			group = "my_nvim_rc",
			pattern = "<buffer>",
			callback = function()
				vim.lsp.buf.formatting_sync({}, 2500)
			end,
		})
	end
end

local function on_attach_disable_format(client, buffer)
	client.resolved_capabilities.document_formatting = false
	on_attach(client, buffer)
end

require("nvim-lsp-installer").setup()
local lspconfig = require("lspconfig")

local function detected_root_dir(root_dir)
	return not not (root_dir(vim.api.nvim_buf_get_name(0), vim.api.nvim_get_current_buf()))
end

local installed_servers = {}
local installer_avail, lsp_installer = pcall(require, "nvim-lsp-installer")
if installer_avail then
	for _, server in ipairs(lsp_installer.get_installed_servers()) do
		table.insert(installed_servers, server.name)
	end
end

for _, server in pairs(installed_servers) do
	local opts = {}
	opts.on_attach = on_attach
	opts.capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
	opts.capabilities.textDocument.completion.completionItem.snippetSupport = true

	if server == "tsserver" or server == "eslint" then
		local root_dir = lspconfig.util.root_pattern("package.json", "node_modules")
		opts.root_dir = root_dir
		opts.autostart = detected_root_dir(root_dir)
		opts.on_attach = on_attach_disable_format
	elseif server == "denols" then
		local root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts")
		opts.root_dir = root_dir
		opts.autostart = detected_root_dir(root_dir)
		opts.init_options = { lint = true, unstable = true }
	elseif server == "sumneko_lua" then
		opts.on_attach = on_attach_disable_format
		local has_lua_dev, lua_dev = pcall(require, "lua-dev")
		if has_lua_dev then
			opts = lua_dev.setup({
				library = {
					vimruntime = true,
					types = true,
					plugins = { "nvim-treesitter", "plenary.nvim" },
				},
				runtime_path = false,
				lspconfig = opts,
			})
		end
	end

	lspconfig[server].setup(opts)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	update_in_insert = false,
})

local null_ls = require("null-ls")
local command_resolver = require("null-ls.helpers.command_resolver")
local sources = {
	null_ls.builtins.formatting.prettier.with({
		filetypes = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"vue",
			"css",
			"scss",
			"less",
			"html",
			"json",
			"jsonc",
			"yaml",
			"graphql",
			"handlebars",
		},
		dynamic_command = function(params)
			return command_resolver.from_node_modules(params)
				or command_resolver.from_yarn_pnp(params)
				or vim.fn.executable(params.command) == 1 and params.command
		end,
	}),
	null_ls.builtins.diagnostics.textlint.with({
		filetypes = { "markdown" },
		condition = function(utils)
			return utils.root_has_file({
				".textlintrc",
				".textlintrc.js",
				".textlintrc.json",
				".textlintrc.yml",
				".textlintrc.yaml",
			})
		end,
	}),
	null_ls.builtins.diagnostics.shellcheck.with({
		condition = function()
			return vim.fn.expand("%:t") ~= ".envrc"
		end,
	}),
	null_ls.builtins.code_actions.shellcheck,
	null_ls.builtins.formatting.shfmt,
	null_ls.builtins.formatting.stylua,
}
null_ls.setup({
	sources = sources,
	on_attach = function(client)
		if client.resolved_capabilities.document_formatting then
			vim.api.nvim_create_autocmd({ "BufWritePre" }, {
				group = "my_nvim_rc",
				pattern = "<buffer>",
				callback = function()
					vim.lsp.buf.formatting_sync({}, 3000)
				end,
			})
		end
	end,
})

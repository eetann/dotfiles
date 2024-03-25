vim.g.UltiSnipsSnippetDirectories = { "~/dotfiles/.config/nvim/snippet" }
local lspkind = require("lspkind")

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

-- gitcommitのprefix補完
local git_source = {}

---@return boolean
function git_source:is_available()
	if vim.bo.filetype == "gitcommit" then
		return true
	end
	return false
end

---@return string
function git_source:get_debug_name()
	return "my gitcommit"
end

---Return LSP's PositionEncodingKind.
function git_source:get_position_encoding_kind()
	return "utf-16"
end

local commitPrefix = {
	{ word = "feat: ", menu = "機能追加" },
	{ word = "fix: ", menu = "バグ修正" },
	{ word = "docs: ", menu = "ドキュメント" },
	{ word = "style: ", menu = "デザイン変更のみ" },
	{ word = "refactor: ", menu = "リファクタリング " },
	{ word = "perf: ", menu = "パフォーマンス改善 " },
	{ word = "test: ", menu = "テスト関連の変更 " },
	{ word = "build: ", menu = "ビルドシステムの変更" },
	{ word = "ci: ", menu = "CI関連の変更" },
	{ word = "chore: ", menu = "その他の変更" },
}

---@class lsp.CompletionResponse
local commitPrefixItems = {}

for _, item in pairs(commitPrefix) do
	table.insert(commitPrefixItems, {
		insertText = item.word,
		label = item.word,
		labelDetails = { detail = item.menu },
		kind = 1, -- text
	})
end

---Return trigger characters for triggering completion (optional).
function git_source:get_trigger_characters()
	return { ":" }
end

---@param _params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function git_source:complete(_params, callback)
	-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#completionItem
	callback(commitPrefixItems)
end

---Resolve completion item (optional). This is called right before the completion is about to be displayed.
---Useful for setting the text shown in the documentation window (`completion_item.documentation`).
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function git_source:resolve(completion_item, callback)
	callback(completion_item)
end

---Executed after the item was selected.
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function git_source:execute(completion_item, callback)
	callback(completion_item)
end

---Register your source to nvim-cmp.
require("cmp").register_source("gitcommit", git_source)

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

cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "gitcommit" },
	}),
})

vim.g.UltiSnipsSnippetDirectories = { "~/dotfiles/.config/nvim/snippet" }
local lspkind = require("lspkind")

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local cmp = require("cmp")
require("cmp_nvim_ultisnips").setup({
	filetype_source = "ultisnips_default",
})

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

vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"

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
	mapping = {
		["<Tab>"] = cmp.mapping({
			c = function()
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
				else
					cmp.complete()
				end
			end,
			i = function(fallback)
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
				elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
					vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), "m", true)
				else
					fallback()
				end
			end,
			s = function(fallback)
				if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
					vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), "m", true)
				else
					fallback()
				end
			end,
		}),
		["<S-Tab>"] = cmp.mapping({
			c = function()
				if cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
				else
					cmp.complete()
				end
			end,
			i = function(fallback)
				if cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
				elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
					return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), "m", true)
				else
					fallback()
				end
			end,
			s = function(fallback)
				if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
					return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), "m", true)
				else
					fallback()
				end
			end,
		}),
		["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
		["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
		["<C-n>"] = cmp.mapping({
			c = function()
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
				else
					vim.api.nvim_feedkeys(t("<Down>"), "n", true)
				end
			end,
			i = function(fallback)
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
				else
					fallback()
				end
			end,
		}),
		["<C-p>"] = cmp.mapping({
			c = function()
				if cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
				else
					vim.api.nvim_feedkeys(t("<Up>"), "n", true)
				end
			end,
			i = function(fallback)
				if cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
				else
					fallback()
				end
			end,
		}),
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c", "s" }), -- 補完を終了する
		["<C-e>"] = cmp.mapping.abort(), -- 補完を終了して戻す
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		-- TODO: macで動かない？
		-- setState, defaultDate のような prefixの後に続く所を書く時に使う
		["<C-g>"] = cmp.mapping(function()
			cmp.close()
			-- TODO: inputで補完できれば使えそう
			-- vim.ui.input({ prompt = "Enter keyword: " }, function(input)
			-- 	vim.api.nvim_feedkeys(
			-- 		vim.api.nvim_replace_termcodes(i .. input .. "<Esc>mzBvg~`za", true, false, true),
			-- 		"in",
			-- 		false
			-- 	)
			-- end)
			-- カーソル前を空白にすることでキーワードを最初から始める
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(" ", true, false, true), "in", false)
			-- -- TODO: ゴースト？で表示 あるいは inputで入力させる
			cmp.complete()
			local delete_event
			delete_event = cmp.event:on("complete_done", function(event)
				-- if not event.entry or not event.entry.confirmed then
				-- 	-- cmp.abort()
				-- 	delete_event()
				-- 	return
				-- end
				vim.defer_fn(function()
					vim.api.nvim_feedkeys(
						vim.api.nvim_replace_termcodes('<Esc>mzBvgU"_X`za', true, false, true),
						"in",
						false
					)
				end, 10)
				delete_event()
			end)
		end, { "i", "s" }),
		-- 先頭の大文字小文字を切り替える
		["<C-v>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.confirm()
				vim.defer_fn(function()
					vim.api.nvim_feedkeys(
						vim.api.nvim_replace_termcodes("<Esc>mzBvg~`za", true, false, true),
						"in",
						false
					)
				end, 10)
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
		{
			name = "lazydev",
			group_index = 0, -- set group index to 0 to skip loading LuaLS completions
		},
	}),
	---@diagnostic disable-next-line: missing-fields
	formatting = {
		format = lspkind.cmp_format({
			maxwidth = 35,
		}),
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
	paths = { "/usr/share/dict/words" },
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

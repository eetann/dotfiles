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

local cmp = require("cmp")
---Register your source to nvim-cmp.
cmp.register_source("gitcommit", git_source)

cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "gitcommit" },
	}),
})

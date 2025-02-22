---@module "blink-cmp"
---@type blink.cmp.SourceConfigPartial
return {
	-- スニペットはいちいち覚えていない & 短い文字なので優先表示
	-- lsp補完より優先されても、数文字打てば消える
	default = { "conventional_commits", "snippets", "lazydev", "lsp", "path", "buffer", "dictionary" },
	per_filetype = {
		codecompanion = { "codecompanion" },
		markdown = { "snippets", "lsp", "path", "dictionary" },
		mdx = { "snippets", "lsp", "path", "dictionary" },
	},
	providers = {
		conventional_commits = {
			name = "Conventional Commits",
			module = "blink-cmp-conventional-commits",
			enabled = function()
				return vim.bo.filetype == "gitcommit"
			end,
			---@module 'blink-cmp-conventional-commits'
			---@type blink-cmp-conventional-commits.Options
			opts = {}, -- none so far
		},
		-- snippets = {
		-- 	score_offset = 10,
		-- },
		lazydev = {
			name = "LazyDev",
			module = "lazydev.integrations.blink",
			-- make lazydev completions top priority (see `:h blink.cmp`)
			score_offset = 100,
		},
		dictionary = {
			module = "blink-cmp-dictionary",
			name = "Dict",
			min_keyword_length = 3,
			async = true,
			score_offset = -1000,
			max_items = 5,
			opts = {
				dictionary_files = { "/usr/share/dict/words" },
			},
		},
		path = {
			opts = {
				get_cwd = function(context)
					-- NOTE: ZLEのedit-command-lineで使いやすいようにcwdを変更
					local dir_name = vim.fn.expand(("#%d:p:h"):format(context.bufnr))
					if dir_name == "/tmp" then
						return vim.fn.getcwd()
					end
					return dir_name
				end,
			},
		},
	},
	min_keyword_length = function(ctx)
		-- :wq, :qa -> menu doesn't popup
		-- :Lazy, :wqa -> menu popup
		if ctx.mode == "cmdline" and ctx.line:find("^%u+") == nil then
			return 3
		end
		return 0
	end,
}

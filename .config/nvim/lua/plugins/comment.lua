---@module "lazy"
---@type LazyPluginSpec[]
return {
	{
		"numToStr/Comment.nvim",
		event = { "VeryLazy" },
		config = function()
			require("Comment").setup({
				---Add a space b/w comment and the line
				padding = true,
				---Whether the cursor should stay at its position
				sticky = true,
				---Lines to be ignored while (un)comment
				ignore = nil,
				---LHS of toggle mappings in NORMAL mode
				toggler = {
					---Line-comment toggle keymap
					line = "gcc",
					---Block-comment toggle keymap
					block = "gcb",
				},
				---LHS of operator-pending mappings in NORMAL and VISUAL mode
				opleader = {
					---Line-comment keymap
					line = "gcc",
					---Block-comment keymap
					block = "gcb",
				},
				---LHS of extra mappings
				extra = {
					---Add comment on the line above
					above = "gcO",
					---Add comment on the line below
					below = "gco",
					---Add comment at the end of line
					eol = "gcA",
				},
				---Enable keybindings
				---NOTE: If given `false` then the plugin won't create any mappings
				mappings = {
					---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
					basic = true,
					---Extra mapping; `gco`, `gcO`, `gcA`
					extra = true,
				},
				---Function to call before (un)comment
				---@param ctx CommentCtx
				---@return string|nil
				pre_hook = function(ctx)
					if vim.bo.filetype == "mdx" then
						return "{/* %s */}"
					end
					return nil
				end,
				---Function to call after (un)comment
				post_hook = nil,
			})

			local api = require("Comment.api")
			local config = require("Comment.config"):get()
			local mopt = { noremap = true, silent = true }
			vim.keymap.set("n", "gcT", function()
				api.insert.linewise.above(config)
				vim.api.nvim_feedkeys("TODO: ", "n", false)
			end, mopt)
			vim.keymap.set("n", "gct", function()
				api.insert.linewise.below(config)
				vim.api.nvim_feedkeys("TODO: ", "n", false)
			end, mopt)
		end,
	},
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
	},
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next todo comment",
			},

			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous todo comment",
			},
		},
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
}

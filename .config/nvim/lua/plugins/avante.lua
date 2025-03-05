return {
	"yetone/avante.nvim",
	build = "make",
	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		{ import = "plugins.copilot" },
		"MeanderingProgrammer/render-markdown.nvim",
	},
	cmd = {
		"AvanteAsk",
		"AvanteBuild",
		"AvanteChat",
		"AvanteEdit",
		"AvanteFocus",
		"AvanteRefresh",
		"AvanteSwitchProvider",
		"AvanteShowRepoMap",
		"AvanteToggle",
	},
	keys = function(_, keys)
		---@type avante.Config
		local opts =
			require("lazy.core.plugin").values(require("lazy.core.config").spec.plugins["avante.nvim"], "opts", false)

		local mappings = {
			{
				opts.mappings.ask,
				function()
					require("avante.api").ask()
				end,
				desc = "avante: ask",
				mode = { "n", "v" },
			},
			{
				opts.mappings.refresh,
				function()
					require("avante.api").refresh()
				end,
				desc = "avante: refresh",
				mode = "v",
			},
			{
				opts.mappings.edit,
				function()
					require("avante.api").edit()
				end,
				desc = "avante: edit",
				mode = { "n", "v" },
			},
		}
		mappings = vim.tbl_filter(function(m)
			return m[1] and #m[1] > 0
		end, mappings)
		return vim.list_extend(mappings, keys)
	end,
	opts = {
		-- 環境変数`OPENAI_API_KEY`にAPIキーをセット
		provider = vim.env.OPENAI_API_KEY and "openai" or "copilot",
		mappings = {
			ask = "<space>aa",
			edit = "<space>ae",
			refresh = "<space>ar",
			focus = "<space>af",
			suggestion = {
				accept = "<C-g>a",
				next = "<C-g>]",
				prev = "<C-g>[",
				dismiss = "<C-g>q",
			},
			submit = {
				normal = "<CR><CR>",
				insert = "<C-y>",
			},
			toggle = {
				default = "<space>at",
				debug = "<space>ad",
				hint = "<space>ah",
				suggestion = "<space>as",
				repomap = "<space>aR",
			},
		},
		files = {
			add_current = "<space>aC", -- Add current buffer to selected files
		},
		-- visualモードのvirtual textを非表示
		hints = { enabled = false },
		file_selector = {
			provider = "snacks",
		},
		behaviour = {
			auto_apply_diff_after_generation = true,
		},
	},
}

local target_files = {
	[".zprofile"] = true,
	[".mise.toml"] = true,
	[".mise.local.toml"] = true,
	["mise.local.toml"] = true,
	["env"] = true,
	[".env"] = true,
}
---@module "lazy"
---@type LazyPluginSpec
return {
	"milanglacier/minuet-ai.nvim",
	init = function()
		vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
			group = "my_nvim_rc",
			callback = function()
				local filename = vim.fn.expand("%:t")
				if not target_files[filename] then
					vim.cmd("Minuet virtualtext enable")
				end
			end,
		})
	end,
	opts = {
		virtualtext = {
			keymap = {
				-- accept whole completion
				accept = "<C-g>a",
				-- accept one line
				accept_line = "<C-g>l",
				-- accept n lines (prompts for number)
				-- e.g. "A-z 2 CR" will accept 2 lines
				accept_n_lines = "<C-g>L",
				-- Cycle to prev completion item, or manually invoke completion
				prev = "<C-g>[",
				-- Cycle to next completion item, or manually invoke completion
				next = "<C-g>]",
				dismiss = "<C-g>e",
			},
		},
		provider = "openai_compatible",
		request_timeout = 2.5,
		throttle = 1500, -- Increase to reduce costs and avoid rate limits
		debounce = 600, -- Increase to reduce costs and avoid rate limits
		provider_options = {
			openai_compatible = {
				api_key = "OPENROUTER_API_KEY",
				end_point = "https://openrouter.ai/api/v1/chat/completions",
				model = "openai/gpt-4.1-nano",
				name = "Openrouter",
				optional = {
					max_tokens = 128,
					top_p = 0.9,
					provider = {
						-- Prioritize throughput for faster completion
						sort = "throughput",
					},
				},
			},
		},
	},
}

require("incline").setup({
	render = function(props)
		if vim.fn.line(".", props.win) == 1 then
			return nil
		end
		-- generate name
		local bufname = vim.api.nvim_buf_get_name(props.buf)
		if bufname == "" then
			return "[No name]"
		else
			bufname = vim.fn.fnamemodify(bufname, ":~:.")
		end
		-- find devicon for the bufname
		local icon, color = require("nvim-web-devicons").get_icon_color(bufname, nil, { default = true })

		-- cut the content if it takes more than half of the screen
		local max_len = vim.api.nvim_win_get_width(props.win) / 2

		if #bufname > max_len then
			bufname = " …" .. string.sub(bufname, #bufname - max_len, -1)
		else
			bufname = " " .. bufname
		end
		if vim.api.nvim_buf_get_option(props.buf, "modified") then
			bufname = bufname .. " ●"
		end
		return {
			{ icon, guifg = color },
			{ bufname },
		}
	end,
	debounce_threshold = {
		falling = 50,
		rising = 10,
	},
	hide = {
		focused_win = false,
	},
	highlight = {
		groups = {
			InclineNormal = "NormalFloat",
			InclineNormalNC = "NormalFloat",
		},
	},
	ignore = {
		buftypes = "special",
		filetypes = {},
		floating_wins = true,
		unlisted_buffers = true,
		wintypes = "special",
	},
	window = {
		margin = {
			horizontal = {
				left = 1,
				right = 1,
			},
			vertical = {
				bottom = 0,
				top = 1,
			},
		},
		options = {
			signcolumn = "no",
			wrap = false,
		},
		padding = {
			left = 1,
			right = 1,
		},
		padding_char = " ",
		placement = {
			horizontal = "right",
			vertical = "top",
		},
		width = "fit",
		winhighlight = {
			active = {
				EndOfBuffer = "None",
				Normal = "InclineNormal",
				Search = "None",
			},
			inactive = {
				EndOfBuffer = "None",
				Normal = "CursorLineFold",
				Search = "None",
			},
		},
		zindex = 30,
	},
})

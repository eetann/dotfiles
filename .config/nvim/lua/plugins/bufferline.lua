return {
	"akinsho/bufferline.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({
			options = {
				close_command = "bdelete %d",
				right_mouse_command = nil,
				max_name_length = 40,
				buffer_close_icon = "",
				name_formatter = function(buf)
					if buf.path:match("%.nb/home/.*.md") then
						-- TODO: ここだけ telescopeと一致するので共通化したいかも
						local file = io.open(buf.path, "r")

						if not file then
							return
						end
						local first_line = file:read("*l")
						file:close()
						-- Markdownの見出し（# 見出し）のパターンにマッチするかチェック
						local heading = first_line:match("^#%s+(.+)")

						if heading then
							return heading
						end
					end
				end,
			},
		})
		local opts = { silent = true }

		-- Move to previous/next
		vim.keymap.set("n", "[b", ":BufferLineCyclePrev<CR>", opts)
		vim.keymap.set("n", "]b", ":BufferLineCycleNext<CR>", opts)
		-- Re-order to previous/next
		vim.keymap.set("n", "[B", ":BufferLineMovePrev<CR>", opts)
		vim.keymap.set("n", "]B", " :BufferLineMoveNext<CR>", opts)
		-- Goto buffer in position...
		vim.keymap.set("n", "<Space>1", "<Cmd>BufferLineGoToBuffer 1<CR>", opts)
		vim.keymap.set("n", "<Space>2", "<Cmd>BufferLineGoToBuffer 2<CR>", opts)
		vim.keymap.set("n", "<Space>3", "<Cmd>BufferLineGoToBuffer 3<CR>", opts)
		vim.keymap.set("n", "<Space>4", "<Cmd>BufferLineGoToBuffer 4<CR>", opts)
		vim.keymap.set("n", "<Space>5", "<Cmd>BufferLineGoToBuffer 5<CR>", opts)
		vim.keymap.set("n", "<Space>6", "<Cmd>BufferLineGoToBuffer 6<CR>", opts)
		vim.keymap.set("n", "<Space>7", "<Cmd>BufferLineGoToBuffer 7<CR>", opts)
		vim.keymap.set("n", "<Space>8", "<Cmd>BufferLineGoToBuffer 8<CR>", opts)
		vim.keymap.set("n", "<Space>9", "<Cmd>BufferLineGoToBuffer 9<CR>", opts)
		vim.keymap.set("n", "<Space>0", "<Cmd>BufferLineGoToBuffer -1<CR>", opts)

		vim.keymap.set("n", "sq", function()
			local now_bufnr = vim.fn.bufnr()
			vim.cmd([[BufferLineCycleNext]])
			vim.cmd(("bdelete %d"):format(now_bufnr))
		end, { desc = "Close current buffer without closing the current window", silent = true })
		vim.keymap.set("n", "sQ", function()
			local now_bufnr = vim.fn.bufnr()
			vim.cmd([[BufferLineCycleNext]])
			vim.cmd(("bdelete! %d"):format(now_bufnr))
		end, { desc = "Close! current buffer without closing the current window", silent = true })
		vim.keymap.set("n", "<Space><Space>", ":BufferLinePick<CR>", opts)
	end,
}

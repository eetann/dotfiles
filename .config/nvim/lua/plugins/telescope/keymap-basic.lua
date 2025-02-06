local utils = require("plugins.telescope.utils")

-- vim.keymap.set("n", "<space>fb", "<Cmd>Telescope buffers<CR>")
-- vim.keymap.set("n", "<space>fh", "<Cmd>Telescope help_tags<CR>")
-- vim.keymap.set("n", "<F6>", "<Cmd>Telescope git_files cwd=~/dotfiles<CR>")
-- vim.keymap.set("n", "<space>fl", "<Cmd>Telescope highlights<CR>")
-- vim.keymap.set("n", "<space>fd", "<Cmd>Telescope diagnostics<CR>")
-- vim.keymap.set("n", "<space>fr", "<Cmd>Telescope resume<CR>")

-- ファイル検索---------------------------------------------------
local function project_files(text, use_git_root)
	local ok = pcall(
		require("telescope.builtin").git_files,
		{ default_text = text, show_untracked = true, use_git_root = use_git_root }
	)
	if not ok then
		require("telescope.builtin").find_files({ default_text = text, hidden = true })
	end
end

vim.keymap.set("n", "<space>ff", function()
	project_files("", false)
end, { desc = "ファイル検索: モノレポでプロジェクト毎に見る" })

vim.keymap.set("v", "<space>ff", function()
	local text = utils.get_visual_selection()
	project_files(text, false)
end, { desc = "ファイル検索: モノレポでプロジェクト毎に見る" })

vim.keymap.set("n", "<space>fF", function()
	project_files("", true)
end, { desc = "ファイル検索: モノレポで全体を見る" })

vim.keymap.set("v", "<space>fF", function()
	local text = utils.get_visual_selection()
	project_files(text, true)
end, { desc = "ファイル検索: モノレポで全体を見る" })

vim.keymap.set("n", "<space>fc", function()
	require("telescope.builtin").find_files({ cwd = require("telescope.utils").buffer_dir() })
	-- TODO: 下の階層は検索させない
end, { desc = "ファイル検索: 同階層にあるファイル一覧" })

-- grep-----------------------------------------------------------
vim.keymap.set("n", "<space>fg", function()
	require("telescope.builtin").live_grep()
end, { desc = "live grep" })

vim.keymap.set("v", "<space>fg", function()
	local text = utils.get_visual_selection()
	require("telescope.builtin").live_grep({ default_text = text })
end, { desc = "live grep" })

vim.keymap.set("n", "<space>fG", function()
	require("telescope.builtin").live_grep({
		prompt_title = "Live Grep(no regexp)",
		additional_args = function()
			return { "--hidden", "--fixed-strings", "--glob='!public/*'" }
		end,
	})
end, { desc = "live grep: public無し" })

vim.keymap.set("v", "<space>fG", function()
	local text = utils.get_visual_selection()
	require("telescope.builtin").live_grep({
		prompt_title = "Live Grep(no regexp)",
		default_text = text,
		additional_args = function()
			return { "--hidden", "--fixed-strings", "--glob='!public/*'" }
		end,
	})
end, { desc = "live grep: public無し" })

vim.keymap.set("n", "<space>ft", function()
	require("telescope.builtin").live_grep({ default_text = "todo:" })
end, { desc = "TODO検索" })

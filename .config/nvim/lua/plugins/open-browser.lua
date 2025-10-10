return {
	{
		"tyru/open-browser.vim",
		cmd = {
			"OpenPreviewMdn",
			"OpenPreviewMdnSelect",
			"OpenBlog",
		},
		keys = {
			{ "gx", "<Plug>(openbrowser-smart-search)", mode = { "n", "v" }, silent = true },
		},
		init = function()
			vim.g.netrw_nogx = 1 -- disable netrw's gx mapping.
		end,
		config = function()
			vim.cmd([[
      function! MyOpens()
      execute 'OpenBrowser ' . substitute(expand('%:p'), '\v/mnt/(.)', '\1:/', 'c')
      endfunction
]])

			local function open_preview_mdn_web_docs(select_language)
				local port = 5042
				local language = nil
				local fullPath = vim.fn.expand("%:p")

				if vim.bo.filetype ~= "markdown" then
					print("Markdown Only")
					do
						return
					end
				end

				-- 言語を選択
				if select_language then
					vim.ui.select({ "English", "Japanese", "French" }, {
						prompt = "Select language:",
					}, function(choice)
						if choice == "English" then
							language = "en-US"
						elseif choice == "Japanese" then
							language = "ja"
						elseif choice == "French" then
							language = "fr"
						end
					end)
					-- 選択をキャンセルした場合は終了
					if language == nil then
						print("See you")
						do
							return
						end
					end
				else
					-- パスから言語を取得
					language = string.match(fullPath, ".*files/(.-)/")
					if language == nil then
						language = "en-US"
					end
				end

				-- slugを取得
				local slug = ""
				local file = io.open(fullPath, "r")
				if file == nil then
					do
						return
					end
				end
				local count = 1
				for line in file:lines() do
					local cap = string.match(line, "slug: (.*)")
					if cap ~= nil then
						slug = cap
						break
					end
					count = count + 1
					if 10 < count then
						break
					end
				end
				file:close()
				local url = string.format("http://localhost:%d/%s/docs/%s", port, language, slug)
				vim.cmd(string.format("OpenBrowser %s", url))
			end

			vim.api.nvim_create_user_command("OpenPreviewMdn", function()
				open_preview_mdn_web_docs()
			end, {})

			vim.api.nvim_create_user_command("OpenPreviewMdnSelect", function()
				open_preview_mdn_web_docs(true)
			end, {})
		end,
	},
	{
		"tyru/open-browser-github.vim",
		dependencies = { "tyru/open-browser.vim" },
		keys = {
			{
				"<Space>gh",
				":OpenGithubFile<CR>",
				mode = { "n", "v" },
				silent = true,
				desc = "現在のファイルをGitHubで開く",
			},
		},
	},
}

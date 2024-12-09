local cmp = require("cmp")
local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end
return {
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
	-- 先頭の大文字小文字を切り替える
	["<C-v>"] = cmp.mapping(function()
		if cmp.visible() then
			cmp.confirm()
			vim.defer_fn(function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>mzBvg~`za", true, false, true), "in", false)
			end, 10)
		end
	end, { "i", "s" }),
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
}

---@module "lazy"
---@type LazyPluginSpec
return {
	"yuki-yano/clipboard-image-to-agent.nvim",
	cond = vim.env.EDITPROMPT == "1",
	config = function()
		local clip = require("clipboard_image_to_agent")
		clip.setup() -- override defaults here if you need custom options
	end,
	keys = {
		{
			"<C-g>v",
			function()
				vim.notify("clip")
				local clip = require("clipboard_image_to_agent")
				local ok, err = clip.paste()
				if not ok and err then
					vim.notify(err, vim.log.levels.WARN, { title = "clipboard-image-to-agent.nvim" })
				else
					vim.notify("yes")
				end
			end,
			mode = "i",
			desc = "Paste clipboard image path",
		},
	},
}

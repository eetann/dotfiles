local jpKakkoTable = {
	["("] = { left = "（", right = "）" },
	[")"] = { left = "（", right = "）" },
	["8"] = { left = "（", right = "）" },
	["9"] = { left = "（", right = "）" },
	["["] = { left = "［", right = "］" },
	["]"] = { left = "［", right = "］" },
	["B"] = { left = "［", right = "］" },
	["}"] = { left = "｛", right = "｝" },
	["{"] = { left = "｛", right = "｝" },
	["<"] = { left = "＜", right = "＞" },
	[">"] = { left = "＜", right = "＞" },
	["k"] = { left = "「", right = "」" },
	["K"] = { left = "『", right = "』" },
	["y"] = { left = "〈", right = "〉" },
	["Y"] = { left = "《", right = "》" },
	["r"] = { left = "【", right = "】" },
	["s"] = { left = "【", right = "】" },
	["t"] = { left = "〔", right = "〕" },
	["a"] = { left = "＜", right = "＞" },
	["A"] = { left = "≪", right = "≫" },
}
local surround = require("mini.surround")
surround.setup({
	custom_surroundings = {
		["j"] = {
			input = function()
				local char = surround.user_input("enter for KAKKO: ")
				local pair = jpKakkoTable[char]
				if pair == nil then
					error("j" .. char .. " is unsupported :(")
				end
				return { pair.left .. "().-()" .. pair.right }
			end,
			output = function()
				local char = surround.user_input("enter for KAKKO: ")
				local pair = jpKakkoTable[char]
				if pair == nil then
					error("j" .. char .. " is unsupported :(")
				end
				return pair
			end,
		},
		["B"] = {
			input = { "%*%*().-()%*%*" },
			output = { left = "**", right = "**" },
		},
	},
	mappings = {
		highlight = "sH", -- Highlight surrounding
	},
})

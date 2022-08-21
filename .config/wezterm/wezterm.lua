local wezterm = require("wezterm")

local function append_table(table, other)
	for k, v in pairs(other) do
		table[k] = v
	end
end

local function append_array(array, other)
	for _, value in ipairs(other) do
		table.insert(array, value)
	end
end

local key_table = {
	{ key = ";", mods = "CTRL", action = "IncreaseFontSize" },
	{ key = "+", mods = "CTRL", action = "IncreaseFontSize" },
	{ key = "-", mods = "CTRL", action = "DecreaseFontSize" },
	{ key = "0", mods = "CTRL", action = "ResetFontSize" },
}

local target = wezterm.target_triple

if target:find("darwin") then
	local mac_key_table = {
		{ key = "n", mods = "CMD", action = { SendKey = { key = "n", mods = "ALT" } } },
		{ key = "p", mods = "CMD", action = { SendKey = { key = "p", mods = "ALT" } } },
	}
	append_array(key_table, mac_key_table)
elseif target:find("linux") then
	local linux_key_table = {
		{ key = "n", mods = "SUPER", action = { SendKey = { key = "n", mods = "ALT" } } },
		{ key = "p", mods = "SUPER", action = { SendKey = { key = "p", mods = "ALT" } } },
	}
	append_array(key_table, linux_key_table)
end

return {
	font = wezterm.font("HackGen Console NFJ"),
	use_ime = true,
	font_size = 14,
	color_scheme = "Gruvbox Dark",
	hide_tab_bar_if_only_one_tab = true,
	adjust_window_size_when_changing_font_size = false,
	keys = key_table,
	-- NOTE: 最小構成を作れておらず未調査だけど、hyperlinkがオンになるとマルチバイトで崩れるっぽいのでオフにする
	hyperlink_rules = {},
}

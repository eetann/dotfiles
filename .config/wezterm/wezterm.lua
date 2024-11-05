local wezterm = require("wezterm")
local act = wezterm.action
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

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
		{ key = "h", mods = "OPT", action = { SendKey = { key = "h", mods = "ALT" } } },
		{ key = "l", mods = "OPT", action = { SendKey = { key = "l", mods = "ALT" } } },
		{ key = "n", mods = "OPT", action = { SendKey = { key = "n", mods = "ALT" } } },
		{ key = "p", mods = "OPT", action = { SendKey = { key = "p", mods = "ALT" } } },
		{ key = "¥", action = wezterm.action.SendKey({ key = "\\" }) },
	}
	append_array(key_table, mac_key_table)
	config.font_size = 14.0
	config.send_composed_key_when_left_alt_is_pressed = true
elseif target:find("linux") then
	local linux_key_table = {
		{ key = "n", mods = "SUPER", action = { SendKey = { key = "n", mods = "ALT" } } },
		{ key = "p", mods = "SUPER", action = { SendKey = { key = "p", mods = "ALT" } } },
	}
	append_array(key_table, linux_key_table)
else
	config.default_domain = "WSL:Ubuntu" -- wsl -l -v
	local wsl_key_table = {
		{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
	}
	append_array(key_table, wsl_key_table)
	config.font_size = 12.0
end

-- /mnt/c/Program\ Files/WezTerm/wezterm.exe ls-fonts
config.font = wezterm.font_with_fallback({
	{ family = "HackGen Console NF" },
	{ family = "SauceCodePro Nerd Font Mono" },
})
config.use_ime = true
config.color_scheme = "Gruvbox Dark (Gogh)"
config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.keys = key_table
config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
	regex = "\\b\\w+://(?:[\\w.-]+):\\d+\\S*\\b",
	format = "$0",
})

return config

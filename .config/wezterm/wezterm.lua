local wezterm = require("wezterm")
local act = wezterm.action
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
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
	{
		key = "f",
		mods = "SHIFT|META",
		action = wezterm.action.ToggleFullScreen,
	},
}

local target = wezterm.target_triple

if target:find("darwin") then
	local mac_key_table = {
		{ key = "n", mods = "CMD", action = wezterm.action.Nop },
		{ key = "p", mods = "CMD", action = wezterm.action.Nop },
		{ key = "w", mods = "CMD", action = wezterm.action.Nop },
		{ key = "h", mods = "OPT", action = { SendKey = { key = "h", mods = "ALT" } } },
		{ key = "l", mods = "OPT", action = { SendKey = { key = "l", mods = "ALT" } } },
		{ key = "n", mods = "OPT", action = { SendKey = { key = "n", mods = "ALT" } } },
		{ key = "o", mods = "OPT", action = { SendKey = { key = "o", mods = "ALT" } } },
		{ key = "p", mods = "OPT", action = { SendKey = { key = "p", mods = "ALT" } } },
		{ key = "q", mods = "OPT", action = { SendKey = { key = "q", mods = "ALT" } } },
		{ key = "s", mods = "OPT", action = { SendKey = { key = "s", mods = "ALT" } } },
		{ key = "¥", action = wezterm.action.SendKey({ key = "\\" }) },
	}
	append_array(key_table, mac_key_table)
	config.font_size = 14.0
	config.send_composed_key_when_left_alt_is_pressed = true
	-- フルスクリーン
	wezterm.on("gui-startup", function(cmd)
		local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
		window:gui_window():toggle_fullscreen()
	end)
	config.window_background_opacity = 0.85
	config.macos_window_background_blur = 20
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
	config.font_size = 10.0
	-- config.window_background_opacity = 0.6
	config.window_background_gradient = {
		orientation = { Linear = { angle = -45.0 } },
		colors = {
			"#0f3443",
			"#0f3443",
			"#182848",
		},
	}
	config.win32_system_backdrop = "Acrylic"
end

-- /mnt/c/Program\ Files/WezTerm/wezterm.exe ls-fonts
config.font = wezterm.font_with_fallback({
	{ family = "HackGen Console NF" },
	{ family = "SauceCodePro Nerd Font Mono" },
})
config.font_rules = {
	{
		italic = true,
		font = wezterm.font_with_fallback({ "PlemolJP Console NF" }),
	},
}
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

wezterm.on("bell", function(window, pane)
	window:toast_notification("Claude Code", "Task completed", nil, 4000)
end)
config.audible_bell = "SystemBeep"

return config

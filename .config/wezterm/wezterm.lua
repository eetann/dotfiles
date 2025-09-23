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
	{
		key = "e",
		mods = "OPT",
		action = wezterm.action_callback(function(window, pane)
			local target_pane_id = tostring(pane:pane_id())
			window:perform_action(
				act.SplitPane({
					direction = "Down",
					size = { Cells = 10 },
				}),
				pane
			)
			wezterm.time.call_after(1, function()
				window:perform_action(
					act.SendString(
						string.format(
							"bun run ~/ghq/github.com/eetann/editprompt/dist/index.js --editor nvim -m wezterm --target-pane %s\n",
							target_pane_id
						)
					),
					window:active_pane()
				)
			end)
		end),
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
		{ key = "t", mods = "OPT", action = { SendKey = { key = "t", mods = "ALT" } } },
		{ key = "z", mods = "OPT", action = { SendKey = { key = "z", mods = "ALT" } } },
		{ key = "¥", action = wezterm.action.SendKey({ key = "\\" }) },
	}
	append_array(key_table, mac_key_table)
	config.font_size = 14.0
	config.send_composed_key_when_left_alt_is_pressed = true
	-- フルスクリーン
	wezterm.on("gui-startup", function(cmd)
		local _, _, window = wezterm.mux.spawn_window(cmd or {})
		window:gui_window():maximize()
	end)
	config.window_background_opacity = 0.80
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
	{ family = "HackGen Console NF", italic = false },
	{ family = "SauceCodePro Nerd Font Mono" },
})
-- italicだとフォントサイズが小さい時に「が」や「証」などがかなり小さくなってしまうため
-- 別フォントの非italicのLightに変更
local italic_font = "PlemolJP Console NF"
config.font_rules = {
	{
		intensity = "Normal",
		italic = true,
		font = wezterm.font(italic_font, {
			weight = "DemiLight",
			style = "Normal",
		}),
	},
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font(italic_font, {
			weight = "Bold",
			style = "Normal",
		}),
	},
	{
		intensity = "Half",
		italic = true,
		font = wezterm.font(italic_font, {
			weight = "Light",
			style = "Normal",
		}),
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

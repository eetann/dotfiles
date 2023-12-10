local wezterm = require 'wezterm'
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
else
  config.default_domain = 'WSL:Ubuntu' -- wsl -l -v
  local wsl_key_table = {
    { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom 'Clipboard' },
  }
  append_array(key_table, wsl_key_table)
end

config.font = wezterm.font("HackGen Console NF")
config.use_ime = true
config.font_size = 13.0
config.color_scheme = 'Gruvbox Dark (Gogh)'
config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.keys = key_table
-- NOTE: 最小構成を作れておらず未調査だけど、hyperlinkがオンになるとマルチバイトで崩れるっぽいのでオフにする
config.hyperlink_rules = {}

return config

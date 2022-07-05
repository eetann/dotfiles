local wezterm = require 'wezterm';

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
  { key = ';', mods = 'CTRL', action = 'IncreaseFontSize' },
  { key = '+', mods = 'CTRL', action = 'IncreaseFontSize' },
  { key = '-', mods = 'CTRL', action = 'DecreaseFontSize' },
  { key = '0', mods = 'CTRL', action = 'ResetFontSize' },
}

local mac = wezterm.target_triple:find('darwin')

if mac then
  local mac_key_table = {
    { key = 'n', mods = 'CMD', action = { SendKey = { key = 'n', mods = 'ALT' } } },
    { key = 'p', mods = 'CMD', action = { SendKey = { key = 'p', mods = 'ALT' } } },
  }
  append_array(key_table, mac_key_table)
end

return {
  font = wezterm.font('HackGenNerd Console'),
  use_ime = true,
  font_size = 14,
  color_scheme = 'Gruvbox Dark',
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  keys = key_table,
}

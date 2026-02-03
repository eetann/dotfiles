local wezterm = require("wezterm")
local act = wezterm.action
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

wezterm.on("editprompt-dump", function(window, pane)
  local text = window:get_selection_text_for_pane(pane)
  -- wezterm.log_info("selection is: " .. text)
  local target_pane_id = tostring(pane:pane_id())
  local editprompt_cmd = "node "
    .. os.getenv("HOME")
    .. "/ghq/github.com/eetann/editprompt/dist/index.js"
  -- local editprompt_cmd = "editprompt"

  wezterm.run_child_process({
    "/bin/zsh",
    "-lc",
    string.format(
      "%s collect --mux wezterm --target-pane %s -- %s",
      editprompt_cmd,
      target_pane_id,
      wezterm.shell_quote_arg(text) -- エスケープして位置引数として渡す
    ),
  })
end)

local function append_array(array, other)
  for _, value in ipairs(other) do
    table.insert(array, value)
  end
end

local function opt_to_alt(key)
  return {
    key = key,
    mods = "OPT",
    action = { SendKey = { key = key, mods = "ALT" } },
  }
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
      local editprompt_cmd = "node "
        .. os.getenv("HOME")
        .. "/ghq/github.com/eetann/editprompt/dist/index.js"
      -- local editprompt_cmd = "editprompt"

      -- resumeを試す
      local success, stdout, stderr = wezterm.run_child_process({
        "/bin/zsh",
        "-lc",
        string.format(
          "%s resume --mux wezterm --target-pane %s",
          editprompt_cmd,
          target_pane_id
        ),
      })

      -- resumeが失敗したらエディタペインを開く
      if not success then
        wezterm.log_error("editprompt info: " .. tostring(stdout))
        wezterm.log_error(
          "editprompt error: "
            .. (tostring(stderr) ~= "" and tostring(stderr) or "unknown error")
        )
        window:perform_action(
          act.SplitPane({
            direction = "Down",
            size = { Cells = 10 },
            command = {
              args = {
                "/bin/zsh",
                "-lc",
                string.format(
                  "%s open --editor nvim --always-copy --mux wezterm --target-pane %s",
                  editprompt_cmd,
                  target_pane_id
                ),
              },
              set_environment_variables = {
                NO_TMUX = "true",
              },
            },
          }),
          pane
        )
      end
    end),
  },
  {
    key = "e",
    mods = "CMD",
    action = wezterm.action.EmitEvent("editprompt-dump"),
  },
}

local target = wezterm.target_triple

if target:find("darwin") then
  local mac_key_table = {
    { key = "n", mods = "CMD", action = wezterm.action.Nop },
    { key = "p", mods = "CMD", action = wezterm.action.Nop },
    { key = "w", mods = "CMD", action = wezterm.action.Nop },
    {
      key = "_",
      mods = "CTRL",
      action = { SendKey = { key = "_", mods = "CTRL" } },
    },
    opt_to_alt("j"),
    opt_to_alt("k"),
    opt_to_alt("h"),
    opt_to_alt("l"),
    opt_to_alt("n"),
    opt_to_alt("o"),
    opt_to_alt("p"),
    opt_to_alt("q"),
    opt_to_alt("s"),
    opt_to_alt("t"),
    opt_to_alt("z"),
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
    {
      key = "n",
      mods = "SUPER",
      action = { SendKey = { key = "n", mods = "ALT" } },
    },
    {
      key = "p",
      mods = "SUPER",
      action = { SendKey = { key = "p", mods = "ALT" } },
    },
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
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.keys = key_table
config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
  regex = "\\b\\w+://(?:[\\w.-]+):\\d+\\S*\\b",
  format = "$0",
})
--
-- wezterm.on("bell", function(window, pane)
-- 	window:toast_notification("Claude Code", "Task completed", nil, 4000)
-- end)
config.audible_bell = "SystemBeep"

return config

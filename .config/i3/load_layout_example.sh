#!/usr/bin/env bash

# cp ~/dotfiles/.config/i3/load_layout_example.sh ~/load_layout.sh
# chmod u+x ~/load_layout.sh

i3-msg "workspace 1; append_layout ~/dotfiles/.config/i3/workspace_1.json"
(LANG=ja_jp.UTF8 vivaldi-stable --profile-directory=Default --app-id=ddiddklncfgbfaaahngklemobghhjkim &)
(wezterm &)
i3-msg '[class="^org\\.wezfurlong\\.wezterm$"] focus'

i3-msg "workspace 2; append_layout ~/dotfiles/.config/i3/workspace_2.json"
(LANG=ja_jp.UTF8 vivaldi-stable --profile-directory=Default &)
i3-msg 'workspace 2'

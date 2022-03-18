#!/usr/bin/env bash

# cp ~/dotfiles/.config/i3/load_layout_example.sh ~/load_layout.sh
# mkdir -p ~/.i3
# cp ~/dotfiles/.config/i3/workspace_1.json ~/.i3/workspace_1.json
# cp ~/dotfiles/.config/i3/workspace_2.json ~/.i3/workspace_2.json
# chmod u+x ~/load_layout.sh

# First we append the saved layout of worspace N to workspace M
i3-msg "workspace 1; append_layout ~/.i3/workspace_1.json"
i3-msg "workspace 2; append_layout ~/.i3/workspace_2.json"

# And finally we fill the containers with the programs they had
(LANG=ja_jp.UTF8 vivaldi-stable --profile-directory=Default --app-id=xxxxxxxxxxxxxxxxxxx &)
(alacritty &)
(LANG=ja_jp.UTF8 vivaldi-stable --profile-directory=Default &)
i3-msg '[title="Alacritty"] focus'
i3-msg 'workspace 2'

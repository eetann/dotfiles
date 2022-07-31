# LinuxでMac風のキーバインドにする
[k0kubun/xremap](https://github.com/k0kubun/xremap)を使った。

| 物理キー | 入れ替え後 | mod     | 役割      | i3   | Wezterm |
|----------|------------|---------|-----------|------|---------|
| ALT_L    | SUPER_R    | mod4    | Win       | mod4 | Alt     |
| Ctrl_L   | ALT_L      | mod1    | Alt       | mod1 | Alt     |
| CapsLock | SUPER_L    | mod3    | MacのCtrl | なし | Ctrl    |
| SUPER_L  | CTRL_L     | control | CTRL      | なし | Ctrl    |

まず、公式のREADMEどおりにインストール。
AURの`xremap-x11-bin`だとなぜかエラーが出るので、`cargo install xremap --features x11`のほうにした。

```sh
nvim /etc/modules-load.d/uinput.conf
```

```
uinput
```

```sh
echo 'KERNEL=="uinput", GROUP="input", MODE="0660"' | sudo tee /etc/udev/rules.d/99-input.rules
```

設定ファイルを書く。

```yaml
modmap:
  - name: Except Wezterm
    application:
      not: org.wezfurlong.wezterm
    remap:
      ALT_L: SUPER_R
      CTRL_L: ALT_L
      CapsLock: SUPER_L
      SUPER_L: CTRL_L
  - name: Only Wezterm
    application:
      only: org.wezfurlong.wezterm
    remap:
      ALT_L: SUPER_R
      CTRL_L: ALT_L
      CapsLock: CTRL_L
      SUPER_L: CTRL_L
keymap:
  - name: Except Wezterm
    application:
      not: org.wezfurlong.wezterm
    remap:
      SUPER_L-a: home
      SUPER_L-e: end
      SUPER_L-h: backspace
      SUPER_L-d: delete
      SUPER_L-f: right
      SUPER_L-b: left
      SUPER_L-p: up
      SUPER_L-n: down
      SUPER_L-k: [Shift-end, backspace]
      SUPER_L-Tab: CTRL-Tab
      SUPER_L-Shift-Tab: CTRL-Shift-Tab
```

さらに、以下の記事を参考にして自動起動。
[xremapをsystemctlで自動起動するメモ | hyoshi(hara) log](https://blog.bomberowl.org/posts/427/)

```sh
nvim ~/.config/systemd/user/xremap.service
```

```toml:~/.config/systemd/user/xremap.service
[Unit]
Description=xremap

[Service]
KillMode=process
ExecStart=/home/eetann/.cargo/bin/xremap /home/eetann/dotfiles/etc/xremap.yaml
ExecStop=/usr/bin/killall xremap
Restart=always
Environment=DISPLAY=:0.0

[Install]
WantedBy=default.target
```

```sh
systemctl --user daemon-reload
systemctl --user start xremap
systemctl --user enable xremap
# 以下は不要かもしれない
sudo chown -R $(whoami) /home/eetann/.cargo/
```

modの割当も変える。

```sh
nvim ~/.Xmodmap
```

```
clear mod3
clear mod4
add mod3 = Super_L
add mod4 = Super_R
```

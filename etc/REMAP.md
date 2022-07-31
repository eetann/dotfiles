Arch Linuxで行うRemapには、[k0kubun/xremap](https://github.com/k0kubun/xremap)を使う。

```sh
/etc/modules-load.d/uinput.conf
```

```
uinput
```

```
echo 'KERNEL=="uinput", GROUP="input", MODE="0660"' | sudo tee /etc/udev/rules.d/99-input.rules
```

```sh
nvim ~/.config/systemd/user/xremap.service
systemctl --user daemon-reload
systemctl --user start xremap
systemctl --user enable xremap
# 以下は不要かもしれない
sudo chown -R $(whoami) /home/eetann/.cargo/
```

```toml
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

# dotfiles  
dotfilesのレポジトリです。
WSL2のUbuntuメインだったけどMacに移行中

**TODO: このREADMEをもう少しシェルスクリプトに移す**

##
```
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

# Windows
[アプリ インストーラー - Microsoft Apps](https://apps.microsoft.com/detail/9nblggh4nns1?rtc=1&hl=ja-jp&gl=JP)

## WSL上でWezTerm/tmuxの特定のAltキーショートカットだけ効かない

一部のAltキー（例: `Alt+z`）だけ反応せず、他のAltキー（`Alt+n`等）は動く場合、
GPUベンダー製ソフトのグローバルオーバーレイホットキーに奪われている可能性が高い。

- **AMD Software: Adrenalin Edition**: デフォルトで`Alt+Z`がオーバーレイ起動キー
- **NVIDIA App / GeForce Experience**: 同じくデフォルトで`Alt+Z`がオーバーレイ起動キー

いずれもアプリの設定画面からホットキーを変更 or 無効化すれば直る。

### 切り分け方法

1. tmuxまで届いているか: 該当キーを一時的に`display-message`に差し替えて確認
   ```
   bind-key -n M-z display-message "reached tmux"
   ```
2. WezTermまで届いているか: `wezterm.lua`のキーバインドに`wezterm.log_info(...)`を仕込み、
   Debug Overlay（`Ctrl+Shift+L`）でログが出るか確認
3. どちらにも届いていなければWindows側の常駐アプリ（GPUベンダー製ソフト、Discord、
   ゲーミングデバイスソフト、PowerToys等）のグローバルホットキーを疑う

# Installation
## Font
1. download font
    + [白源](https://github.com/yuru7/HackGen/releases) or 
    + [Cica](https://github.com/miiton/Cica/releases)
    + [PlemolJP Console NF](https://github.com/yuru7/PlemolJP/releases)
2. Install to OS
3. Set to terminal

# Google日本語入力
[Google日本語入力](https://www.google.co.jp/ime/)

## Write /etc/wsl.conf
WSLならこれをやること。

デフォルトの設定では、WSLのパスにWindowsのパスがたくさん追加されてしまう。  
この設定をオフにするためには、
以下のコマンドで `/etc/wsl.conf` を変更
```sh
echo -e "[interop]\nappendWindowsPath = false\n[boot]\nsystemd=true" | sudo tee /etc/wsl.conf
exec $SHELL -l
# change Japan's repository from overseas for speed
yes | sudo dpkg-reconfigure tzdata
yes | sudo sed -i -e 's%http://.*.ubuntu.com%http://ftp.jaist.ac.jp/pub/Linux%g' /etc/apt/sources.list
```

```powershell
wsl --shutdown
```

<details>
<summary>Q. `tee`とは?</summary>
標準入力で受け取った内容をファイルに出力するコマンド。
</details>

## git and GitHub
```sh
sudo apt install git build-essential curl
```

<details>
<summary>gitの設定</summary>

+ [新しい SSH キーを生成して ssh-agent に追加する - GitHub Docs](https://docs.github.com/ja/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

```sh
git config --global user.name "eetann"
git config --global user.email "eetann's mail adress"
git config --global github.user eetann
git config --global init.defaultBranch main
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global merge.conflictStyle zdiff3
git config --global delta.navigate true
git config --global delta.diff-so-fancy true
git config --global delta.keep-plus-minus-markers true
git config --global delta.line-numbers true
git config --global delta.hunk-header-style "omit"
ssh-keygen -t rsa -b 4096 -C "eetann's mail adress"
```
several times `<CR>`

WSL:
```sh
cat ~/.ssh/id_rsa.pub | clip.exe
```

Ubuntu:
```sh
sudo apt install xsel
cat ~/.ssh/id_rsa.pub | xsel -ib
```

You need to resist the key.

```sh
ssh -T git@github.com
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa
cd ~/dotfiles
git remote set-url origin git@github.com:eetann/dotfiles.git
```

</details>

## Execute the command
Mac: [macOS（またはLinux）用パッケージマネージャー — Homebrew](https://brew.sh/index_ja)

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/eetann/dotfiles/master/etc/setup) --init"
```

## nix-darwin + home-manager（macOSシステム設定 + dotfiles管理）

nix-darwinでmacOSのシステム設定（Dock、Finder、キーボード等）を、home-managerで設定ファイルのシンボリックリンクを宣言的に管理する。

### 初回セットアップ（Mac）

```sh
# Nixインストール（まだの場合）
sh <(curl -L https://nixos.org/nix/install)

# dotfilesをクローン（まだの場合）
git clone https://github.com/eetann/dotfiles.git ~/dotfiles

# nix-darwin + home-manager 初回適用
sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin/master#darwin-rebuild -- switch --flake ~/dotfiles#eetann-mac
```

### 以降の更新

```sh
sudo darwin-rebuild switch --flake ~/dotfiles
```

### home-manager単体で使う場合

```sh
# 初回
nix run home-manager/master -- switch --flake ~/dotfiles

# 以降
home-manager switch --flake ~/dotfiles
```

### 世代管理

```sh
# darwin世代一覧
darwin-rebuild --list-generations

# home-manager世代一覧
home-manager generations

# 前の世代に戻す
sudo darwin-rebuild switch --rollback
home-manager switch --rollback
```

## NixOS-WSL + home-manager（WSL上のシステム設定 + dotfiles管理）

NixOS-WSLでは`nixos-rebuild switch`一発でシステム設定とdotfilesの両方が適用される
（`make deploy`は使わない。standalone home-managerと二重管理するとhome-manager世代が競合するため）。

### 初回セットアップ（NixOS-WSL）

```sh
# gitがまだ無いので、一時的にnix-shellで取得してclone
nix-shell -p git --run "git clone https://github.com/eetann/dotfiles.git ~/dotfiles"
cd ~/dotfiles

# 初回のみexperimental-featuresの指定が必要（flakesがまだ有効化されていないため）
# nixos-rebuildは--extra-experimental-featuresを受け付けないのでNIX_CONFIGで渡す
sudo NIX_CONFIG="experimental-features = nix-command flakes" \
  nixos-rebuild switch --flake .#eetann-wsl
```

Linuxユーザー名を`eetann`にするには、`wsl.defaultUser`変更時の公式手順
（`sudo nixos-rebuild boot --flake ~/dotfiles#eetann-wsl` → Windows側で`wsl -t NixOS` →
`wsl -d NixOS --user root exit` → 再度`wsl -t NixOS` → `wsl -d NixOS`で開き直す）に従うこと。

### 以降の更新

```sh
sudo nixos-rebuild switch --flake ~/dotfiles#eetann-wsl
```

`make init`（Homebrew）・`make deploy`（standalone home-manager）はmacOS専用です。
NixOS-WSLでは実行しないでください。

## zsh
```sh
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s "$(command -v zsh)" "${USER}O
zsh
```

## Install tmux

1. install tmux plugins with the above command
2. launch tmux = `tmux`
3. enter `prefix(maybe ctrl + s or ctrl + b) + U` to install tmux manager.
4. enter `all`
5. enter `prefix(maybe ctrl + s or ctrl + b) + I` to install tmux plugins.

# for autohotkey
Windowsのキーボード操作変更のためのスクリプト`likevim.ahk`を使うには、ファイルをスタートアップに登録する必要がある。

1. `likevim.ahk`のコピーまたはショートカットを作成
2. `Win + r`を入力
3. `shell:startup`を入力すると、スタートアップのフォルダが開く
4. 1で作成したショートカットをスタートアップのフォルダに移動


# Ubuntu
## Super-pの入力でディスプレイ設定が戻ってしまう問題
```sh
sudo apt install dconf-editor
dconf-editor
```

もし`dconf-editor`が開けなかったら`DISPLAY`の値を見直すこと。たぶん`export DISPLAY=:0.0`とかで開ける。

dconf-editor の
`/org/gnome/mutter/keybindings/switch-monitor` で
デフォルト設定を無効にして、`['<Super>p', 'XF86Display']`を`[]`に変更
もし`/org/gnome/settings-daemon/plugins/media-keys/video-out`もあったら同様にカスタマイズ

参考
[gnome - How to disable global Super-p shortcut? - Ask Ubuntu](https://askubuntu.com/questions/68463/how-to-disable-global-super-p-shortcut)

# Mac
KarabinerでESCのときにIMEをオフにする
[Karabiner-ElementsでESCやCtrl+括弧キー押下時に日本語入力を解除できるようになっていた - 絶品ゆどうふのタレ](https://yudoufu.hatenablog.jp/entry/2018/01/14/215152)

# 取り消し線が有効にならない

解決方法をあとでブログ書く

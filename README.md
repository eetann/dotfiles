# dotfiles  
dotfilesのレポジトリです。
WSL2のUbuntuがメインですが、純Ubuntuでも動作するように少しずつ書き換えを進めています。

**TODO: このREADMEをもう少しシェルスクリプトに移す**

# Installation
## Font
1. download font
    + [白源](https://github.com/yuru7/HackGen/releases) or 
    + [Cica](https://github.com/miiton/Cica/releases)
    + [PlemolJP Console NF](https://github.com/yuru7/PlemolJP/releases)
2. Install to OS
3. Set to terminal

## Write /etc/wsl.conf
WSLならこれをやること。

デフォルトの設定では、WSLのパスにWindowsのパスがたくさん追加されてしまう。  
この設定をオフにするためには、
以下のコマンドで `/etc/wsl.conf` を変更
```sh
echo -e "[interop]\nappendWindowsPath = false" | sudo tee /etc/wsl.conf
exec $SHELL -l
# change Japan's repository from overseas for speed
yes | sudo dpkg-reconfigure tzdata
yes | sudo sed -i -e 's%http://.*.ubuntu.com%http://ftp.jaist.ac.jp/pub/Linux%g' /etc/apt/sources.list
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

## zsh
```sh
chsh -s /usr/bin/zsh
zsh
```
```sh
bash ~/dotfiles/etc/init/oh-my-zsh.sh
```

## Install tmux

1. install tmux plugins with the above command
2. launch tmux = `tmux`
3. enter `prefix(maybe ctrl + s or ctrl + b) + U` to install tmux plugins.
4. enter `all`

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


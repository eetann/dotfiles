# dotfiles  
dotfilesのレポジトリです。
WSL2のUbuntuがメインですが、純Ubuntuでも動作するように少しずつ書き換えを進めています。

**TODO: このREADMEをもう少しシェルスクリプトに移す**

# Installation
## 最初にやっておくこと
1. download [白源](https://github.com/yuru7/HackGen/releases) or 
[Cica](https://github.com/miiton/Cica)
2. Install to OS
3. Set to terminal

## Write /etc/wsl.conf
WSLならこれをやること。

デフォルトの設定では、WSLのパスにWindowsのパスがたくさん追加されてしまう。  
この設定をオフにするためには、
以下のコマンドで `/etc/wsl.conf` を変更
```sh
echo "[interop]\nappendWindowsPath = false" | sudo tee /etc/wsl.conf
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
git config --global user.name "eetann"
git config --global user.email "eetann's mail adress"
ssh-keygen -t rsa -b 4096 -C "eetann's mail adress"
```
数回 `<CR>`

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
```

## Execute the command
```sh
sudo apt install git make
```

```sh
git clone https://github.com/eetann/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles
make install
```


## Install tmux

1. install tmux plugins with the above command
2. launch tmux = `tmux`
3. enter `prefix(maybe ctrl + s or ctrl + b) + U` to install tmux plugins.
4. enter `all`

# for autohotkey
Windowsのキーボード操作変更のためのスクリプト`likevim.ahk`を使うには、ファイルをスタートアップに登録する必要がある。

1. `likevim.ahk`のショートカットを作成
2. `Win + r`を入力
3. `shell:startup`を入力すると、スタートアップのフォルダが開く
4. 1で作成したショートカットをスタートアップのフォルダに移動


**Don't sudo the first time you start vim, or delete the viminfo later**

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


<details>
<summary>Install latex</summary>
```sh
yes | sudo apt install texlive-lang-cjk latexmk unzip
cd ~
mkdir ~/work
cd ~/work
curl -OL https://github.com/h-kitagawa/plistings/archive/master.zip
unzip master.zip
cd plistings-master
sudo mkdir -p /usr/share/texlive/texmf-dist/tex/latex/plistings
cd /usr/share/texlive/texmf-dist/tex/latex/plistings
sudo mv ~/work/plistings-master/plistings.sty .
mktexlsr
```

[jlisting](https://osdn.net/projects/mytexpert/downloads/26068/jlisting.sty.bz2/)
[dirtree](https://ctan.org/tex-archive/macros/generic/dirtree)
[matlab-prettifier](https://www.ctan.org/pkg/matlab-prettifier)


```sh
cd ~/work
bunzip2 jlisting.sty.bz2
sudo mv jlisting.sty /usr/share/texlive/texmf-dist/tex/latex/listings/.
cd /usr/share/texlive/texmf-dist/tex/latex/listings
chmod 644 jlisting.sty
sudo mktexlsr
cd ~/work
unzip dirtree.zip
cd dirtree
latex dirtree.ins
sudo mkdir -p /usr/share/texlive/texmf-dist/tex/latex/dirtree
sudo cp * /usr/share/texlive/texmf-dist/tex/latex/dirtree/.
cd /usr/share/texlive/texmf-dist/tex/latex/dirtree
chmod 644 dirtree.sty
sudo mktexlsr
cd ~/work
unzip matlab-prettifier.zip
cd matlab-prettifier
latex matlab-prettifier.ins
sudo mkdir -p /usr/share/texlive/texmf-dist/tex/latex/matlab-prettifier
sudo mv matlab-prettifier.sty /usr/share/texlive/texmf-dist/tex/latex/matlab-prettifier/.
cd /usr/share/texlive/texmf-dist/tex/latex/matlab-prettifier
chmod 644 matlab-prettifier.sty
sudo mktexlsr
```
</details>

# dotfiles  
This is a repository for my dotfiles.  
The environment for WSL2.

**TODO: もう少しシェルスクリプトにする**

# Installation  
## Get something
1. download [白源](https://github.com/yuru7/HackGen/releases) or 
[Cica](https://github.com/miiton/Cica)
2. install windows terminal and WSL2

## Write /etc/wsl.conf
The default setting adds a lot of windows paths.
To turn this off,
1. write the following into `/etc/wsl.conf`
2. reboot the PC

```sh
echo "[interop]\nappendWindowsPath = false" | sudo tee /etc/wsl.conf
```

<details>
<summary>Q. What is `tee`?</summary>

A command to write the content received from the stdin to the stdout and file.

</details>

## Execute the command

```sh
cd ~
sh init.sh
sh deploy.sh
```

## Install zsh
Install zsh and zsh plugins manager.

```sh
yes | sudo apt install zsh
chsh -s /usr/bin/zsh
mkdir -p ~/.config
exec /usr/bin/zsh -l
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
zinit self-update
```

For change the commandline theme, 
```sh
fast-theme clean
```

## Install anyenv for good manage to node
Check the latest good version at 
[https://nodejs.org/ja/download/](https://nodejs.org/ja/download/).  
You need to rewrite `nodenv install xx.xx.x` and `nodenv global xx.xx.x`

**TODO: 要確認**

```sh
git clone https://github.com/anyenv/anyenv ~/.anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"
export PATH="$HOME/.anyenv/bin:$PATH"
yes | anyenv install --init
exec $SHELL -l
sudo apt install zlib1g-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev

anyenv install nodenv
nodenv install 12.18.2
exec /usr/bin/zsh -l
nodenv global 12.18.2
npm install -g atcoder-cli
```

## Install latex
**TODO: jsarticle関連**

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

## Install tmux plugins

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

1. install tmux plugins with the above command
2. launch tmux
3. enter `prefix(maybe ctrl + s or ctrl + b)` to install tmux plugins.

## git and GitHub
enter some '<CR>'

```sh
git config --global user.name "eetann"
git config --global user.email "eetann's mail adress"
ssh-keygen -t rsa -b 4096 -C "eetann's mail adress"
cat ~/.ssh/id_rsa.pub | clip.exe
```

You need to resist the key.

```sh
ssh -T git@github.com
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa
cd ~/dotfiles
git remote set-url origin git@github.com:eetann/dotfiles.git
go get github.com/mattn/jvgrep
go get github.com/itchyny/mmv/cmd/mmv
make deploy
```

## Install Homebrew
Because it may be changed, see [Official page](https://brew.sh/) to install.
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> ~/.zprofile
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
```

## Install tools from brew
```sh
brew install bat
brew install ghq
git config --global --add ghq.root $GOPATH/src
git config --global --add ghq.root $HOME/ghq
brew install ripgrep
```


## AtCoder
The following two commands have already been executed in this README.md and init.sh.
The configuration files are at `dotfiles/atcoder` .

```sh
pip3 install online-judge-tools
npm install -g atcoder-cli
```

```sh
acc check-oj
acc login
oj login https://beta.atcoder.jp/
acc config default-test-dirname-format test
acc config default-task-choice all
acc config default-template cpp
```

# for autohotkey
To use `likevim.ahk` , you need to regist the file at startup.

1. make shortcut of `likevim.ahk`
2. etner `Win + r`
3. enter `shell:startup`, then open a directory for startup
4. move the shortcut file at the directory


**Don't sudo the first time you start vim, or delete the viminfo later**

# dotfiles  
This is a repository for my dotfiles  

# Installation  
```sh
git clone https://github.com/eetann/dotfiles ~/.dotfiles
cd ~/.dotfiles
make init
git config --global user.name "eetann"
git config --global user.email "eetann's mail adress"
ssh-keygen -t rsa -b 4096 -C "eetann's mail adress"
<CR>
cat ~/.ssh/id_rsa.pub | clip.exe
ssh -T git@github.com
ssh-add ~/.ssh/id_rsa
git remote set-url origin git@github.com:eetann/dotfiles.git
go get github.com/mattn/jvgrep
make deploy
```
vim 初回起動は sudo しないもしくはviminfoあとで消す  

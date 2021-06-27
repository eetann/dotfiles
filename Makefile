DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin config
EXCLUSIONS := .DS_Store .git .github .gitignore .vscode
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help

# インデントはタブのみ
# コマンドの前に@をつけると、実行時にコマンドそのものをechoしない
# $$でエスケープ
# -(hyphen)はその行のコマンドが失敗しても次の行を実行

# 下記のように実行コマンドに対して一時的な環境変数を引き渡すことが可能
# BASE_PATH=/opt/base anycommand arg1 arg2

all:

update: ## Fetch changes for this repo
	git pull origin master

deploy: ## Create symlink to home directory
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/scripts/deploy

init: ## Setup environment settings
	@echo '==> Start to install app.'
	@echo ''
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/scripts/init

install: deploy init ## Run make deploy, init
	@exec $$SHELL

check: ## Check if it is ready to install
	@echo 'PATH:' $(DOTPATH)
	@echo 'TARGET:' $(DOTFILES)

clean: ## Remove dotfiles and this repo
	@echo 'Remove dot files in your home directory...'
	# rm
	# -v :verbose:削除の詳細表示
	# -r :recursive:ディレクトリも削除対象にする
	# -f :force:エラーメッセージ非表示
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
	-rm -rf $(DOTPATH)

help: ## Self-documented Makefile
	# grep -E : ()や|や繰り返しが使える拡張正規表現にする
	# awk : これ自体はプログラミング言語
	# BEGIN : 最初だけ実行する
	# FS : Field Separator
	# %-30s 左寄せ文字列30桁
	# %s 文字列
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

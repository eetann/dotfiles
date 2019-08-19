DOTPATH := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
init:
	DOTPATH=$(DOTPATH) bash $(DOTPATH)/init.sh
deploy:
	DOTPATH=$(DOTPATH) bash $(DOTPATH)/deploy.sh
update:
	git pull origin master

.PHONY: dotbot

dotbot:
	dotbot -c install.conf.yaml

git-pull:
	src/git-pull.zsh

pc-install:
	pre-commit install

pc-run:
	pre-commit run -a

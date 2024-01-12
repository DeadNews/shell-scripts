.PHONY: all clean test checks

dotbot:
	dotbot -c install.conf.yaml

git-pull:
	src/git-pull.zsh

pc-install:
	pre-commit install

checks: pc-run

pc-run:
	pre-commit run -a

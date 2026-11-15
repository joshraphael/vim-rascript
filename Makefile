VERSION ?= v0.5.1
URL     := https://github.com/joshraphael/rascript-syntax/releases/download/$(VERSION)/rascript.vim

.PHONY: clean syntax test

clean:
	rm -rf syntax

syntax:
	mkdir -p syntax
	curl -fsSL -o syntax/rascript.vim $(URL)

test:
	mv syntax/rascript.vim syntax/rascript.vim.old
	make syntax
	diff -u syntax/rascript.vim.old syntax/rascript.vim
	rm syntax/rascript.vim.old

VERSION ?= v0.5.1
URL     := https://github.com/joshraphael/rascript-syntax/releases/download/$(VERSION)/rascript.vim
VIMDIR  ?= $(HOME)/.vim
PLUGIN  := $(VIMDIR)/pack/plugins/start/vim-rascript

.PHONY: clean install syntax test

clean:
	rm -rf $(PLUGIN)

install: clean
	mkdir -p $(PLUGIN)
	cp -r . $(PLUGIN)

syntax:
	mkdir -p syntax
	curl -fsSL -o syntax/rascript.vim $(URL)

test:
	mv syntax/rascript.vim syntax/rascript.vim.old
	make syntax
	diff -u syntax/rascript.vim.old syntax/rascript.vim
	rm syntax/rascript.vim.old

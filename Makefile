VERSION ?= v0.5.1
URL     := https://github.com/joshraphael/rascript-syntax/releases/download/$(VERSION)/rascript.vim
VIMDIR  ?= $(HOME)/.vim
FILES   := ftdetect/rascript.vim ftplugin/rascript.vim syntax/rascript.vim

.PHONY: clean install syntax test

clean:
	rm -rf syntax
	rm -f $(addprefix $(VIMDIR)/,$(FILES))

install:
	for f in $(FILES); do install -Dm644 $$f $(VIMDIR)/$$f; done

syntax:
	mkdir -p syntax
	curl -fsSL -o syntax/rascript.vim $(URL)

test:
	mv syntax/rascript.vim syntax/rascript.vim.old
	make syntax
	diff -u syntax/rascript.vim.old syntax/rascript.vim
	rm syntax/rascript.vim.old

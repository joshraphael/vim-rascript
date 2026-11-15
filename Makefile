VERSION ?= v0.5.1
URL     := https://github.com/joshraphael/rascript-syntax/releases/download/$(VERSION)/rascript.vim

.PHONY: syntax

syntax:
	mkdir -p syntax
	curl -fsSL -o syntax/rascript.vim $(URL)

clean:
	rm -rf syntax
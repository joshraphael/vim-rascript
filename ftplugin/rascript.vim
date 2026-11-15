if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

setlocal commentstring=//\ %s
setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal expandtab shiftwidth=4

let b:undo_ftplugin = "setl cms< com< et< sw<"

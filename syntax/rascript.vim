" Vim syntax file
" Language:    RAScript
" Maintainer:  Joshua Raphael
" URL:         https://github.com/joshraphael/rascript-syntax
" Last Change: 2026 Nov 02
" Version:     v0.5.1
" Remark:      Syntax grammar for RAScript, a RetroAchievements.org DSL

if exists('b:current_syntax')
  finish
endif

" Save the user's cpoptions and use Vim defaults while this file loads;
" some flags (e.g. C) change how Vim script is parsed
let s:cpo_save = &cpo
set cpo&vim

syntax case match
" Word characters for the < and > word boundaries in patterns (Vim's
" version of the grammar's \b); fixed here so the user's iskeyword
" setting can't change highlighting, e.g. matching "if" inside "my_if"
syntax iskeyword @,48-57,_,192-255

" Highlight from the top of the file so multi-line comments and strings
" are always right, except in files over 200 KB, where that is slow;
" those start 1000 lines above the screen instead
if line2byte(line('$') + 1) > 200000
  syntax sync minlines=1000
else
  syntax sync fromstart
endif

" Repository entries
syntax cluster rascriptStatements contains=@rascriptHeader,@rascriptComments,@rascriptControls,@rascriptFunctionDefinitions,@rascriptBooleans,@rascriptStrings,@rascriptNumbers,@rascriptFunctionNames,@rascriptClassDefinitions,@rascriptLambdas,@rascriptParentheses,@rascriptBlocks,@rascriptBrackets,@rascriptVariableLanguageThis,@rascriptVariableAssignment,@rascriptVariableOther
syntax cluster rascriptControls contains=rascriptControls_1,rascriptControls_2,rascriptControls_3
syntax cluster rascriptBooleans contains=rascriptBooleans
syntax cluster rascriptStrings contains=rascriptStrings
syntax cluster rascriptNumbers contains=rascriptNumbers_1,rascriptNumbers_2
syntax cluster rascriptFunctionDefinitions contains=rascriptFunctionDefinitions
syntax cluster rascriptFunctionNames contains=rascriptFunctionNames_1,rascriptFunctionNames_2,rascriptFunctionNames_3
syntax cluster rascriptCallArguments contains=rascriptCallArguments,@rascriptTop
syntax cluster rascriptLambdas contains=rascriptLambdas_1,rascriptLambdas_2
syntax cluster rascriptParentheses contains=rascriptParentheses
syntax cluster rascriptBlocks contains=rascriptBlocks
syntax cluster rascriptBrackets contains=rascriptBrackets
syntax cluster rascriptClassDefinitions contains=rascriptClassDefinitions
syntax cluster rascriptHeader contains=rascriptHeader_1,rascriptHeader_2
syntax cluster rascriptComments contains=rascriptComments_1,rascriptComments_2
syntax cluster rascriptVariableLanguageThis contains=rascriptVariableLanguageThis
syntax cluster rascriptVariableAssignment contains=rascriptVariableAssignment
syntax cluster rascriptVariableOther contains=rascriptVariableOther
syntax cluster rascriptTop contains=@rascriptStatements

" Rules: later definitions take priority
" #function-definitions/2
syntax match rascriptFunctionDefinitions_2 /\%#=1\v%(<|>)%(\d)@!\k+/ contained
" #variable-other
syntax match rascriptVariableOther /\%#=1\v%(<|>)%(\d)@!\k+/
" #variable-assignment
syntax match rascriptVariableAssignment /\%#=1\v%(<|>)%(\d)@!\k+%([\t ]*\=%(\=)@!)@=/
" #variable-language-this
syntax match rascriptVariableLanguageThis /\%#=1\v<this>/
" #brackets
syntax region rascriptBrackets matchgroup=rascriptBrackets_begin start=/\%#=1\v\[/ matchgroup=rascriptBrackets_end end=/\%#=1\v\]/ contains=@rascriptTop
" #blocks
syntax region rascriptBlocks matchgroup=rascriptBlocks_begin start=/\%#=1\v\{/ matchgroup=rascriptBlocks_end end=/\%#=1\v\}/ contains=@rascriptTop
" #parentheses
syntax region rascriptParentheses matchgroup=rascriptParentheses_begin start=/\%#=1\v\(/ matchgroup=rascriptParentheses_end end=/\%#=1\v\)/ contains=@rascriptTop
" #lambdas/2
syntax match rascriptLambdas_2 /\%#=1\v%(<|>)%(\d)@!\k+%([\t ]*\=\>)@=/
" #lambdas/1/1
syntax match rascriptLambdas_1_1 /\%#=1\v%(<|>)%(\d)@!\k+/ contained
" #lambdas/1
syntax region rascriptLambdas_1 matchgroup=rascriptLambdas_1_begin start=/\%#=1\v\(%(%(\k|[\t ,])*\)[\t ]*%(\=\>|\{))@=/ matchgroup=rascriptLambdas_1_end end=/\%#=1\v\)/ contains=rascriptLambdas_1_1
" #class-definitions
syntax match rascriptClassDefinitions /\%#=1\v%(<class>)[\t ]*%(%(<|>)%(\d)@!\k+)/ contains=rascriptClassDefinitions_c1,rascriptClassDefinitions_c2
" #function-names/3/1
syntax region rascriptFunctionNames_3_1 matchgroup=rascriptFunctionNames_3_1_begin start=/\%#=1\v\(/ matchgroup=rascriptFunctionNames_3_1_end end=/\%#=1\v\)/ contains=@rascriptCallArguments contained
" #function-names/3
syntax region rascriptFunctionNames_3_body start=/\%#=1\v%(\_.)@=/ matchgroup=rascriptFunctionNames_3_end end=/\%#=1\v%([^ \t\r\n\d11\d12(/])@=/ contains=@rascriptComments,rascriptFunctionNames_3_1 contained
syntax match rascriptFunctionNames_3 /\%#=1\v%(<|>)%(%(if|else|for|in|return|function|class|this|true|false)>)@!%(%(\d)@!\k+)>%([\t ]*%(\/\/.*)?\_$)@=/ contains=rascriptFunctionNames_3_bc1 nextgroup=rascriptFunctionNames_3_body
" #function-names/2
syntax region rascriptFunctionNames_2_body start=/\%#=1\v%(\_.)@=/ matchgroup=rascriptFunctionNames_2_end end=/\%#=1\v\)/ contains=@rascriptCallArguments contained
syntax match rascriptFunctionNames_2 /\%#=1\v<%(\k+)\s*\(/ contains=rascriptFunctionNames_2_bc1 nextgroup=rascriptFunctionNames_2_body
" #call-arguments/1
syntax match rascriptCallArguments /\%#=1\v%(<|>)%(\d)@!\k+%([\t ]*\=%([=>])@!)@=/ contained
" #function-names/1
syntax region rascriptFunctionNames_1_body start=/\%#=1\v%(\_.)@=/ matchgroup=rascriptFunctionNames_1_end end=/\%#=1\v\)/ contains=@rascriptCallArguments contained
syntax match rascriptFunctionNames_1 /\%#=1\v%(\.)@<!<%(byte|word|tbyte|dword|bit0|bit1|bit2|bit3|bit4|bit5|bit6|bit7|bit|low4|high4|bitcount|word_be|tbyte_be|dword_be|float|float_be|mbf32|mbf32_le|double32|double32_be|prev|prior|bcd|identity_transform|ascii_string_equals|unicode_string_equals|remembered|repeated|once|tally|deduct|never|unless|measured|trigger_when|disable_when|always_true|always_false|format|substring|length|range|array_push|array_pop|array_map|array_contains|array_reduce|array_filter|field_map|dictionary_contains_key|any_of|all_of|none_of|sum_of|tally_of|max_of|assert|achievement|achievement_set|rich_presence_display|rich_presence_value|rich_presence_lookup|rich_presence_ascii_string_lookup|rich_presence_macro|rich_presence_conditional_display|leaderboard|__ornext)>\s*\(/ contains=rascriptFunctionNames_1_bc1 nextgroup=rascriptFunctionNames_1_body
" #numbers/2
syntax match rascriptNumbers_2 /\%#=1\v<0x\x+>/
" #numbers/1
syntax match rascriptNumbers_1 /\%#=1\v<[0-9]+%(\.[0-9]+)?>/
" #strings/1/3
syntax match rascriptStrings_3 /\%#=1\v%(\{)%([0-9]+)%(\})/ contains=rascriptStrings_3_c1,rascriptStrings_3_c2,rascriptStrings_3_c3 contained
" #strings/1/2
syntax match rascriptStrings_2 /\%#=1\v\\./ contained
" #strings/1/1
syntax match rascriptStrings_1 /\%#=1\v\\u\x{4}/ contained
" #strings/1
syntax region rascriptStrings matchgroup=rascriptStrings_begin start=/\%#=1\v\"/ matchgroup=rascriptStrings_end end=/\%#=1\v\"/ contains=rascriptStrings_1,rascriptStrings_2,rascriptStrings_3
" #booleans
syntax match rascriptBooleans /\%#=1\v<%(true|false)>/
" #function-definitions/1
syntax region rascriptFunctionDefinitions_1 matchgroup=rascriptFunctionDefinitions_1_begin start=/\%#=1\v\=%(\=)@!/ matchgroup=rascriptFunctionDefinitions_1_end end=/\%#=1\v%([,)])@=/ contains=@rascriptTop contained
" #function-definitions
syntax region rascriptFunctionDefinitions_body start=/\%#=1\v%(\_.)@=/ matchgroup=rascriptFunctionDefinitions_end end=/\%#=1\v\)/ contains=@rascriptComments,rascriptFunctionDefinitions_1,rascriptFunctionDefinitions_2 contained
syntax match rascriptFunctionDefinitions /\%#=1\v%(<function>)\s*%(\k+)\s*\(/ contains=rascriptFunctionDefinitions_bc1,rascriptFunctionDefinitions_bc2 nextgroup=rascriptFunctionDefinitions_body
" #controls/3
syntax match rascriptControls_3 /\%#=1\v<%(if|else|for|return)>/
" #controls/2
syntax match rascriptControls_2 /\%#=1\v<%(for)[\t ]+%(%(<|>)%(\d)@!\k+)[\t ]+%(in)>/ contains=rascriptControls_2_c1,rascriptControls_2_c2,rascriptControls_2_c3
" #controls/1
syntax region rascriptControls_1_body start=/\%#=1\v%(\_.)@=/ matchgroup=rascriptControls_1_end end=/\%#=1\v\)/ contains=@rascriptTop contained
syntax match rascriptControls_1 /\%#=1\v<%(if)[\t ]*\(/ contains=rascriptControls_1_bc1 nextgroup=rascriptControls_1_body
" #comments/2
syntax region rascriptComments_2 matchgroup=rascriptComments_2_begin start=/\%#=1\v\/\// matchgroup=rascriptComments_2_end end=/\%#=1\v\_$/
" #comments/1
syntax region rascriptComments_1 matchgroup=rascriptComments_1_begin start=/\%#=1\v\/\*/ matchgroup=rascriptComments_1_end end=/\%#=1\v\*\//
" #header/2
syntax match rascriptHeader_2 /\%#=1\v\_^\/\/[\t ]*%(\#MinimumVersion)[\t ]*\=[\t ]*%(%(0\.7[3-9]|1\.[0-4])%(\.0){0,2}|%(1\.3\.1|1\.4\.[12])%(\.0)?)\_$/ contains=rascriptHeader_2_c1,rascriptHeader_2_c2
" #header/1
syntax match rascriptHeader_1 /\%#=1\v\_^\/\/[\t ]*%(\#ID)[\t ]*\=[\t ]*%(\d+)\_$/ contains=rascriptHeader_1_c1,rascriptHeader_1_c2

" Captures
syntax match rascriptClassDefinitions_c1 /\%#=1\v<class>%([\t ]*%(%(<|>)%(\d)@!\k+))@=/ contained
syntax match rascriptClassDefinitions_c2 /\%#=1\v%(%(<class>)[\t ]*)@<=%(<|>)%(\d)@!\k+/ contained
syntax match rascriptFunctionNames_3_bc1 /\%#=1\v%(<|>)%(%(if|else|for|in|return|function|class|this|true|false)>)@!%(\d)@!\k+%(>%([\t ]*%(\/\/.*)?\_$)@=)@=/ contained
syntax match rascriptFunctionNames_2_bc1 /\%#=1\v<\k+%(\s*\()@=/ contained
syntax match rascriptFunctionNames_1_bc1 /\%#=1\v%(\.)@<!<%(byte|word|tbyte|dword|bit0|bit1|bit2|bit3|bit4|bit5|bit6|bit7|bit|low4|high4|bitcount|word_be|tbyte_be|dword_be|float|float_be|mbf32|mbf32_le|double32|double32_be|prev|prior|bcd|identity_transform|ascii_string_equals|unicode_string_equals|remembered|repeated|once|tally|deduct|never|unless|measured|trigger_when|disable_when|always_true|always_false|format|substring|length|range|array_push|array_pop|array_map|array_contains|array_reduce|array_filter|field_map|dictionary_contains_key|any_of|all_of|none_of|sum_of|tally_of|max_of|assert|achievement|achievement_set|rich_presence_display|rich_presence_value|rich_presence_lookup|rich_presence_ascii_string_lookup|rich_presence_macro|rich_presence_conditional_display|leaderboard|__ornext)%(>\s*\()@=/ contained
syntax match rascriptStrings_3_c1 /\%#=1\v\{%(%([0-9]+)%(\}))@=/ contained
syntax match rascriptStrings_3_c2 /\%#=1\v%(%(\{))@<=[0-9]+%(%(\}))@=/ contained
syntax match rascriptStrings_3_c3 /\%#=1\v%(%(\{)%([0-9]+))@<=\}/ contained
syntax match rascriptFunctionDefinitions_bc1 /\%#=1\v<function>%(\s*%(\k+)\s*\()@=/ contained
syntax match rascriptFunctionDefinitions_bc2 /\%#=1\v%(%(<function>)\s*)@<=\k+%(\s*\()@=/ contained
syntax match rascriptControls_2_c1 /\%#=1\v<for%([\t ]+%(%(<|>)%(\d)@!\k+)[\t ]+%(in)>)@=/ contained
syntax match rascriptControls_2_c2 /\%#=1\v%(<%(for)[\t ]+)@<=%(<|>)%(\d)@!\k+%([\t ]+%(in)>)@=/ contained
syntax match rascriptControls_2_c3 /\%#=1\v%(<%(for)[\t ]+%(%(<|>)%(\d)@!\k+)[\t ]+)@<=in%(>)@=/ contained
syntax match rascriptControls_1_bc1 /\%#=1\v<if%([\t ]*\()@=/ contained
syntax match rascriptHeader_2_c1 /\%#=1\v%(\_^\/\/[\t ]*)@<=\#MinimumVersion%([\t ]*\=[\t ]*%(%(0\.7[3-9]|1\.[0-4])%(\.0){0,2}|%(1\.3\.1|1\.4\.[12])%(\.0)?)\_$)@=/ contained
syntax match rascriptHeader_2_c2 /\%#=1\v%(\_^\/\/[\t ]*%(\#MinimumVersion)[\t ]*\=[\t ]*)@<=%(%(0\.7[3-9]|1\.[0-4])%(\.0){0,2}|%(1\.3\.1|1\.4\.[12])%(\.0)?)%(\_$)@=/ contained
syntax match rascriptHeader_1_c1 /\%#=1\v%(\_^\/\/[\t ]*)@<=\#ID%([\t ]*\=[\t ]*%(\d+)\_$)@=/ contained
syntax match rascriptHeader_1_c2 /\%#=1\v%(\_^\/\/[\t ]*%(\#ID)[\t ]*\=[\t ]*)@<=\d+%(\_$)@=/ contained

highlight default link rascriptFunctionDefinitions_2   Identifier
highlight default link rascriptVariableOther           Identifier
highlight default link rascriptVariableAssignment      Identifier
highlight default link rascriptVariableLanguageThis    Special
highlight default link rascriptLambdas_2               Identifier
highlight default link rascriptLambdas_1_1             Identifier
highlight default link rascriptClassDefinitions_c1     Keyword
highlight default link rascriptClassDefinitions_c2     Type
highlight default link rascriptFunctionNames_3_bc1     Identifier
highlight default link rascriptFunctionNames_2_bc1     Function
highlight default link rascriptCallArguments           Identifier
highlight default link rascriptFunctionNames_1_bc1     Function
highlight default link rascriptNumbers_2               Number
highlight default link rascriptNumbers_1               Number
highlight default link rascriptStrings_3_c1            Special
highlight default link rascriptStrings_3_c2            Identifier
highlight default link rascriptStrings_3_c3            Special
highlight default link rascriptStrings_2               SpecialChar
highlight default link rascriptStrings_1               SpecialChar
highlight default link rascriptStrings_begin           String
highlight default link rascriptStrings_end             String
highlight default link rascriptStrings                 String
highlight default link rascriptBooleans                Boolean
highlight default link rascriptFunctionDefinitions_bc1 Keyword
highlight default link rascriptFunctionDefinitions_bc2 Function
highlight default link rascriptControls_3              Statement
highlight default link rascriptControls_2_c1           Statement
highlight default link rascriptControls_2_c2           Identifier
highlight default link rascriptControls_2_c3           Statement
highlight default link rascriptControls_1_bc1          Statement
highlight default link rascriptComments_2_begin        Comment
highlight default link rascriptComments_2_end          Comment
highlight default link rascriptComments_2              Comment
highlight default link rascriptComments_1_begin        Comment
highlight default link rascriptComments_1_end          Comment
highlight default link rascriptComments_1              Comment
highlight default link rascriptHeader_2_c1             PreProc
highlight default link rascriptHeader_2_c2             Number
highlight default link rascriptHeader_2                Comment
highlight default link rascriptHeader_1_c1             PreProc
highlight default link rascriptHeader_1_c2             Number
highlight default link rascriptHeader_1                Comment

let b:current_syntax = 'rascript'

" Restore the user's cpoptions
let &cpo = s:cpo_save
unlet s:cpo_save

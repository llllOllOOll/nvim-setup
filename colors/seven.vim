" Neovim color file
" Maintainer: Seven
" Based on default colorscheme with custom colors

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let colors_name = "seven"

" UI Elements
hi Changed              guifg=#cc7bf4 ctermfg=6
hi Directory           guifg=#70b8ff ctermfg=6
hi MoreMsg             guifg=#cc7bf4 ctermfg=6
hi Question            guifg=#cc7bf4 ctermfg=6
hi QuickFixLine        guifg=#cc7bf4 ctermfg=6

" Syntax Groups
hi Statement           guifg=#cc7bf4 gui=bold ctermfg=6 cterm=bold
hi Type                guifg=#fbad60 ctermfg=6
hi Function            guifg=#fbad60 ctermfg=6
hi String              guifg=#70b8ff ctermfg=2
hi Identifier          guifg=#ffffff ctermfg=15
hi Special             guifg=#cc7bf4 ctermfg=6

" Diagnostic
hi DiagnosticInfo      guifg=#cc7bf4 ctermfg=6

" LSP and Floating Windows
hi FloatBorder         guifg=#fbad60 ctermfg=6

" vim: sw=2
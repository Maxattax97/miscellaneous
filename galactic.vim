" Name:         Dark
" Description:  Template for dark colorscheme
" Author:       Myself <myself@somewhere.org>
" Maintainer:   Myself <myself@somewhere.org>
" License:      Vim License (see `:help license`)
" Last Updated: Mon 13 May 2019 04:24:58 PM EDT

if !(has('termguicolors') && &termguicolors) && !has('gui_running')
      \ && (!exists('&t_Co') || &t_Co < 256)
  echoerr '[Dark] There are not enough colors.'
  finish
endif

set background=dark

hi clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'dark'

if !has('gui_running') && get(g:, 'dark_transp_bg', 0)
  hi Normal ctermfg=255 ctermbg=NONE guifg=#ebebeb guibg=NONE guisp=NONE cterm=NONE gui=NONE
  hi Terminal ctermfg=255 ctermbg=NONE guifg=#ebebeb guibg=NONE guisp=NONE cterm=NONE gui=NONE
else
  hi Normal ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
  hi Terminal ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
endif
hi ColorColumn ctermfg=fg ctermbg=16 guifg=fg guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi Conceal ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Cursor ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi CursorColumn ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi CursorLine ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi CursorLineNr ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi DiffAdd ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi DiffChange ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi DiffDelete ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi DiffText ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE,bold,reverse gui=NONE,bold,reverse
hi Directory ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi EndOfBuffer ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi ErrorMsg ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi FoldColumn ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi Folded ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE,italic gui=NONE,italic
hi IncSearch ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE,reverse gui=NONE,standout
hi LineNr ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi MatchParen ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi ModeMsg ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi MoreMsg ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi NonText ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi Pmenu ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi PmenuSbar ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi PmenuSel ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi PmenuThumb ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi Question ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi! link QuickFixLine Search
hi Search ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi SignColumn ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi SpecialKey ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi SpellBad ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=#ff0000 cterm=NONE gui=NONE
hi SpellCap ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=#0000ff cterm=NONE gui=NONE
hi SpellLocal ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=#ff00ff cterm=NONE gui=NONE
hi SpellRare ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=#00ffff cterm=NONE,reverse gui=NONE,reverse
hi StatusLine ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi StatusLineNC ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC
hi TabLine ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi TabLineFill ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi TabLineSel ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi Title ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi VertSplit ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi Visual ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi VisualNOS ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi WarningMsg ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi WildMenu ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi! link Boolean Constant
hi! link Character Constant
hi Comment ctermfg=255 ctermbg=NONE guifg=#ebebeb guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi! link Conditional Statement
hi Constant ctermfg=255 ctermbg=NONE guifg=#ebebeb guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi! link Define PreProc
hi! link Debug Special
hi! link Delimiter Special
hi Error ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi! link Exception Statement
hi! link Float Constant
hi! link Function Identifier
hi Identifier ctermfg=255 ctermbg=NONE guifg=#ebebeb guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Ignore ctermfg=255 ctermbg=NONE guifg=#ebebeb guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi! link Include PreProc
hi! link Keyword Statement
hi! link Label Statement
hi! link Macro PreProc
hi! link Number Constant
hi! link Operator Statement
hi! link PreCondit PreProc
hi PreProc ctermfg=255 ctermbg=NONE guifg=#ebebeb guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi! link Repeat Statement
hi Special ctermfg=255 ctermbg=NONE guifg=#ebebeb guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi! link SpecialChar Special
hi! link SpecialComment Special
hi Statement ctermfg=255 ctermbg=NONE guifg=#ebebeb guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi! link StorageClass Type
hi! link String Constant
hi! link Structure Type
hi! link Tag Special
hi Todo ctermfg=255 ctermbg=NONE guifg=#ebebeb guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Type ctermfg=255 ctermbg=NONE guifg=#ebebeb guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi! link Typedef Type
hi Underlined ctermfg=255 ctermbg=NONE guifg=#ebebeb guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi! link lCursor Cursor
hi CursorIM ctermfg=NONE ctermbg=fg guifg=NONE guibg=fg guisp=NONE cterm=NONE gui=NONE
hi ToolbarLine ctermfg=NONE ctermbg=16 guifg=NONE guibg=#000000 guisp=NONE cterm=NONE gui=NONE
hi ToolbarButton ctermfg=255 ctermbg=16 guifg=#ebebeb guibg=#000000 guisp=NONE cterm=NONE,bold gui=NONE,bold
let g:terminal_ansi_colors = [
      \ '#000000',
      \ '#ff0000',
      \ '#00ff00',
      \ '#ffff00',
      \ '#0000ff',
      \ '#ff00ff',
      \ '#00ffff',
      \ '#ebebeb',
      \ '#d2d2d2',
      \ '#ff6400',
      \ '#64ff00',
      \ '#ffff64',
      \ '#0064ff',
      \ '#ff64ff',
      \ '#64ffff',
      \ '#ffffff'
      \ ]
finish

" Background: dark
" Color: black                rgb(  0,   0,   0)     ~        Black
" Color: red                  rgb(255,   0,   0)     ~        DarkRed
" Color: green                rgb(  0, 255,   0)     ~        DarkGreen
" Color: yellow               rgb(255, 255,   0)     ~        DarkYellow
" Color: blue                 rgb(  0,   0, 255)     ~        DarkBlue
" Color: magenta              rgb(255,   0, 255)     ~        DarkMagenta
" Color: cyan                 rgb(  0, 255, 255)     ~        DarkCyan
" Color: white                rgb(235, 235, 235)     ~        LightGrey
" Color: brightblack          rgb(210, 210, 210)     ~        DarkGrey
" Color: brightred            rgb(255, 100,   0)     ~        LightRed
" Color: brightgreen          rgb(100, 255,   0)     ~        LightGreen
" Color: brightyellow         rgb(255, 255, 100)     ~        LightYellow
" Color: brightblue           rgb(  0, 100, 255)     ~        LightBlue
" Color: brightmagenta        rgb(255, 100, 255)     ~        LightMagenta
" Color: brightcyan           rgb(100, 255, 255)     ~        LightCyan
" Color: brightwhite          #ffffff                231      White
"     Normal           white             none
"     Terminal         white             none
"     Normal           white             black
"     Terminal         white             black
" ColorColumn          fg                black
" Conceal              none              none
" Cursor               white             black
" CursorColumn         white             black
" CursorLine           white             black
" CursorLineNr         white             black
" DiffAdd              white             black             reverse
" DiffChange           white             black             reverse
" DiffDelete           white             black             reverse
" DiffText             white             black             bold,reverse
" Directory            white             black
" EndOfBuffer          white             black
" ErrorMsg             white             black             reverse
" FoldColumn           white             black
" Folded               white             black             italic
" IncSearch            white             black             t=reverse g=standout
" LineNr               white             black
" MatchParen           white             black
" ModeMsg              white             black
" MoreMsg              white             black
" NonText              white             black
" Pmenu                white             black
" PmenuSbar            white             black
" PmenuSel             white             black
" PmenuThumb           white             black
" Question             white             black
" QuickFixLine     ->  Search
" Search               white             black
" SignColumn           white             black
" SpecialKey           white             black
" SpellBad             white             black             s=red
" SpellCap             white             black             s=blue
" SpellLocal           white             black             s=magenta
" SpellRare            white             black             s=cyan reverse
" StatusLine           white             black
" StatusLineNC         white             black
" StatusLineTerm    -> StatusLine
" StatusLineTermNC  -> StatusLineNC
" TabLine              white             black
" TabLineFill          white             black
" TabLineSel           white             black
" Title                white             black
" VertSplit            white             black
" Visual               white             black
" VisualNOS            white             black
" WarningMsg           white             black
" WildMenu             white             black
" Boolean           -> Constant
" Character         -> Constant
" Comment              white             none
" Conditional       -> Statement
" Constant             white             none
" Define            -> PreProc
" Debug             -> Special
" Delimiter         -> Special
" Error                white             black             reverse
" Exception         -> Statement
" Float             -> Constant
" Function          -> Identifier
" Identifier           white             none
" Ignore               white             none
" Include           -> PreProc
" Keyword           -> Statement
" Label             -> Statement
" Macro             -> PreProc
" Number            -> Constant
" Operator          -> Statement
" PreCondit         -> PreProc
" PreProc              white             none
" Repeat            -> Statement
" Special              white             none
" SpecialChar       -> Special
" SpecialComment    -> Special
" Statement            white             none
" StorageClass      -> Type
" String            -> Constant
" Structure         -> Type
" Tag               -> Special
" Todo                 white             none
" Type                 white             none
" Typedef           -> Type
" Underlined           white             none
" lCursor           -> Cursor
" CursorIM             none              fg
" ToolbarLine          none              black
" ToolbarButton        white             black             bold

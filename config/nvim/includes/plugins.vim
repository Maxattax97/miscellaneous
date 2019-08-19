" vim: set foldmethod=marker:
" Modules {{{
" A UI to display Dein updates.
call dein#add('wsdjeg/dein-ui.vim')

" An autocompletion engine.
"call dein#add('shougo/deoplete.nvim')
" INSTALL: yarn
"call dein#add('neoclide/coc.nvim', {'merge':0, 'build': 'yarn install --frozen-lockfile'})
call dein#add('neoclide/coc.nvim', {'merge':0, 'rev': 'release'})

" Display function arguments in command bar. Works with deoplete.
" TODO: Not displaying?
call dein#add('shougo/echodoc.vim')

" Asynchronous Lint Engine.
call dein#add('w0rp/ale')

" Access project files in side-bar.
"call dein#add('scrooloose/nerdtree')
"call dein#add('xuyuanp/nerdtree-git-plugin')
"call dein#add('jistr/vim-nerdtree-tabs')
call dein#add('shougo/defx.nvim')
call dein#add('kristijanhusak/defx-git')
call dein#add('kristijanhusak/defx-icons')

" Access function tags in side-bar.
"call dein#add('majutsushi/tagbar')

" Access function, module, class, variable, etc. tags in side-bar with LSP.
call dein#add('liuchengxu/vista.vim')

" Integrated Git commands and change indicator.
call dein#add('mhinz/vim-signify')
"call dein#add('airblade/vim-gitgutter') " Removed in favor of Signify.

"Combine all autocompletion into a single keymap.
"call dein#add('ervandew/supertab')

" Efficient commenting.
call dein#add('scrooloose/nerdcommenter')

" Efficient text-alignment.
call dein#add('godlygeek/tabular')

" Asynchronous fuzzy finder.
" INSTALL: pip3 install pynvim
" INSTALL: cargo install ripgrep
call dein#add('shougo/denite.nvim')

" file_mru plugin for Denite.
call dein#add('shougo/neomru.vim')

" Vim colortemplate generator.
call dein#add('lifepillar/vim-colortemplate')
" }}}

" Tim Pope Collection {{{
" Git wrapper with Github support.
call dein#add('tpope/vim-fugitive')
call dein#add('tpope/vim-rhubarb')

" Efficiently surround text.
call dein#add('tpope/vim-surround')

" Automatically detect indent type and width.
call dein#add('tpope/vim-sleuth')

" Efficiently move between buffers, among other things.
call dein#add('tpope/vim-unimpaired')

" Default settings for Vim that just make sense.
call dein#add('tpope/vim-sensible')

" Asynchronous compiling and unit testing.
call dein#add('tpope/vim-dispatch')

" Access databases from within vim.
call dein#add('tpope/vim-dadbod')

" Smart, in-depth search and replace.
call dein#add('tpope/vim-abolish')

" Repeat any command.
call dein#add('tpope/vim-repeat')

" UNIX commands.
call dein#add('tpope/vim-eunuch')

" Automatically managed Vim sessions.
call dein#add('tpope/vim-obsession')

" Automatically end control structures in launguages that use 'end' keywords.
"call dein#add('tpope/vim-endwise')

" Project management for standardized directory structures.
call dein#add('tpope/vim-projectionist')

"" Concise date-time management.
call dein#add('tpope/vim-speeddating')

" Shell-like simple line operations, e.g. Ctrl-A to return to beginning of
" line.
call dein#add('tpope/vim-rsi')

"" Call Tmux from Vim.
call dein#add('tpope/vim-tbone')

"" Better JSON manipulation from within Vim.
call dein#add('tpope/vim-jdaddy')

"" tpope's colorscheme, mimicking MacOS's.
call dein#add('tpope/vim-vividchalk')

"" Improved unicode handling.
call dein#add('tpope/vim-characterize')

"" Edit images... inside Vim.
call dein#add('tpope/vim-afterimage')

"" Scan include paths and whatnot.
call dein#add('tpope/vim-apathy')

"" .env and Procfile support.
call dein#add('tpope/vim-dotenv')
" }}}

" Autocompletion {{{
" Include/import files from headers for autocompletion, etc.
call dein#add('shougo/neoinclude.vim')
call dein#add('jsfaint/coc-neoinclude')

" VimL support.
call dein#add('shougo/neco-vim')
call dein#add('neoclide/coc-neco')

" C languages
"call dein#add('zchee/deoplete-clang')

" Javascript
"call dein#add('carlitux/deoplete-ternjs')
", { 'do': 'npm install -g tern' }
"call dein#add('wokalski/autocomplete-flow')

" Rust
"call dein#add('sebastianmarkow/deoplete-rust')

" Python
"call dein#add('zchee/deoplete-jedi')

" D language
"call dein#add('landaire/deoplete-d')

" Perl
"call dein#add('c9s/perlomni.vim')

" Vimscript
"call dein#add('shougo/neco-vim')

" Godot's GDScript
"call dein#add('calviken/vim-gdscript3')

" Web languages (HTML, CSS, XML, XHTML, ...)
"call dein#add('othree/csscomplete.vim')
"call dein#add('othree/html5.vim')
"call dein#add('othree/xml.vim')

"call dein#add('sbdchd/neoformat')
" }}}

" Syntax / File Support {{{
" Syntax support for a huge number of languages.
call dein#add('sheerun/vim-polyglot')

" Improved Perl support.
call dein#add('vim-perl/vim-perl')
", { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' }

" Improved Go support with commands.
" Not being used for linting / autocompletion.
" INSTALL: :GoInstallBinaries
call dein#add('fatih/vim-go')

" Adds support for Apache Avro's IDL files.
call dein#add('gurpreetatwal/vim-avro')
" }}}

" Aesthetics {{{
" Informational and sexy statusline.
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')

" Displays buffers on the top of the screen.
call dein#add('bling/vim-bufferline')

" Opens a start page with project file recommendations.
call dein#add('mhinz/vim-startify')

" Colorschemes / Themes
call dein#add('maxattax97/vim-galactic')
call dein#add('lifepillar/vim-solarized8')
call dein#add('mhartington/oceanic-next')
call dein#add('dikiaap/minimalist')
call dein#add('flazz/vim-colorschemes')

" Icons for filetypes, Git, and more.
call dein#add('ryanoasis/vim-devicons')

" Guides for code indenting.
call dein#add('nathanaelkane/vim-indent-guides')
" }}}

" Miscellaneous {{{
" Open the to the last cursor position you were at in a file.
call dein#add('farmergreg/vim-lastplace')

" A collection of default, useful snippets.
"call dein#add('honza/vim-snippets')

" Previews CSS colors.
call dein#add('ap/vim-css-color')

" Automatically swap between absolute and relative line numbering.
call dein#add('jeffkreeftmeijer/vim-numbertoggle')

" Automatically add the { to your }.
" Causes me more strain than aid.
"call dein#add('jiangmiao/auto-pairs')


" Color enclosing characters for easy reading.
call dein#add('junegunn/rainbow_parentheses.vim')

" View Vim's internal undo tree.
call dein#add('simnalamburt/vim-mundo')

" Stop using arrow keys! And other keys inneficiently.
call dein#add('takac/vim-hardtime')

" }}}

" Disabled {{{
" Plug 'terryma/vim-multiple-cursors'
" Plug 'editorconfig/editorconfig-vim'
" Plug 'thinca/vim-quickrun'
" Plug 'bronson/vim-trailing-whitespace'
" Plug 'plugin/vim-paste-easy'
" Plug 'godlygeek/csapprox'
" Plug 'gregsexton/matchtag'
" Plug 'mattn/emmet-vim'
" Plug 'yuttie/comfortable-motion.vim' " Debatable, could slow down productivity

" NOTES:
" Debuggers, diagnostics, R language, syntaxes, autocompletes, formatters
" Test over an SSH Connection

" }}}

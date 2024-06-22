" vim: foldmethod=marker
let g:coc_global_extensions = [
    \ 'coc-clangd',
    \ 'coc-css',
    \ 'coc-deno',
    \ 'coc-dictionary',
    \ 'coc-emmet',
    \ 'coc-eslint',
    \ 'coc-fsharp',
    \ 'coc-highlight',
    \ 'coc-html',
    \ 'coc-java',
    \ 'coc-jest',
    \ 'coc-json',
    \ 'coc-lists',
    \ 'coc-phpls',
    \ 'coc-prettier',
    \ 'coc-pyright',
    \ 'coc-r-lsp',
    \ 'coc-rust-analyzer',
    \ 'coc-sh',
    \ 'coc-solargraph',
    \ 'coc-tag',
    \ 'coc-tslint',
    \ 'coc-tslint-plugin',
    \ 'coc-tsserver',
    \ 'coc-vetur',
    \ 'coc-vimtex',
    \ 'coc-yaml',
    \ 'coc-yank',
    \]

" Disabled servers:
    "\ 'coc-git',
    "\ 'coc-omni',
    "\ 'coc-neosnippet',
    "\ 'coc-pairs',
    "\ 'coc-snippets',
    "\ 'coc-gocode',
    "\ 'coc-neco', " Install via plugin manager.
    "\ 'coc-neoinclude', " Install via plugin manager.
    "\ 'coc-word',

" INSTALL: go get golang.org/x/tools/cmd/gopls
" INSTALL: pacman -Syu lua53 luarocks
" INSTALL: luarocks install --server=http://luarocks.org/dev lua-lsp --lua-version=5.3
" INSTALL: luarocks install --local lcf --lua-version=5.3       # luacheck no longer available.
" INSTALL: R -e 'install.packages("languageserver")' # may have to manually
" execute rather than using this one-liner.

"call coc#add_extension('coc-dictionary')

let g:coc_filetype_map = {
  \ 'yaml.ansible': 'ansible',
  \ }

command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

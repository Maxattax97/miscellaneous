" vim: foldmethod=marker
let g:coc_global_extensions = [
    \ 'coc-json',
    \ 'coc-tag',
    \ 'coc-tslint',
    \ 'coc-eslint',
    \ 'coc-css',
    \ 'coc-html',
    \ 'coc-solargraph',
    \ 'coc-vetur',
    \ 'coc-tsserver',
    \ 'coc-jest',
    \ 'coc-java',
    \ 'coc-rls',
    \ 'coc-highlight',
    \ 'coc-yaml',
    \ 'coc-emmet',
    \ 'coc-lists',
    \ 'coc-yank',
    \ 'coc-vimtex',
    \ 'coc-tslint-plugin',
    \ 'coc-phpls',
    \ 'coc-pyright',
    \ 'coc-fsharp',
    \ 'coc-dictionary',
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

" INSTALL: npm install -g --local bash-language-server
" INSTALL: yay -S ccls
" INSTALL: go get golang.org/x/tools/cmd/gopls
" INSTALL: go get -u github.com/mdempsky/gocode
" INSTALL: pacman -Syu lua53 luarocks
" INSTALL: luarocks install --server=http://luarocks.org/dev lua-lsp --lua-version=5.3
" INSTALL: luarocks install --local lcf --lua-version=5.3       # luacheck no longer available.

"call coc#add_extension('coc-dictionary')

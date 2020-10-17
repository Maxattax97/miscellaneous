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
    \ 'coc-python',
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
" INSTALL: go get -u golang.org/x/tools/cmd/gopls
" INSTALL: go get -u github.com/mdempsky/gocode
" INSTALL: luarocks install --server=http://luarocks.org/dev lua-lsp
"          luarocks install --local luacheck lcf

"call coc#add_extension('coc-dictionary')

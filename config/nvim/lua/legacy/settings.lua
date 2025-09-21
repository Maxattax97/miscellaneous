local g, fn = vim.g, vim.fn

-- ALE
g.ale_sign_column_always = 1
g.ale_virtualtext_cursor = 0
g.ale_virtualtext_prefix = " ]] "
g.ale_fixers = {
  ["*"] = { "remove_trailing_lines", "trim_whitespace" },
  javascript = { "eslint" },
  json = { "jq" },
  jsx = { "eslint" },
  python = { "black" },
  rust = { "rustfmt" },
  typescript = { "eslint" },
  xml = { "xmllint" },
  yaml = {},
}
g.ale_linters = {
  c = {}, cpp = {}, css = {}, go = {}, html = {}, java = {}, javascript = {}, json = {},
  jsx = {}, python = {}, ruby = {}, rust = {}, typescript = {}, yaml = {},
}
g.ale_fix_on_save = 1

-- Copilot
g.copilot_filetypes = { gitcommit = true, markdown = true, yaml = true }
local function add_copilot_ws(folder)
  local d = fn.expand(folder)
  if fn.isdirectory(d) == 1 then
    if g.copilot_workspace_folders == nil then g.copilot_workspace_folders = { d }
    else table.insert(g.copilot_workspace_folders, d) end
  end
end
add_copilot_ws("~/src")
add_copilot_ws("~/aura")

-- Signify
g.signify_vcs_list = { "git", "perforce", "hg", "svn" }
g.signify_realtime = 0
g.signify_sign_change = "~"
g.signify_sign_delete = "-"
g.signify_sign_delete_first_line = "-"
g.signify_sign_changedelete = "!"

-- SuperTab / UltiSnips (kept for parity)
g.SuperTabDefaultCompletionType = "<C-x><C-o>"
g.UltiSnipsExpandTrigger = "<C-j>"

-- Airline
if g.airline_symbols == nil then g.airline_symbols = {} end
g.airline_powerline_fonts = 1
g["airline#extensions#tabline#enabled"] = 1
g["airline#extensions#bufferline#enabled"] = 1
g["airline#extensions#tmuxline#enabled"] = 0
g["airline#extensions#ale#enabled"] = 1
g["airline#extensions#csv#enabled"] = 1
g["airline#extensions#gutentags#enabled"] = 1
g["airline#extensions#hunks#enabled"] = 1
--g["airline#extensions#nerdtree#enabled"] = 1
g["airline#extensions#obsession#enabled"] = 1
g["airline#extensions#fugitiveline#enabled"] = 1
--g["airline#extensions#denite#enabled"] = 1
g["airline#extensions#undotree#enabled"] = 1
--g["airline#extensions#coc#enabled"] = 1
g.bufferline_echo = 0

-- Startify header
g.startify_custom_header = {
  "      __  ___                 __  __              ",
  "     /  |/  /___ __  ______ _/ /_/ /_____ __  __  ",
  "    / /|_/ / __ `/ |/_/ __ `/ __/ __/ __ `/ |/_/  ",
  "   / /  / / /_/ />  </ /_/ / /_/ /_/ /_/ />  <    ",
  "  /_/  /_/\\__,_/_/|_|\\__,_/\\__/\\__/\\__,_/_/|_|    ",
}

-- Go plugin
g.go_code_completion_enabled = 1
g.go_metalinter_autosave = 0
g.go_metalinter_enabled = {}
g.go_metalinter_disabled = { "vet", "golint", "errcheck" }
g.go_fmt_fail_silently = 1

-- TaskJuggler comment delimiter with NERDCommenter
g.NERDCustomDelimiters = { tjp = { left = "#" }, tji = { left = "#" } }

-- Denite settings (verbatim)
--vim.cmd([[
--try
  --call denite#custom#var('file/rec', 'command', ['rg', '-i', '--files', '--glob', '!.git', '--glob', '!node_modules', '--max-filesize', '50K'])
  --call denite#custom#var('grep', 'command', ['rg'])
  --call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])
  --call denite#custom#var('grep', 'recursive_opts', [])
  --call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  --call denite#custom#var('grep', 'separator', ['--'])
  --call denite#custom#var('grep', 'final_opts', [])
  --call denite#custom#var('buffer', 'date_format', '')

  --call denite#custom#source('file/rec', 'sorters', ['sorter/sublime'])
  --call denite#custom#source('grep', 'sorters', ['sorter/sublime'])
  --call denite#custom#source('tag', 'sorters', ['sorter/sublime'])
  --call denite#custom#source('buffer', 'sorters', ['sorter/sublime'])
  --call denite#custom#source('file_mru', 'sorters', ['sorter/sublime'])
  --call denite#custom#source('help', 'sorters', ['sorter/help'])

  --let s:denite_options = {'default' : {
  --\ 'split': 'floating',
  --\ 'start_filter': 1,
  --\ 'auto_resize': 1,
  --\ 'prompt': 'λ:',
  --\ 'statusline': 0,
  --\ 'winrow': 1,
  --\ 'highlight_matched_char': 'WildMenu',
  --\ 'highlight_matched_range': 'Visual',
  --\ 'highlight_prompt': 'StatusLine',
  --\ 'vertical_preview': 1
  --\ }}

  --function! s:profile(opts) abort
    --for l:fname in keys(a:opts)
      --for l:dopt in keys(a:opts[l:fname])
        --call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
      --endfor
    --endfor
  --endfunction

  --call s:profile(s:denite_options)
--catch
  --echom 'Denite not installed, skipping configuration.'
--endtry
--]])

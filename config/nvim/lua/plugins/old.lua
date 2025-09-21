-- lua/plugins/old.lua
-- Direct port of your existing plugin list to lazy.nvim specs (no modernization)
-- You can delete/replace this file gradually as you move to Lua-native plugins.

return {

  -- ===== Modules =====
  --{ "wsdjeg/dein-ui.vim" },

  -- Autocompletion (CoC-era)
  --{ "neoclide/coc.nvim", branch = "release", enabled = false },
  --{ "yaegassy/coc-ansible", dependencies = { "neoclide/coc.nvim" }, enabled = false },

  -- Echo function signatures (for deoplete-era)
  --{ "Shougo/echodoc.vim" },

  -- Linting
  --{ "w0rp/ale" }, -- upstream repo is dense-analysis/ale; keeping as-is for parity

  -- Tags / Symbols sidebars
  -- { "majutsushi/tagbar" },
  { "liuchengxu/vista.vim" },

  -- Git signs/integration
  { "mhinz/vim-signify" },
  -- { "airblade/vim-gitgutter" },

  -- { "ervandew/supertab" },

  -- Commenting / Align
  { "scrooloose/nerdcommenter" },
  { "godlygeek/tabular" },

  -- Fuzzy finder (Denite era)
  -- { "Shougo/denite.nvim" },
  -- { "Shougo/neomru.vim" },

  -- Colortemplate
  { "lifepillar/vim-colortemplate" },

  -- Copilot
  { "github/copilot.vim" },

  -- Test runner
  { "vim-test/vim-test" },

  -- ActivityWatch (conditional enable)
  {
    "ActivityWatch/aw-watcher-vim",
    enabled = (vim.fn.executable("aw-qt") == 1),
  },

  -- ===== Autocompletion addons (legacy) =====
  --{ "Shougo/neoinclude.vim" },
  --{ "jsfaint/coc-neoinclude", dependencies = { "neoclide/coc.nvim" } },

  --{ "Shougo/neco-vim" },
  --{ "neoclide/coc-neco", dependencies = { "neoclide/coc.nvim" } },

  -- { "zchee/deoplete-clang" },
  -- { "carlitux/deoplete-ternjs" },
  -- { "wokalski/autocomplete-flow" },
  -- { "sebastianmarkow/deoplete-rust" },
  -- { "zchee/deoplete-jedi" },
  -- { "landaire/deoplete-d" },

  { "c9s/perlomni.vim" },
  -- BROKEN: { "calviken/vim-gdscript3" },
  -- { "othree/csscomplete.vim" },
  -- { "othree/html5.vim" },
  -- { "othree/xml.vim" },

  -- { "sbdchd/neoformat" },

  -- ===== Syntax / File Support =====
  { "sheerun/vim-polyglot", enabled = false },
  { "pearofducks/ansible-vim" },

  { "vim-perl/vim-perl" },
  -- build hints from your comment are omitted for safety

  {
    "fatih/vim-go",
    -- You had :GoInstallBinaries noted; running it automatically can be intrusive.
    -- If you *want* that behavior, uncomment the following:
    -- build = ":GoInstallBinaries",
    ft = { "go", "gomod", "gowork", "gotmpl" },
  },

  { "gurpreetatwal/vim-avro" },
  { "urbit/hoon.vim" },
  { "kalafut/vim-taskjuggler" },
  { "momota/cisco.vim" },
  { "powerman/vim-plugin-AnsiEsc" },

  -- ===== Aesthetics =====
  { "vim-airline/vim-airline" },
  { "vim-airline/vim-airline-themes", dependencies = { "vim-airline/vim-airline" } },

  { "bling/vim-bufferline" },
  { "mhinz/vim-startify" },

  { "maxattax97/vim-galactic" },
  { "lifepillar/vim-solarized8" },
  { "mhartington/oceanic-next" },
  { "dikiaap/minimalist" },
  { "flazz/vim-colorschemes" },
  { "srcery-colors/srcery-vim" },

  { "ryanoasis/vim-devicons" },
  { "nathanaelkane/vim-indent-guides" },

  -- ===== Misc =====
  { "farmergreg/vim-lastplace" },
  -- { "honza/vim-snippets" },
  { "ap/vim-css-color" },
  { "jeffkreeftmeijer/vim-numbertoggle" },
  -- { "jiangmiao/auto-pairs" },
  { "junegunn/rainbow_parentheses.vim" },
  { "simnalamburt/vim-mundo" },
  { "takac/vim-hardtime" },

  -- ===== Disabled (kept as comments for reference) =====
  -- { "terryma/vim-multiple-cursors" },
  -- { "editorconfig/editorconfig-vim" },
  -- { "thinca/vim-quickrun" },
  -- { "bronson/vim-trailing-whitespace" },
  -- { "plugin/vim-paste-easy" },
  -- { "godlygeek/csapprox" },
  -- { "gregsexton/matchtag" },
  -- { "mattn/emmet-vim" },
  -- { "yuttie/comfortable-motion.vim" },

}

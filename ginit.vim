set nocompatible              " required
filetype off                  " required

if !exists('g:vscode')
  call plug#begin('$localappdata/nvim/plug/')

  " extensions
  Plug 'ycm-core/YouCompleteMe'
  Plug 'dense-analysis/ale'
  Plug 'preservim/nerdtree'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'kassio/neoterm'

  " languages
  Plug 'sheerun/vim-polyglot'

  " theme
  Plug 'iCyMind/NeoSolarized'
  Plug 'vim-airline/vim-airline-themes'

  " editing plugs
  Plug 'tpope/vim-surround'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'godlygeek/tabular'
  call plug#end()

  filetype plugin indent on    " required
  syntax enable

  colorscheme NeoSolarized

  set termguicolors
  set background=light
  set autowrite
  set nu
  set splitright
  set encoding=utf-8
  set showmatch
  set wildignore=**/venv/**,**/externals/**,**/node_modules/**
  set nolz

  " config plugins
  let g:ale_lint_on_enter = 0

  let g:airline_theme='solarized'
  let g:airline#extensions#tabline#formatter='default'
  let g:airline#extensions#tabline#enabled=1
  let g:airline#extensions#ale#enabled=1

  let g:indent_guides_enable_on_vim_startup=1
  let g:indent_guides_start_level=2

  " mappings
  let mapleader="z"
  " term config
  let g:neoterm_default_mod="botright"
  let g:neoterm_size=20
  let g:neoterm_fixedsize=1

  " replace bindings
  nnoremap <leader>r yiw:%s/\<<C-r><C-w>\>//gc<left><left><left>

  " term bindings
  nnoremap <A-t> :Tnew<CR>
  inoremap <A-t> <Esc> :Tnew<CR>
  tnoremap <A-t> <C-\><C-n> :Tnew<CR>

  nnoremap <A-`> :TtoggleAll<CR>
  inoremap <A-`> <Esc> :TtoggleAll<CR>
  tnoremap <A-`> <C-\><C-n> :TtoggleAll<CR>

  " term normal mode
  tnoremap <Esc> <C-\><C-n>
  tnoremap :q! <C-\><C-n>:q!<CR>

  " tab nav
  nnoremap <C-t> :tabnew<CR>
  nnoremap <C-Left> :tabprevious<CR>
  nnoremap <C-Right> :tabnext<CR>

  " nerdtree
  nnoremap <C-n> :NERDTreeToggle<CR>
  " fuzzy search
  map <C-p> :FZF<CR>
  map <C-g> :Rg<CR>
" Terminal Function
endif

set ts=2 sw=2 et
set clipboard+=unnamedplus
set cursorline
set ff=unix
set backspace=2

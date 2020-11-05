set nocompatible              " required
filetype off                  " required

let g:python3_host_prog = 'C:\Python37\python.exe'

call plug#begin('$localappdata/nvim/plug/')
  " extensions
  Plug 'ycm-core/YouCompleteMe', { 'do': 'python install.py --msvc 15 --ts-completer' }
  Plug 'dense-analysis/ale'
  Plug 'preservim/nerdtree'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'vim-airline/vim-airline'

  " languages
  Plug 'sheerun/vim-polyglot'

  " editing plugs
  Plug 'jiangmiao/auto-pairs'
  Plug 'tpope/vim-surround'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'godlygeek/tabular'
  Plug 'ncm2/float-preview.nvim'
call plug#end()

filetype plugin indent on    " required
syntax enable

set autowrite
set nu rnu
set splitright
set encoding=utf-8
set showmatch
set wildignore=**/.git/**,**/venv/**,**/externals/**,**/node_modules/**
"
" config plugins
let g:javascript_plugin_jsdoc = 1
let g:ale_lint_on_enter = 0
let g:airline#extensions#tabline#formatter='default'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#ale#enabled=1

let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2

let g:float_preview#docked = 1
" mappings
let mapleader="z"
"
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

set ts=2 sw=2 et
set clipboard+=unnamedplus
set cursorline
set ff=unix
set backspace=2

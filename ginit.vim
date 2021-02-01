set nocompatible              " required
filetype off                  " required

let g:python3_host_prog = 'C:\Python37\python.exe'

call plug#begin('$localappdata/nvim/plug/')
  " extensions
  " Plug 'ycm-core/YouCompleteMe', { 'do': 'python install.py --msvc 15 --ts-completer' }
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
  " Plug 'ncm2/float-preview.nvim'
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

let mapleader="z"

"""""" CoC config
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-html', 'coc-eslint', 'coc-tsserver']
set hidden
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

nnoremap <leader>x :CocAction<CR> 

"""""" End CoC config



" let g:float_preview#docked = 1
" mappings
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

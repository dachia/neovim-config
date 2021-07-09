set nocompatible              " required
filetype off                  " required

let g:python3_host_prog = 'C:\Python37\python.exe'

call plug#begin('$localappdata/nvim/plug/')
  " extensions
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/completion-nvim'
  " UI for lsp
  Plug 'glepnir/lspsaga.nvim'

  Plug 'preservim/nerdtree'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  " Fzf faster than telescope, but ui could use some work
  " Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  " Plug 'junegunn/fzf.vim'
  Plug 'hoob3rt/lualine.nvim'

  " languages
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

  " icons
  Plug 'kyazdani42/nvim-web-devicons'

  Plug 'nathanaelkane/vim-indent-guides'
  " editing plugs
  " Plug 'jiangmiao/auto-pairs'
  " Plug 'tpope/vim-surround'
  " Plug 'ntpeters/vim-better-whitespace'
  " Plug 'godlygeek/tabular'
call plug#end()

let g:LanguageClient_serverCommands = {
  \ 'sql': ['sql-language-server', 'up', '--method', 'stdio'],
  \ }

" Install and configure treesitter
lua <<EOF
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    indent = {
      enable = true
    },
    ensure_installed = {
      "tsx",
      "json",
      "jsdoc",
      "yaml",
      "html",
      "css",
      "python"
    },
  }

  local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
  parser_config.tsx.used_by = { "javascript", "typescript.tsx" }
EOF

" LSP
lua <<EOF
  local nvim_lsp = require'lspconfig'
  
  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    
    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    
    -- Mappings.
    local opts = { noremap=true, silent=true }
    
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    
    require'completion'.on_attach(client, bufnr)
    
    if client.resolved_capabilities.document_formatting then
      vim.api.nvim_command [[augroup Format]]
      vim.api.nvim_command [[autocmd! * <buffer>]]
      vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
      vim.api.nvim_command [[augroup END]]
    end
  end
  
  -- for linters and such
  nvim_lsp.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = { 'javascript', 'javascriptreact', 'json', 'typescript', 'typescriptreact', 'css', 'less', 'scss', 'markdown', 'pandoc' },
    init_options = {
      linters = {
        eslint = {
          command = 'eslint_d',
          rootPatterns = { '.git' },
          debounce = 100,
          args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
          sourceName = 'eslint_d',
          parseJson = {
            errorsRoot = '[0].messages',
            line = 'line',
            column = 'column',
            endLine = 'endLine',
            endColumn = 'endColumn',
            message = '[eslint] ${message} [${ruleId}]',
            security = 'severity'
          },
          securities = {
            [2] = 'error',
            [1] = 'warning'
          }
        },
      },
      filetypes = {
        javascript = 'eslint',
        javascriptreact = 'eslint',
        typescript = 'eslint',
        typescriptreact = 'eslint',
      },
      formatters = {
        eslint_d = {
          command = 'eslint_d',
          args = { '--stdin', '--stdin-filename', '%filename', '--fix-to-stdout' },
          rootPatterns = { '.git' },
        },
        prettier = {
          command = 'prettier',
          args = { '--stdin-filepath', '%filename' }
        }
      },
      formatFiletypes = {
        css = 'prettier',
        javascript = 'eslint_d',
        javascriptreact = 'eslint_d',
        json = 'prettier',
        scss = 'prettier',
        less = 'prettier',
        typescript = 'eslint_d',
        typescriptreact = 'eslint_d',
        json = 'prettier',
        markdown = 'prettier',
      }
    }
  }
  
  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  
  local servers = { "pyright", "sqlls", "tsserver" }
  
  for _, lsp in ipairs(servers) do
    if lsp == "sqlls" then
      nvim_lsp[lsp].setup {
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        },
        cmd = {"C:\\Program Files\\nodejs\\sql-language-server.ps1", "up", "--method", "stdio"}
      }
    else
      nvim_lsp[lsp].setup {
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        }
      }
    end
  end
EOF

lua <<EOF
  require'lualine'.setup {
    options = { theme = 'solarized_dark' }
  }
EOF

lua require 'lspsaga'.init_lsp_saga()

lua <<EOF
  local actions = require'telescope.actions'
  require'telescope'.setup{
    defaults = {
      mappings = {
        n = {
          ["q"] = actions.close
        },
      },
    }
  }
EOF

" completion vim
autocmd BufEnter * lua require'completion'.on_attach()

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
set completeopt=menuone,noinsert,noselect

let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2

let mapleader="z"


" mappings
"
" replace bindings
nnoremap <leader>r yiw:%s/\<<C-r><C-w>\>//gc<left><left><left>
" Completion mappings
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" lsp commands
inoremap <silent><C-k> <Cmd>Lspsaga signature_help<CR>
nnoremap <silent>K :Lspsaga hover_doc<CR>
nnoremap <silent>gh <Cmd>Lspsaga lsp_finder<CR>

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
"
" fuzzy search
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <C-g> <cmd>Telescope live_grep<cr>
nnoremap <silent> \\ <cmd>Telescope buffers<cr>
nnoremap <silent> ;; <cmd>Telescope help_tags<cr>
" map <C-p> :FZF<CR>
" map <C-g> :Rg<CR>

set ts=2 sw=2 et
set clipboard+=unnamedplus
set cursorline
set ff=unix
set backspace=2

set nocompatible              " required

call plug#begin()
  " fuzzy search, telescope is great but doesn't show all results which is
  " useless
  " Plug 'nvim-lua/popup.nvim'
  " Plug 'nvim-lua/plenary.nvim'
  " Plug 'nvim-telescope/telescope.nvim'

  Plug 'nvim-lua/completion-nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'Olical/aniseed'
  Plug 'nvim-treesitter/nvim-tree-docs'
  " database
  Plug 'tpope/vim-dadbod'
  Plug 'kristijanhusak/vim-dadbod-completion'
  Plug 'kristijanhusak/vim-dadbod-ui'
  " UI for lsp
  Plug 'glepnir/lspsaga.nvim'

  Plug 'preservim/nerdtree'
  "
  " Fzf faster than telescope, but ui could use some work
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  " Doesn't work on windows
  " Plug 'vijaymarupudi/nvim-fzf' " requires the nvim-fzf library
  " Plug 'vijaymarupudi/nvim-fzf-commands'


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

" Install and configure treesitter
lua <<EOF
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
    },
    tree_docs = {enable = true},
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
      enable = false
    },
    ensure_installed = {
      "tsx",
      "json",
      "jsdoc",
      "yaml",
      "html",
      "css",
      "python",
      "javascript",
      "comment",
      "dockerfile",
      "lua",
      "regex",
      "toml",
      "typescript",
      "yaml"
    }
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

    client.CompletionItemKind = {
      '', -- Text
      '', -- Method
      '', -- Function
      '', -- Constructor
      '', -- Field
      '', -- Variable
      '', -- Class
      'ﰮ', -- Interface
      '', -- Module
      '', -- Property
      '', -- Unit
      '', -- Value
      '', -- Enum
      '', -- Keyword
      '﬌', -- Snippet
      '', -- Color
      '', -- File
      '', -- Reference
      '', -- Folder
      '', -- EnumMember
      '', -- Constant
      '', -- Struct
      '', -- Event
      'ﬦ', -- Operator
      '', -- TypeParameter
    }
    
    -- Don't format on save
    -- if client.resolved_capabilities.document_formatting then
    --   vim.api.nvim_command [[augroup Format]]
    --   vim.api.nvim_command [[autocmd! * <buffer>]]
    --   vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    --   vim.api.nvim_command [[augroup END]]
    -- end
  end
  
  -- for linters and such
  nvim_lsp.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = { 'javascript', 'javascriptreact', 'json', 'typescript', 'typescriptreact', 'css', 'less', 'scss', 'markdown', 'pandoc' },
    cmd = {'diagnostic-languageserver', '--stdio'},
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
  local debounce = 100
  
  nvim_lsp["pyright"].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = debounce,
    },
  }
  nvim_lsp["tsserver"].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = debounce,
    },
  }
  
EOF

autocmd BufEnter * lua require'completion'.on_attach()

lua <<EOF
  require'lualine'.setup {
    options = { theme = 'solarized_dark' }
  }
EOF

lua <<EOF
require 'lspsaga'.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
}
EOF

" lua <<EOF
"   local actions = require'telescope.actions'
"   require'telescope'.setup{
"     defaults = {
"       mappings = {
"         n = {
"           ["q"] = actions.close
"         },
"       },
"     }
"   }
" EOF
"
" For completion-nvim
augroup completion
  autocmd!
  autocmd BufEnter * lua require'completion'.on_attach()
  autocmd FileType sql let g:completion_trigger_character = ['.', '"', '`', '[']
augroup END

" Source is automatically added, you just need to include it in the chain complete list
let g:completion_chain_complete_list = {
    \   'sql': [
    \    {'complete_items': ['vim-dadbod-completion']},
    \   ],
    \ }
" Make sure `substring` is part of this list. Other items are optional for this completion source
let g:completion_matching_strategy_list = ['exact', 'substring']
" Useful if there's a lot of camel case items
let g:completion_matching_ignore_case = 1
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

" tab nav
nnoremap <C-t> :tabnew<CR>
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>

"
nnoremap <C-b> :DBUI<CR>

" nerdtree
nnoremap <C-n> :NERDTreeToggle<CR>
"
" fuzzy search
" nnoremap <C-p> <cmd>Telescope find_files<cr>
" nnoremap <C-g> <cmd>Telescope live_grep<cr>
" nnoremap <silent> \\ <cmd>Telescope buffers<cr>
" nnoremap <silent> ;; <cmd>Telescope help_tags<cr>
nnoremap <C-p> :FZF<CR>
nnoremap <C-g> :Rg<CR>
" nnoremap <C-p> <cmd>lua require("fzf-commands").files()<CR>
" nnoremap <C-g> <cmd>lua require("fzf-commands").rg()<CR>

set ts=2 sw=2 et
set clipboard+=unnamedplus
set cursorline
set ff=unix
set backspace=2

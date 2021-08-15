local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

local map = require 'tools'.map

g.mapleader = "z"               -- map leader key
g.maplocalleader = g.mapleader  -- map local leader key

require("plugins")

local is_win = fn.has('win32') == 1 or false



-- Tree sitter
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
    "yaml",
    "python"
  }
}
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.used_by = { "javascript", "typescript.tsx" }

-- LSP
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
  buf_set_keymap('n', '<LocalLeader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<LocalLeader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<LocalLeader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<LocalLeader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<LocalLeader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<LocalLeader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<LocalLeader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<LocalLeader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<LocalLeader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

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
  
local diagnostic_cmd

if is_win then
  diagnostic_cmd = {'C:/Program Files/nodejs/diagnostic-languageserver.cmd', '--stdio'}
else
  diagnostic_cmd = {'diagnostic-languageserver', '--stdio'}
end

-- for linters and such
nvim_lsp.diagnosticls.setup {
  on_attach = on_attach,
  filetypes = { 'javascript', 'javascriptreact', 'json', 'typescript', 'typescriptreact', 'css', 'less', 'scss', 'markdown', 'pandoc' },
  cmd = diagnostic_cmd,
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
  
require 'lualine'.setup {
  options = { theme = 'solarized_dark' }
}

require 'lspsaga'.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
}

require 'snippets'.use_suggested_mappings(true)

cmd [[
  autocmd BufEnter * lua require'completion'.on_attach()
]]

-- Complete nvim config
opt.completeopt = {'menuone', 'noinsert', 'noselect'}
g.completion_enable_snippet = 'snippets.nvim'
g.completion_enable_auto_signature = 1
g.completion_enable_auto_hover = 1
g.completion_enable_auto_popup = 1

-- indent guides 
g.indent_guides_enable_on_vim_startup = 1
g.indent_guides_start_level = 2

-- general vim opts
opt.autowrite = true                -- Auto save
opt.number = true                   -- Show line numbers
opt.relativenumber = true           -- Relative line numbers
opt.smartcase = true                -- Do not ignore case with capitals
opt.smartindent = true              -- Insert indents automatically
opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new windows right of current
opt.encoding = 'utf-8'              -- Encoding
opt.tabstop = 2                     -- Number of spaces tabs count for
opt.wrap = false                    -- Disable line wrap
opt.termguicolors = true            -- True color support
opt.list = true                     -- Show some invisible characters
opt.wildignore = {'**/.git/**','**/venv/**','**/externals/**', '**/node_modules/**'} -- ignore
opt.cursorline = true               -- Cursor line
opt.shiftwidth = 2                  -- Indetation after enter
opt.expandtab = true                -- spaces instead of tabs
opt.fileformat = 'unix'             -- file format relevant for line breaks on windows. Always use unix
opt.clipboard = "unnamedplus"       -- windows clipboard
opt.ttimeoutlen = 100               -- for leader key

-- MAPPINGS
-- replace
map('n', '<Leader>r', 'yiw:%s/\\<<C-r><C-w>\\>//gc<left><left><left>')
-- Tabs
map('n', '<C-t>', ':tabnew<CR>')
map('n', '<C-Left>', ':tabprevious<CR>')
map('n', '<C-Right>', ':tabnext<CR>')
-- DB maps
map('n', '<C-b>', ':DBUI<CR>')
-- File tree maps
map('n', '<C-n>', ':NERDTreeToggle<CR>')
-- Fuzzy search maps
map('n', '<C-p>', ':FZF<CR>')
map('n', '<C-g>', ':Rg<CR>')

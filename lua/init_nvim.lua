local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

local map = require 'tools'.map

g.mapleader = "z"               -- map leader key
g.maplocalleader = g.mapleader  -- map local leader key

require("plugins")

local is_win = fn.has('win32') == 1 or false

-- LSP
local opts = { noremap=true, silent=true }

vim.keymap.set('n', '<LocalLeader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<LocalLeader>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap=true, silent=true, buffer=bufnr }

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<LocalLeader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<LocalLeader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<LocalLeader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<LocalLeader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<LocalLeader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<LocalLeader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<LocalLeader>t', function ()
    vim.lsp.buf.formatting { async = Tree }
  end, bufopts)
end

local lspconfig = require('lspconfig')
g.coq_settings = { auto_start= true }
local coq = require('coq')

local lsp_flags = {
  debounce_text_changes = 150,
}
lspconfig['tsserver'].setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach,
  flags = lsp_flags,
  cmd = { "typescript-language-server", "--stdio", "--log-level", "1" },
  init_options = {
    -- maxTsServerMemory = 4096,
    disableAutomaticTypingAcquisition = true
  }
}))


vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- Tree sitter
require'nvim-treesitter.configs'.setup {
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
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

require 'lualine'.setup {
  options = { theme = "catppuccin" }
}


require'nvim-tree'.setup({
  view = {
    width = 50,
    side = "left"
  }
})

-- Theme
require'catppuccin'.setup()
vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
vim.cmd[[colorscheme catppuccin]]

-- general vim opts
vim.o.hlsearch = false              -- Set highlight on search

vim.opt.shortmess = vim.opt.shortmess + { I = true }
vim.opt.cmdheight = 2

-- idennt
vim.o.breakindent = true -- Enable break indent
opt.smartindent = true -- Insert indents automatically
opt.autoindent = true

vim.o.mouse = 'a'                   -- enable mouse
opt.undofile = true                 -- save undo history
--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = false
--Decrease update time
vim.o.updatetime = 50
vim.wo.signcolumn = 'yes'

opt.syntax = 'off'                  -- disable higlight, tree sitter does that
opt.undofile = true
opt.autowrite = true                -- Auto save
opt.number = true                   -- Show line numbers
opt.relativenumber = true           -- Relative line numbers
opt.smartcase = true                -- Do not ignore case with capitals
opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new windows right of current
opt.encoding = 'utf-8'              -- Encoding
opt.tabstop = 2                     -- Number of spaces tabs count for
opt.wrap = false                    -- Disable line wrap
opt.termguicolors = true            -- True color support
opt.list = true                     -- Show some invisible characters
opt.wildignore = {'**/.git/**','**/venv/**','**/externals/**', '**/node_modules/**', '**/dist/**'} -- ignore
opt.cursorline = true               -- Cursor line
opt.shiftwidth = 2                  -- Indetation after enter
opt.expandtab = true                -- spaces instead of tabs
opt.fileformat = 'unix'             -- file format relevant for line breaks on windows. Always use unix
opt.clipboard = "unnamedplus"       -- windows clipboard
opt.ttimeoutlen = 50               -- for leader key


-- MAPPINGS
-- replace
map('n', '<Leader>r', 'yiw:%s/<C-r><C-w>//gc<left><left><left>')
-- Tabs
map('n', '<C-t>', ':tabnew<CR>')

-- DB
-- map('n', '<C-b>', ':DBUI<CR>')

if is_win then
  map('n', '<C-Left>', ':tabprevious<CR>')
  map('n', '<C-Right>', ':tabnext<CR>')
else
  map('n', '<A-Left>', ':tabprevious<CR>')
  map('n', '<A-Right>', ':tabnext<CR>')
end
-- File tree maps
map('n', '<C-n>', ':NvimTreeFindFileToggle<CR>')
-- map('n', '<C-n>', ':NvimTreeToggle<CR>')
-- Fuzzy search maps
map('n', '<C-p>', ':FZF<CR>')
map('n', '<C-g>', ':Rg<CR>')


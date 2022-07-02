local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

local map = require 'tools'.map

g.mapleader = "z"               -- map leader key
g.maplocalleader = g.mapleader  -- map local leader key

require("plugins")

local is_win = fn.has('win32') == 1 or false
local use_coc = false

local buf_map = function(bufnr, mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
    silent = true,
  })
end
  

if use_coc then
  g.coc_global_extensions = { 'coc-json', 'coc-tsserver', 'coc-git', 'coc-prettier', 'coc-eslint' }
  -- Map function is not working. using vim script
  -- map('n', '<Leader>rn', '<Plug>(coc-rename)')
  -- map('n', '<Leader>ac', '<Plug>(coc-codeaction)')
  -- map('n', '<leader>cl', '<Plug>(coc-codelens-action)')
  -- Diagnostics
  -- map('n', '[g', '<Plug>(coc-diagnostic-prev)')
  -- map('n', ']g', '<Plug>(coc-diagnostic-next)')
  -- Definitions
  -- map('n', 'gd', '<Plug>(coc-definition)')
  -- map('n', 'gy', '<Plug>(coc-type-definition)')
  -- map('n', 'gi', '<Plug>(coc-implementation)')
  -- map('n', 'gr', '<Plug>(coc-references)')
  -- -- Coc-format
  vim.cmd [[

    " Use <c-space> to trigger completion.
    inoremap <silent><expr> <c-space> coc#refresh()

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute '!' . &keywordprg . " " . expand('<cword>')
      endif
    endfunction

    " Use K to show documentation in preview window.
    nnoremap <silent> <Leader>e :call <SID>show_documentation()<CR>


    " GoTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    command! -nargs=0 Prettier :CocCommand prettier.formatFile

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Symbol renaming.
    nmap <leader>rn <Plug>(coc-rename)

    " Remap keys for applying codeAction to the current buffer.
    nmap <leader>ac  <Plug>(coc-codeaction)

    " Add `:OR` command for organize imports of the current buffer.
    command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

    " Autoimport on completion
    noremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    " Fix current line
    nmap <leader>qf  <Plug>(coc-fix-current)
  ]]
  map('n', '<leader>f', ':Prettier<CR>')
  map('n', '<leader>i', ':OR<CR>')
else
  -- LSP
  local lspconfig = require'lspconfig'
  
  local on_attach = function(client, bufnr)
    vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
    vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
    vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
    vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
    vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
    vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
    vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
    vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
    vim.cmd("command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()")
    vim.cmd("command! LspDiagNext lua vim.lsp.diagnostic.goto_next()")
    vim.cmd("command! LspDiagLine lua vim.lsp.diagnostic.show_line_diagnostics()")
    vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
    buf_map(bufnr, "n", "gd", ":LspDef<CR>")
    buf_map(bufnr, "n", "<LocalLeader>rn", ":LspRename<CR>")
    buf_map(bufnr, "n", "gy", ":LspTypeDef<CR>")
    buf_map(bufnr, "n", "K", ":LspHover<CR>")
    buf_map(bufnr, "n", "[a", ":LspDiagPrev<CR>")
    buf_map(bufnr, "n", "]a", ":LspDiagNext<CR>")
    buf_map(bufnr, "n", "<LocalLeader>ca", ":LspCodeAction<CR>")
    buf_map(bufnr, "n", "<LocalLeader>e", ":LspDiagLine<CR>")
    buf_map(bufnr, "i", "<C-k>", "<cmd> LspSignatureHelp<CR>")
  
    if client.resolved_capabilities.document_formatting then
      vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
    end
  end
  
  -- nvim-cmp supports additional completion capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities) 
  
  local debounce_text_changes = 20
  
  lspconfig["pyright"].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = debounce_text_changes,
    }
  }
  
  lspconfig["tsserver"].setup {
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      local ts_utils = require("nvim-lsp-ts-utils")
      ts_utils.setup({
        eslint_bin = "eslint_d",
        eslint_enable_diagnostics = true,
        eslint_enable_code_actions = true,
        enable_formatting = true,
        formatter = "prettier",
        enable_import_on_completion = true
      })
      ts_utils.setup_client(client)
      buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
      buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
      buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")
      on_attach(client, bufnr)
    end,
  
    init_options = {
      hostInfo = "neovim",
      disableAutomaticTypingAcquisition = true,
    },
    capabilities = capabilities,
    diagnosticsDelay = "500ms",
    experimentalWatchedFileDelay = "1000ms",
    flags = {
      allow_incremental_sync = true,
      debounce_text_changes = debounce_text_changes,
    }
  }
  
  local null_ls = require("null-ls")
  null_ls.setup({
      sources = {
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.code_actions.eslint,
          null_ls.builtins.formatting.prettier
      },
      on_attach = on_attach
  })

  require "lsp_signature".setup{
    bind = true,
    hint_enable = false,
    handler_opts = {border = "single"},
    toggle_key = "<C-s>"
    -- extra_trigger_chars = {"(", ","},
  }
  -- autocompletion
  local cmp = require 'cmp'
  cmp.setup {
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<CR>'] = cmp.mapping.confirm {
        select = true,
      },
      ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
      ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
    },
    sources = {
      { name = 'nvim_lsp', max_item_count = 5 },
      { name = "buffer", max_item_count = 5 },
      { name = 'luasnip', max_item_count = 1 }
    },
    completion = {
      keyword_length = 3
    }
  }
  vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
end

-- Tree sitter
require'nvim-treesitter.configs'.setup {
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

require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  update_to_buf_dir   = {
    enable = true,
    auto_open = false,
  },
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = true,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  view = {
    side = 'left',
    auto_resize = true,
    width = 50,
  }
}

--
-- Theme
require'catppuccin'.setup(
  {
		colorscheme = "dark_catppuccino",
		transparency = false,
		term_colors = false,
		styles = {
			comments = "italic",
			functions = "italic",
			keywords = "italic",
			strings = "NONE",
			variables = "NONE",
		},
		integrations = {
			treesitter = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = "italic",
					hints = "italic",
					warnings = "italic",
					information = "italic",
				},
				underlines = {
					errors = "underline",
					hints = "underline",
					warnings = "underline",
					information = "underline",
				}
			},
			lsp_trouble = false,
			lsp_saga = false,
			gitgutter = false,
			gitsigns = false,
			telescope = false,
			nvimtree = {
				enabled = true,
				show_root = true,
			},
			which_key = false,
			indent_blankline = {
				enabled = true,
				colored_indent_levels = true,
			},
			dashboard = false,
			neogit = false,
			vim_sneak = false,
			fern = false,
			barbar = false,
			bufferline = false,
			markdown = false,
			lightspeed = false,
			ts_rainbow = false,
			hop = false,
		}
	}
)
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

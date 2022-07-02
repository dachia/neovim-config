vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  --
  -- languages (highlighting, autocomplete, indent)
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- language servers
  use 'neovim/nvim-lspconfig' --, commit = '96b764ba7925cfafb8346cb5afd7b128e6f8bb8a' }
  -- typescript language server improvements
  use 'nvim-lua/plenary.nvim'
  use "jose-elias-alvarez/null-ls.nvim"
  use "jose-elias-alvarez/nvim-lsp-ts-utils"
  -- autocomplete
  -- clide/coc.nvim', {'branch': 'release'}
  use 'hrsh7th/cmp-buffer' -- buffer autocmp
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  -- signature help
  use "ray-x/lsp_signature.nvim"

  -- CoC
  -- use { 'neoclide/coc.nvim', branch = 'master', run = 'npm i'}
  -- tree docs
  use { 'kkoomen/vim-doge' } 

  -- DB
  use { 'tpope/vim-dadbod' }
  use { 'kristijanhusak/vim-dadbod-ui' }
  -- Fuzzy search
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install'](0) end }
  use 'junegunn/fzf.vim'
  
  -- File tree
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function() require'nvim-tree'.setup {} end
  } 
  -- other
  use 'hoob3rt/lualine.nvim'
  --
  -- themes
  use "catppuccin/nvim"
end)

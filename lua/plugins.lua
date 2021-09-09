vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  --
  -- language servers
  use 'neovim/nvim-lspconfig' --, commit = '96b764ba7925cfafb8346cb5afd7b128e6f8bb8a' }
  
  -- languages (highlighting, autocomplete, indent)
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/nvim-treesitter-textobjects'  
  
  -- autocomplete
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin

  -- docs
  use { 'kkoomen/vim-doge', run = function() vim.fn["doge#install()"]() end }

  -- database
  use 'tpope/vim-dadbod'
  use 'kristijanhusak/vim-dadbod-ui'
  
  -- UI for lsp
  use 'glepnir/lspsaga.nvim'
  
  -- File tree
  use 'preservim/nerdtree'
  
  -- Fuzzy search
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install'](0) end }
  use 'junegunn/fzf.vim'
  
  -- icons 
  use 'kyazdani42/nvim-web-devicons'
  
  -- other
  use 'nathanaelkane/vim-indent-guides'
  use 'hoob3rt/lualine.nvim'
end)

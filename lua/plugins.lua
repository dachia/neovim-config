vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
  -- autocomplete
  use 'nvim-lua/completion-nvim'
  
  -- language servers
  use 'neovim/nvim-lspconfig'
  
  -- req for tree docs
  use 'Olical/aniseed'
  use 'nvim-treesitter/nvim-tree-docs'
  
  -- database
  use 'tpope/vim-dadbod'
  use 'kristijanhusak/vim-dadbod-completion'
  use 'kristijanhusak/vim-dadbod-ui'
  
  -- UI for lsp
  use 'glepnir/lspsaga.nvim'
  
  -- File tree
  use 'preservim/nerdtree'
  
  -- Fuzzy search
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install'](0) end }

  use 'junegunn/fzf.vim'
  
  -- languages (highlighting, autocomplete, indent)
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  
  -- icons 
  use 'kyazdani42/nvim-web-devicons'
  
  -- other
  use 'nathanaelkane/vim-indent-guides'
  use 'hoob3rt/lualine.nvim'
  use 'norcalli/snippets.nvim'
end)

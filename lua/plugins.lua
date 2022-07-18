vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  --
  -- languages (highlighting, autocomplete, indent)
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- language servers
  use 'neovim/nvim-lspconfig' --, commit = '96b764ba7925cfafb8346cb5afd7b128e6f8bb8a' }

  use { 'ms-jpq/coq_nvim', branch='coq'}
  use {'ms-jpq/coq.artifacts', branch = 'artifacts'}
  -- tree docs
  use { 'kkoomen/vim-doge' } 

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
  use { "catppuccin/nvim", as = "catppuccin" }
end)

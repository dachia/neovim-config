# Neovim configuration files and requirements

Configuration instructions for neovim

Requiremens:

  1. node.js and npm

## Windows

Installation instructions on windows. Prerequisites:
  
  1. chocolatey package manager
  2. Enable developer mode

### Neovim

  1. Install neovim
   `choco install neovim`
  

### Fuzzy search

  Uses external tool for fuzzy file search and fuzzy search inside files.

  1. ripgrep for fuzzy search 
   `choco install ripgrep`

  2. fzf for filtering(fuzzy finder)
   `choco install fzf`

  3. to use rigprep as a default command for fzf add environmental variable(respect .gitignore and exclude hidden)
  `FZF_DEFAULT_COMMAND=rg --files --hidden`

### Neovim package manager

  1. packer.nvim
   `git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"`

### Add powershell alias

  1. edit powershell profile
   `nvim $PROFILE`

  2. Add new line (change patch to where choco install by default)
   `New-Alias -Name v -Value 'C:\tools\neovim\Neovim\bin\nvim-qt.exe'`

### Copy neovim configs

  1. Copy configs
   ```
   cp -Recurse -Force ./lua ~/AppData/Local/nvim
   cp ./init.lua ~/AppData/Local/nvim
   ```

## Other requirements

  1. Language servers, neovim/py/ts bindings, linters(older language server isnt working)
   `npm i -g typescript typescript-language-server@0.5.4 pyright diagnostic-languageserver eslint eslint_d prettier neovim`

## Install neovim plugins

  1. `:PackerInstall`

# Neovim configuration files and requirements

Applicable to windows first and foremost because thats my OS of choice

## Installation

 - ripgrep for fuzzy search 
  `choco install ripgrep`

 - fzf for filtering(fuzzy finder)
  `choco install fzf`
  to use rigprep as a default command for fzf add environmental variable(respect .gitignore and exclude hidden)
  `FZF_DEFAULT_COMMAND=rg --files --hidden`

 - vim plug to manage vim plugins
  ```
    md ~\AppData\Local\nvim\autoload
    $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    (New-Object Net.WebClient).DownloadFile(
      $uri,
      $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
        "~\AppData\Local\nvim\autoload\plug.vim"
      )
    )
  ```

 - install neovim
  `choco install neovim`

 - add powershell alias
  ```
  nvim $PROFILE

  New-Alias -Name v -Value 'C:\tools\neovim\Neovim\bin\nvim-qt.exe'
  ```

 - neovim
  ```
    npm i lehre --prefix C:\Users\artur\AppData\Local\nvim\plug\vim-jsdoc\
  ```

 - copy configs
  ```
  cp ./ginit.vim ~/AppData/Local/nvim
  cp ./init.vim ~/AppData/Local/nvim
  ```
 - Run `:PlugInstall`
 - Build, might need to pass `python C:\Users\artur\AppData\Local\nvim\plug\YouCompleteMe\install.py --msvc 15 --ts-completer` flag https://github.com/ycm-core/YouCompleteMe#windows
 - Language servers (setup guide https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sqlls)
  - sql/ts/python/diagnostic ls/eslint daemon and prettier global: npm i -g sql-language-server typescript typescript-language-server pyright diagnostic-languageserver eslint eslint_d prettier neovim

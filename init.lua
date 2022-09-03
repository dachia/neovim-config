if vim.g.vscode then
    -- VSCode extension
  require("init_vscode")
else
    -- ordinary Neovim
  require("init_nvim")
end

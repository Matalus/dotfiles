-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- Disable autoformat for powershell files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "ps1" },
  callback = function()
    vim.b.autoformat = false
  end,
}) --
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "psm1" },
  callback = function()
    vim.b.autoformat = false
  end,
}) --

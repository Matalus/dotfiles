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

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.tf", "*.hcl", "*.tfvars" },
  callback = function()
    vim.bo.filetype = "terraform"
  end,
})
-- Auto-wrap for Trouble window
vim.api.nvim_create_autocmd("FileType", {
  pattern = "Trouble",
  callback = function()
    vim.wo.wrap = true -- Enable line wrap
  end,
})

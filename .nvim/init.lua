-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- PowerShell as default terminal
vim.o.shell = "pwsh"
vim.o.shellcmdflag =
" -NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %%s: exit $LastExitCode"
vim.o.shellquote = ""
vim.o.shellxquote = ""
vim.o.inccommand = "split"

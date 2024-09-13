return {
  -- nordic colorscheme
  {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000,
    --   config = function()
    --     require 'nordic'.load()
    --   end
  },
  -- onedark colorscheme
  {
    'navarasu/onedark.nvim',
    branch = "master",
  },
  -- catpuccin color
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000
  },
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,

  },
  {
    "xero/evangelion.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme("evangelion")
    end,
  },
  -- Set ColorScheme on Load
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-wave",
    },
  },

}

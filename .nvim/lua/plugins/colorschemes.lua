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
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      }
    }
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
  {
    "sho-87/kanagawa-paper.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    'marko-cerovac/material.nvim'
  },
  -- Set ColorScheme on Load
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-wave",
    },
  },

}

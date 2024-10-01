return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        cmdline = {
          view = "cmdline_popup",
        },
        -- messages = {
        --   view = "popup",
        -- },
      })
    end,
    opts = {
      presets = {
        long_message_to_split = true, -- Optional: move long messages to a split
      },
      lsp = {
        -- Optional: modify LSP-related notifications or message settings
      },
      -- Customizing notification timeout
      notify = {
        timeout = 20000, -- Set the timeout to 5000 milliseconds (5 seconds)
      },
      messages = {
        timeout = 20000,
      }
    },
  },
}

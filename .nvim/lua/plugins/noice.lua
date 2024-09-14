return {
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        long_message_to_split = true, -- Optional: move long messages to a split
      },
      lsp = {
        -- Optional: modify LSP-related notifications or message settings
      },
      -- Customizing notification timeout
      notify = {
        timeout = 10000, -- Set the timeout to 5000 milliseconds (5 seconds)
      },
      messages = {
        timeout = 20000,
      }
    },
  },
}

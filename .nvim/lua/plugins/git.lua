return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()

      vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "GitSigns: Preview Hunk" })
      vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>",
        { desc = "GitSigns: Toggle Current Line Blame" })
    end
  },
  {
    "tpope/vim-fugitive",
  }
}

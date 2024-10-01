return {
  {
    "TheLeoP/powershell.nvim",
    --@type powershell.user_config
    config = function()
      require("powershell").setup({
        bundle_path = "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services/PowerShellEditorServices",
        settings = {
          codeFormatting = {
            openBraceOnSameLine = true,
            whitespaceInsideBrace = true,
          },
          enableProfileLoading = false,

        },
      })
    end,
    lazy = false,
    branch = "main",
  },
  -- DAP config TODO
  -- {
  --   "Willem-J-an/nvim-dap-powershell",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "mfussenegger/nvim-dap",
  --     "rcarriga/nvim-dap-ui",
  --     {
  --       "m00qek/baleia.nvim",
  --       lazy = true,
  --       tag = "v1.4.0",
  --     },
  --   },
  --   config = function()
  --     require("dap-powershell").setup({
  --       include_configs = true,
  --       pwsh_executable = "pwsh",
  --       pses_bundle_path = "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services/PowerShellEditorServices",
  --     })
  --   end,
  -- },
}

return {
  {
    "TheLeoP/powershell.nvim",
    --@type powershell.user_config
    opts = {
      bundle_path = "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services/PowerShellEditorServices",
    },
    lazy = false,
    branch = "main",
  },
  {
    "Willem-J-an/nvim-dap-powershell",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      {
        "m00qek/baleia.nvim",
        lazy = true,
        tag = "v1.4.0",
      },
    },
    config = function()
      require("dap-powershell").setup()
    end,
  },
}

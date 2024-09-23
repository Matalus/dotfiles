return {
  -- These are some examples, uncomment them if you want to see them work!
  {
    "stevearc/conform.nvim",
    lazy = false,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>f",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    -- config = function()
    --   require("lspconfig").powershell_es.setup({
    --     bundle_path = "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services/PowerShellEditorServices",
    --     shell = "pswsh",
    --   })
    -- end,
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        powershell = {
          "powershell_es",
          "prettier",
          -- command = "pwsh",
          -- args = {
          --   "-NoProfile",
          --   "-Command",
          --   "{Invoke-Formatter -ScriptDefinition $($input | Out-String) -Settings @{ 'Style' = 'OTBS' } }",
          -- }
        },
      },
      -- Set default options
      default_format_opts = {
        lsp_format = "fallback",
      },
      -- Set up format-on-save
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        powershell_es = {
          command = "pwsh",
          args = {
            "-NoProfile",
            "-Command",
            "{Invoke-Formatter -ScriptDefinition $($input | Out-String) -Settings @{ 'Style' = 'OTBS' } }",
          },
          codeFormatting = {
            openBraceOnSameLine = true,
          },
          bundle_path = "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services/PowerShellEditorServices",

        },
        prettier = {
          prepend_args = { "--bracket-same-line", },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}

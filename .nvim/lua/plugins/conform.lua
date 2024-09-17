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
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        ps1 = { "powershell_es" },
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
        prettierd = {
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

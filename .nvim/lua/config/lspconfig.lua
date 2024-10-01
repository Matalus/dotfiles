return {
  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {}
      }
    }
  },
  -- add markdown linting
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.efm.setup {
        init_options = {
          documentFormatting = true
        },
        filetypes = { "markdown" },
        settings = {
          rootMarkers = { ".git" },
          languages = {
            markdown = {
              lintCommand = "markdownlint -s",
              lintStdin = true,
              lintFormats = { "%f:%1 %m" }
            }
          }
        }
      }
    end
  },
  -- add tsserver and setup with typescript.nvim instead of lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", {
            buffer = buffer,
            desc = "Organize Imports"
          })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", {
            desc = "Rename File",
            buffer = buffer
          })
        end)
      end
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver will be automatically installed with mason and loaded with lspconfig
        tsserver = {}
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        tsserver = function(_, opts)
          require("typescript").setup({
            server = opts
          })
          return true
        end
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      }
    }
  },
  -- add powershell config
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      lspconfig.powershell_es.setup({
        filetypes = { "ps1", "psm1", "psd1" },
        bundle_path = "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services/PowerShellEditorServices",
        -- cmd = { 'pwsh', '-NoLogo', '-NoProfile', '-Command', "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services/Start-EditorServices.ps1", },
        settings = {
          powershell = {
            codeFormatting = {
              Preset = 'OTBS',
              openBraceOnSameLine = true,
            },
            scriptAnalysis = {
              enable = true,
              settingsPath =
              "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services/PSScriptAnalyzer/1.22.0/PSScriptAnalyzer.psd1",
            }
          }
        },
        init_options = {
          enableProfileLoading = false,
        },
      })

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({ 'n' }, '<leader>ca', vim.lsp.buf.code_action, {})
    end
  },
  {
    "j-hui/fidget.nvim",
    opts = {
      -- options
    }
  },

  'neovim/nvim-lspconfig',
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim"
    -- "rafamadriz/friendly-snippets",
  },
  config = function()
    local lspconfig = require("lspconfig")
    lspconfig.lua_ls.setup({})
    lspconfig.powershell_es.setup({
      filetypes = { "ps1", "psm1", "psd1" },
      bundle_path = "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services",
      settings = { powershell = { "codeFormattingOTBS" } },
      init_options = {
        enableProfileLoading = false,
      }
    })
  end
}

return {
  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
      },
    },
  },
  -- add markdown linting
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.efm.setup {
        init_options = { documentFormatting = true },
        filetypes = { "markdown" },
        settings = {
          rootMarkers = { ".git" },
          languages = {
            markdown = {
              lintCommand = "markdownlint -s",
              lintStdin = true,
              lintFormats = { "%f:%1 %m" },
            }
          }
        }
      }
    end,
  },
  -- add tsserver and setup with typescript.nvim instead of lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver will be automatically installed with mason and loaded with lspconfig
        tsserver = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },
  -- add powershell config
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     local lspconfig = require("lspconfig")
  --     lspconfig.lua_ls.setup({})
  --     lspconfig.powershell_es.setup({
  --       filetypes = { "ps1", "psm1", "psd1" },
  --       bundle_path = "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services",
  --       -- cmd = { 'pwsh', '-NoLogo', '-NoProfile', '-Command', "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services/Start-EditorServices.ps1", },
  --       settings = { powershell = { codeFormatting = { Preset = 'OTBS' } } },
  --       init_options = {
  --         enableProfileLoading = false,
  --       },
  --     })
  --
  --     vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
  --     vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
  --     vim.keymap.set({ 'n' }, '<leader>ca', vim.lsp.buf.code_action, {})
  --   end
  -- },
  {
    "j-hui/fidget.nvim",
    opts = {
      -- options
    }
  },

  -- LSP config function
  -- config = function()
  --   local cmp = require "cmp"
  --   local cmp_lsp = require "cmp_nvim_lsp"
  --   local capabilities =
  --       vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
  --
  --   require("fidget").setup {}
  --   require("mason").setup()
  --   require("mason-lspconfig").setup {
  --     ensure_installed = {},
  --     handlers = {
  --       function(server_name)
  --         require("lspconfig")[server_name].setup {
  --           capabilities = capabilities,
  --         }
  --       end,
  --
  --       powershell_es = function()
  --         local lspconfig = require "lspconfig"
  --         lspconfig.powershell_es.setup {
  --           --bundle_path = "~/.config/nvim/pses",
  --           cmd = { "pwsh", "-NoLogo", "-NoProfile", "-Command", "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services/Start-EditorServices.ps1 ..." },
  --           init_options = {
  --             enableProfileLoading = false,
  --           },
  --           on_attach = function(client, bufnr)
  --             vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  --           end,
  --           settings = {
  --             powershell = {
  --               codeFormatting = { Preset = "OTBS", newLineAfterCloseBrace = false },
  --             },
  --           },
  --         }
  --       end,
  --     },
  --   }
  --
  --   -- require("luasnip.loaders.from_vscode").lazy_load()
  --
  --   local cmp_select = { behavior = cmp.SelectBehavior.Replace }
  --
  --   cmp.setup {
  --     snippet = {
  --       expand = function(args)
  --         require("luasnip").lsp_expand(args.body)
  --       end,
  --     },
  --     mapping = cmp.mapping.preset.insert {
  --       ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(cmp_select), { "i" }),
  --       ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(cmp_select), { "i" }),
  --       ["<C-y>"] = cmp.mapping.confirm { select = true },
  --       ["<C-Space>"] = cmp.mapping.complete(),
  --     },
  --     sources = cmp.config.sources({
  --       { name = "nvim_lsp" },
  --       { name = "luasnip" },
  --     }, {
  --       { name = "buffer" },
  --     }),
  --   }
  --
  --   vim.diagnostic.config {
  --     float = {
  --       focusable = false,
  --       style = "minimal",
  --       border = "rounded",
  --       source = "always",
  --       header = "",
  --       prefix = "",
  --     },
  --   }
  -- end
}

return {
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
    "j-hui/fidget.nvim",
    -- "rafamadriz/friendly-snippets",
  },

--   config = function()
--     local cmp = require('cmp')
--     local cmp_lsp = require('cmp_nvim_lsp')
--     local capabilities = vim.tbl_deep_extend(
--       'force',
--       {},
--       vim.lsp.protocol.make_client_capabilities(),
--       cmp_lsp.default_capabilities())

--     require('fidget').setup({})
--     require('mason').setup()
--     require('mason-lspconfig').setup({
--       ensure_installed = {},
--       handlers = {
--         function(server_name)
--           require('lspconfig')[server_name].setup {
--             capabilities = capabilities
--           }
--         end,

--         powershell_es = function()
--           local lspconfig = require('lspconfig')
--           lspconfig.powershell_es.setup {
--             cmd = { "pwsh", "-NoLogo", "-NoProfile", "-Command", "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services/PowerShellEditorServices/Start-EditorServices.ps1" },
--             -- bundle_path = "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services/PowerShellEditorServices",
--             on_attach = function(client, bufnr)
--               vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--             end,
--             settings = { powershell = { codeFormatting = { Preset = 'OTBS' } } }
--           }
--         end
--       }
--     })

--     -- require("luasnip.loaders.from_vscode").lazy_load()

--     local cmp_select = { behavior = cmp.SelectBehavior.Replace }

--     cmp.setup({
--       snippet = {
--         expand = function(args)
--           require('luasnip').lsp_expand(args.body)
--         end,
--       },
--       mapping = cmp.mapping.preset.insert({
--         ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(cmp_select), { 'i' }),
--         ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(cmp_select), { 'i' }),
--         ['<C-y>'] = cmp.mapping.confirm({ select = true }),
--         ['<C-Space>'] = cmp.mapping.complete(),
--       }),
--       sources = cmp.config.sources({
--         { name = 'nvim_lsp' },
--         { name = 'luasnip' },
--       }, {
--         { name = 'buffer' },
--       })
--     })

--     vim.diagnostic.config({
--       float = {
--         focusable = false,
--         style = 'minimal',
--         border = 'rounded',
--         source = 'always',
--         header = '',
--         prefix = '',
--       },
--     })
--   end
}

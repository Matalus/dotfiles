-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

local servers = { "html", "cssls", "powershell_es", "lua_ls" }

-- require("powershell").setup {
--     bundle_path = vim.fn.stdpath "data" .. "/mason/packages/powershell-editor-services",
--   }
--   -- load theme
--   dofile(vim.g.base46_cache .. "defaults")
--   dofile(vim.g.base46_cache .. "statusline")
--   -- undotree keymap
--   vim.keymap.set("n", "<leader><F5>", vim.cmd.undoTreeToggle)
--   vim.g.undoTree_DiffCommand = "diff"
--   require "options"
--   require "nvchad.autocmds"
  
--   vim.schedule(function()
--     require "mappings"
--   end)

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

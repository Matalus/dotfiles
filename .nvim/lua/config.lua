-- Example configuration to disable auto-launch of the PowerShell Integrated Console
local lspconfig = require('lspconfig')

-- If you're using PowerShell via lspconfig, disable automatic launching
lspconfig.powershell_es.setup {
  on_attach = function(client, bufnr)
    -- Add code here to prevent auto-launch of the console
    -- Example: Disable terminal opening on startup
    client.resolved_capabilities.document_formatting = false
  end,
}

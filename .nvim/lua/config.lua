-- Example configuration to disable auto-launch of the PowerShell Integrated Console
local lspconfig = require('lspconfig')

-- If you're using PowerShell via lspconfig, disable automatic launching
lspconfig.powershell_es.setup {
  settings = {
    powershell = {
      codeFormatting = {
        -- Preset = 'OTBS',
        openBraceOnSameLine = true,
      },
      scriptAnalysis = {
        enable = true,
        -- settingsPath = "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services/PSScriptAnalyzer/1.22.0/PSScriptAnalyzer.psd1",
      }
    },
    init_options = {
      enableProfileLoading = false,
    },
  },
  -- Add code here to prevent auto-launch of the console
  -- Example: Disable terminal opening on startup
  -- client.resolved_capabilities.document_formatting = false
  -- }
}

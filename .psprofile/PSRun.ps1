Write-Host -ForegroundColor Cyan "Setting: PSRun Options: " -NoNewline
# Enable PSRun
Try {
  Enable-PSRunEntry -Category All -ErrorAction SilentlyContinue
}
Catch {
}

# Add Launch binding
Try {
  Set-PSRunPSReadLineKeyHandler -InvokePsRunChord 'Ctrl+j'

  # History Search binding
  Set-PSRunPSReadLineKeyHandler -PSReadLineHistoryChord 'Ctrl+r'

  # Set Code as default editor
  Set-PSRunDefaultEditorScript -ScriptBlock { param ($path) & code $path }
}
Catch {
}

# Set favorite directories
$FavoriteDirs = @(
  "C:\src\azure-terraform",
  "C:\src\azure-scripts",
  "C:\src\terraform-utility-scripts",
  "C:\SysadminTools"
)

$FavoriteDirs | ForEach-Object {
  Add-PSRunFavoriteFolder -Path $_
}
Write-Host -ForegroundColor Green "done"

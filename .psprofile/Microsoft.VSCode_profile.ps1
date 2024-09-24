#region VSCode
# Load Editor Services if VSCode
if ($Host.Name -match "Visual Studio Code" -and $PSCore) {
    Write-Host "Loading VSCode Profile"

    # Create Profile Temp Dirs
    Try {
      if (!(Get-Module -Name EditorServicesCommandSuite -ListAvailable)) {
        Install-Module EditorServicesCommandSuite -AllowPrerelease -Scope CurrentUser
      }
        
      Import-Module EditorServicesCommandSuite -ErrorAction SilentlyContinue
      Import-EditorCommand (Get-Command -Module EditorServicesCommandSuite)
      Write-Host -ForegroundColor Yellow "Press: 'Shift + Alt + S' to show editor services commands"
      Try {
        Import-Module "Terminal-Icons" -Force -ErrorAction SilentlyContinue
        Import-Module "PSReadLine" -Force -ErrorAction SilentlyContinue
      }
      Catch {
      }
      
      Try {
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin -PredictionViewStyle ListView -ErrorAction SilentlyContinue
        Initialize-OhMyPosh -ErrorAction SilentlyContinue
      }
      Catch {
      }
    }
    Catch {
      Write-Warning "Failed to Import Editor Services Commands"
    }
    Exit
  }
  #endregion
#region VSCode
# Load Editor Services if VSCode
if ($Host.Name -match "Visual Studio Code" -and $PSCore -or $ENV:TERM_PROGRAM -match "vscode") {
  Write-Host "Loading VSCode Profile"

  #Define RunDir
  $RunDir = Split-Path -Parent $MyInvocation.MyCommand.Definition


  #Define Path of Cred storage file
  $CredPath = "$RunDir\Cred.csv"

  #region LoadCreds
  #Check if cred storage exists and generate cred object or warn it doesn't exist
  if ((Test-Path $CredPath)) {
  
    [array]$CredCSV = Import-Csv -Path $CredPath
    Write-Host -ForegroundColor Green "Credential Objects Loaded: " -NoNewline
    ForEach ($CredObject in $CredCSV) {
      $SecurePassword = $CredObject.Password | ConvertTo-SecureString
      $TempCred = New-Object System.Management.Automation.PSCredential(
        $CredObject.Username,
        $SecurePassword
      )
      $null = Set-Variable -Name $CredObject.VarName -Value $TempCred -Scope Global
      Write-Host -ForegroundColor Cyan "$($CredObject.VarName) " -NoNewline
    }
    Write-Host " OK ✅"
  } else {
    Write-Host -ForegroundColor Yellow "No Cred Object : Run CacheCred.ps1 to store credential objects ⚠️"
  }
  #endregion

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
    } Catch {
    }
      
    Try {
      Set-PSReadLineOption -PredictionSource HistoryAndPlugin -PredictionViewStyle ListView -ErrorAction SilentlyContinue
      Initialize-OhMyPosh -ErrorAction SilentlyContinue
    } Catch {
    }
  } Catch {
    Write-Warning "Failed to Import Editor Services Commands"
  }
  Exit
}
#endregion
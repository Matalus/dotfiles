#TODO fix profile patching

if($Host.Name -match "vim"){
   Exit
}

#Define RunDir
$RunDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Force Load PowerShell-Yaml
$PowerShellYaml = Get-Module -Name "PowerShell-Yaml" -ListAvailable -ErrorAction SilentlyContinue
if (!($PowerShellYaml)) {
   Install-Module -Name PowerShell-Yaml -Force
   Import-Module PowerShell-Yaml -Force -ErrorAction SilentlyContinue
}

# Load Defaults
$ProjectRoot = Split-Path -Parent (Get-Item $RunDir | Select-Object -ExpandProperty LinkTarget)
$Defaults = Get-Content "$ProjectRoot\defaults.yaml" | ConvertFrom-Yaml
$HomeDir = $Defaults.home_dir
#Sets Theme
$CurrentTheme = $Defaults.posh_prompt

$Global:PSCore = if ($PSVersionTable.PSVersion -gt [version]"7.0.0") {
   $true
}
else {
   $false
}

# # Run WinFetch (neofetch)
# winfetch

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
}
else {
   Write-Host -ForegroundColor Yellow "No Cred Object : Run CacheCred.ps1 to store credential objects ⚠️"
}
#endregion

# Workaround for get-location/push-location/pop-location from within a module
# https://github.com/PowerShell/PowerShell/issues/12868
# https://github.com/JanDeDobbeleer/oh-my-posh2/issues/113
$global:OMP_GLOBAL_SESSIONSTATE = $PSCmdlet.SessionState

#region ImportCustom
# Import Custom Function modules
$custom_function_list = Get-ChildItem "$RunDir\custom_modules" -Filter *.psm1 -ErrorAction SilentlyContinue

# Load custom functions
ForEach ($function in $custom_function_list) {
   Try {
      Write-Host "Loading Module: $($function.Name):" -NoNewline
      Import-Module $function.FullName -Force -ErrorAction SilentlyContinue -DisableNameChecking
      Write-Host -ForegroundColor Green " OK ✅"
   }
   Catch {
      Write-Host -ForegroundColor Red " Fail ❌"
   }
}
#endregion

#region ImportModules
# Import Modules
$ModuleConfigPath = "$RunDir\modules.json"
if (Test-Path $ModuleConfigPath) {
   $Modules = (Get-Content $ModuleConfigPath) -join "`n" | ConvertFrom-Json
   
   # Remove PSCore modules if not PSCore
   if (!$PSCore) {
      $Modules = $Modules | Where-Object {
         $_.PSCore -ne $true
      }
   }
   
   $module_len = ($Modules | ForEach-Object {$_.Name.Length} | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum) + 20
   
   ForEach ($module in $modules) {
      Write-Host "Loading Module: $($module.Name)".PadRight(100).Substring(0,$module_len) -NoNewline
      Write-Host "| $($module.MinVer) ".PadRight(100).Substring(0,20) -NoNewline
      $getModuleSplat = @{
         ListAvailable      = $true
         FullyQualifiedName = @{ModuleName = "$($module.Name)"; ModuleVersion = "$($module.MinVer)" }
         ErrorAction        = 'SilentlyContinue'
      }

      if (!(Get-Module @getModuleSplat)) {
         Write-Host "`nInstalling Module: $($module.Name)".PadRight(100).Substring(0,$module_len) -NoNewline
         Write-Host " | $($module.MinVer) ".PadRight(100).Substring(0,21) -NoNewline
         $installModuleSplat = @{
            Name           = $module.Name
            MinimumVersion = $module.MinVer
            Force          = $true
            ErrorAction    = "SilentlyContinue"
         }
         if ($PSCore) {
            $installModuleSplat.Add("AllowPreRelease", $true)
         }

         Try {
            Install-Module @installModuleSplat
         }
         Catch {
            $installModuleSplat.Remove("MinimumVersion")
            Install-Module @installModuleSplat
         }
      }
      $getModuleSplat = @{
         FullyQualifiedName = @{ModuleName = "$($module.Name)"; ModuleVersion = "$($module.MinVer)" }
         ErrorAction        = 'SilentlyContinue'
      }

      $CheckLoaded = Get-Module @getModuleSplat
      if (!$CheckLoaded) {
         $importModuleSplat = @{
            MinimumVersion = $module.MinVer
            Name           = $module.Name
            ErrorAction    = "SilentlyContinue"
         }
         Remove-Module $module.Name -Force -ErrorAction SilentlyContinue
         Try {
            Import-Module @importModuleSplat
         }
         Catch {
            $importModuleSplat.Remove("MinimumVersion")
            Import-Module @importModuleSplat
         }
         Write-Host -ForegroundColor Cyan " loading 🔄"
      }
      else {
         Write-Host -ForegroundColor Green " loaded. ✅"
      }
   }
}
else {
   Write-Host -ForegroundColor Red "Unable to find $ModuleConfigPath ❌"
}
#endregion

Try {
   Invoke-Expression "$(oh-my-posh prompt init pwsh)" -ErrorAction SilentlyContinue
}
Catch {}
Try {
   Set-PoshPrompt -Theme $CurrentTheme -ErrorAction SilentlyContinue
}
Catch {}

#region PSReadLine
# Set PSReadLine Options and Macros
if ($PSCore) {
   & "$RunDir\PSReadLine.ps1"
}
else {
   Write-Host -ForegroundColor Yellow "PS Version lower than 6.0.x, disabling advanced PSReadline Key Handlers"
   $forEachObjectSplat = @{
      Process = { Try { Remove-PSReadLineKeyHandler -Chord $_.Key -ErrorAction Continue }Catch {} }
   }
   Try {
      $null = Get-PSReadLineKeyHandler  | Where-Object { $_.Function -like "*OhMyPosh*" } | Tee-Object -Variable "OhMyPoshKeys" 
   
      $OhMyPoshKeys | ForEach-Object @forEachObjectSplat
      Set-PSReadLineOption -EditMode Vi
   }
   Catch {}
}
#endregion
#region Zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })
#endregion

#region VSCode
# Load Editor Services if VSCode
if ($Host.Name -match "Visual Studio Code" -and $PSCore) {
   Try {
      if (!(Get-Module -Name EditorServicesCommandSuite -ListAvailable)) {
         Install-Module EditorServicesCommandSuite -AllowPrerelease
      }
      
      Import-Module EditorServicesCommandSuite
      Import-EditorCommand (Get-Command -Module EditorServicesCommandSuite)
      Write-Host -ForegroundColor Yellow "Press: 'Shift + Alt + S' to show editor services commands"

   }
   Catch {
      Write-Warning "Failed to Import Editor Services Commands"
   }
}
#endregion


#region PSRun
if ($PSCore) {
   & "$RunDir\PSRun.ps1"
}

#region azcli
# for Az CLI Tab completion and preferences
& "$RunDir\Az.ps1"
#endregion

# Set Dir
Set-Location $HomeDir



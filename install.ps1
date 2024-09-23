<#
.SYNOPSIS
Setup Terminal Profile with dot source github repo

.DESCRIPTION
- Installs `Windows Terminal`, `Neovim`, `Git`, `PowerShell 7` as well as other packages using the scoop package manager
- Deploys Custom Profile
- Deploys Custom Profile Script

.AUTHOR
Matalus : https://github.com/Matalus
.
#>

# Get Working Dir
$ProfileDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Force Load PowerShell-Yaml
$PowerShellYaml = Get-Module -Name "PowerShell-Yaml" -ListAvailable -ErrorAction SilentlyContinue
if (!($PowerShellYaml))
{
  Install-Module -Name PowerShell-Yaml -Force
  Import-Module PowerShell-Yaml -Force -ErrorAction SilentlyContinue
}

# Force Load Profile functions
Write-Host -ForegroundColor White "Loading Profile Functions:" -NoNewline
Try
{
  Import-Module "$ProfileDir\profile_functions.psm1" -Force -ErrorAction SilentlyContinue
  Write-Host -ForegroundColor Green " OK ✅"
} Catch
{
  Write-Host -ForegroundColor Red " Fail ❌"
}

# Make sure PowerShell is up to date
Update-PowerShellCore

# Cleanup PS Module version of oh-my-posh
Get-Module oh-my-posh -ListAvailable -ErrorAction SilentlyContinue | Uninstall-Module -Force -Verbose

# Load Profile Defaults
$Defaults = Get-Content $ProfileDir\defaults.yaml | ConvertFrom-Yaml
#"DEFAULTS"; $Defaults # DEBUG
Write-Host "Defaults Loaded"
$Defaults

# Get PowerShell Info from custom function
$Global:PSInfo = Get-PSInfo
# Check if Admin, throw error it not
if (!($PSInfo.is_admin))
{
  throw "Stopping: you must run 'install.ps1' as Administrator"
}


# Get PowerShell Temp Profiles
$TempProfile = Get-PSProfile
# temp globals for Symlinks
$env:PSWIN_PROFILE_DIR = $TempProfile.PS5Profile
$env:PSCORE_PROFILE_DIR = $TempProfile.PS7Profile
# temp profile root
$env:TERMINAL_PROFILE_ROOT = $ProfileDir
# Terminal Profile Static Variables
$TERM_PROFILE_ENV_VARS = @{
  "PSWIN_PROFILE_DIR"             = $TempProfile.PS5Profile
  "PSCORE_PROFILE_DIR"            = $TempProfile.PS7Profile
  "TERMINAL_PROFILE_ROOT"         = $ProfileDir
  "TERMINAL_PROFILE_HOME"         = $Defaults.home_dir
  "TERMINAL_DEFAULT_PROFILE_GUID" = $Defaults.posh_prompt
}
Set-ProfileEnvironment -Variables $TERM_PROFILE_ENV_VARS

# Scoop Config Path
$ScoopConfigPath = "$ProfileDir\scoop.yaml"

# Get Scoop Package Status
Get-ScoopPackages -ScoopConfigPath $ScoopConfigPath -PSInfo $Global:PSInfo

# Setup Symlinks
$SymLinkConfigPath = "$ProfileDir\symlinks.yaml"
$SymLinks = Get-Content $SymLinkConfigPath | ConvertFrom-Yaml

ForEach ($Symlink in $SymLinks.Symlinks)
{
  # Check if path exists 
  $SymLinkPath = $ExecutionContext.InvokeCommand.ExpandString($Symlink.target)
  $SymLinkSource = "$ProfileDir\$($Symlink.source)"
  Write-Host "Checking Symlink: $($SymLinkPath):" -ForegroundColor White -NoNewline
  $TestTarget = Test-Path $SymLinkPath

  $create_symlink = $true # default state
  
  if ($TestTarget)
  {
    # check if symlink already exists
    $create_symlink = $false # assume it could exist, verify in next step
    $SymLinkExists = Get-Item $SymLinkPath -ErrorAction SilentlyContinue | Where-Object { 
      $_.Attributes -match "ReparsePoint" } | Where-Object { 
      $_.FullName -eq $SymLinkPath -and $_.Target -eq $SymLinkSource 
    }
    if ($SymLinkExists)
    {
      Write-Host -ForegroundColor Green " OK ✅"
      $create_symlink = $false
    } else
    {
      $create_symlink = $true # plan to create symlink 
      Write-Host -ForegroundColor Yellow " missing ❌"
      $Contents = Get-ChildItem $SymLinkPath -Recurse -Force -ErrorAction SilentlyContinue
      if ($Contents)
      {
        # attempt to rename dir
        $Leaf = Split-Path -Leaf $SymLinkPath
        $Parent = Split-Path -Parent $SymLinkPath
        $BackupPath = "$($Parent)\$($Leaf).$(get-date -Format "yyyyddMM-hhmm").BAK"
        Write-Host -ForegroundColor Yellow "Backing up current directory: $($SymLinkPath) to: $($BackupPath) 💾"
        # Throw error if data can't be moved to avoid
        Move-Item -Path $SymLinkPath -Destination $BackupPath -Verbose -ErrorAction Stop
      } else
      {
        Remove-Item -Path $SymLinkPath -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
      }
    }
  } 
  if ($create_symlink)
  {
    Write-Host -ForegroundColor Yellow " missing ⚠️"
    # Create Missing Symlinks
    Write-Host " ▶️  Creating Symlink: $($SymLinkSource) --> $($SymLinkPath) ..."
    New-Item -ItemType SymbolicLink -Target $SymLinkSource -Path $SymLinkPath -D -Verbose -Force -Confirm:$false
  }
}

# Get WindowsTerminal LocalState paths
[array]$TermPaths = Get-ChildItem "$($env:LOCALAPPDATA)\Packages" -Force | Where-Object {
  $_.Name -match "Microsoft.WindowsTerminal.*" 
} | Get-ChildItem -Recurse -Include "settings.json"

if ($TermPaths)
{
  # Load Default Terminals
  $TerminalSettings = Get-Content "$ProfileDir\terminals.json" | ConvertFrom-Json

  $DefaultProfile = $TerminalSettings | Where-Object { $_.guid -eq $Defaults.default_terminal_guid }
  #"DEFAULT PROFILE"; $DefaultProfile # DEBUG


  ForEach ($TermPath in $TermPaths)
  {
    Try
    {
      $ChangeCount = 0
      $CurrentSettings = Get-Content $TermPath.FullName | ConvertFrom-Json
      Write-Host "Found Settings: $($TermPath.FullName)"

      if ($CurrentSettings.defaultProfile -ne $DefaultProfile.guid)
      {
        write-host -ForegroundColor Cyan "Updating Default Terminal Profile to: $($DefaultProfile.name) : $($DefaultProfile.guid)"
        $CurrentSettings.defaultProfile = $DefaultProfile.guid
        $ChangeCount++
      }
      ForEach ($TermProfile in $TerminalSettings)
      {
        Write-Host "Checking Profile: $($TermProfile.Name) : $($TermProfile.guid):" -NoNewline

        # check font
        $NFString = if ($TermPath.FullName -match "Preview")
        { 
          "$($Defaults.nerd_font),$($Defaults.fallback_font)"
        } else
        {
          $Defaults.nerd_font
        }
        if ($TermProfile.face -and $TermProfile.face.font -ne $NFString)
        {
          $TermProfile.face.font = $NFString
        }
        # check if profile exists in settings.json
        if ($TermProfile.guid -notin $CurrentSettings.profiles.list.guid)
        {
          Write-Host -ForegroundColor Yellow " Patching ⚠️"
          $CurrentSettings.profiles.list += $TermProfile
          $ChangeCount++
        } else
        {
          Write-Host -ForegroundColor Green " OK ✅"
        }
      }
      if ($ChangeCount -ge 1)
      {
        # Backup old settings
        $BackupSettingsPath = $TermPath.FullName -replace "settings.json", "settings.bak.json"
        "Backing up: $($TermPath.FullName) --> settings.bak.json 💾"
        Move-Item -Path $TermPath.FullName -Destination $BackupSettingsPath -Verbose -Force

        # Export Updated Settings file
        $CurrentSettings | ConvertTo-Json -Depth 10 | Set-Content $TermPath.FullName -Verbose
      }
    } Catch
    {
    }
  }
}

# Get Posh Themes
Write-Host "Getting Oh-My-Posh Themes..."
$ThemesDir = "$($ProfileDir)\.omp"
$TestThemePath = Test-Path $ThemesDir
if (!$TestThemePath)
{
  New-Item -ItemType Directory -Path $ThemesDir
}

#Test for git
$PoshThemesGit = "$ThemesDir\.git"
$TestPoshThemesGit = Test-Path $PoshThemesGit
if (!$TestPoshThemesGit)
{
  Invoke-Expression "git clone https://github.com/JanDeDobbeleer/oh-my-posh.git $($ThemesDir)"
  Set-Location $ThemesDir
  $GitInvoke = @(
    "git sparse-checkout init",
    "git sparse-checkout set themes",
    "git pull origin main"
  )
  $GitInvoke | ForEach-Object { Invoke-Expression $_ }
} else
{
  Set-Location $ThemesDir
  Invoke-Expression "git pull"
}
Write-Host "Found: $(Get-ChildItem "$ThemesDir\themes" | Measure-Object | Select-Object -ExpandProperty Count) Themes in: $($ThemesDir)"
# Temp OMP Env Vars
$env:OMP_THEMES_DIR = "$($ThemesDir)\themes"
$env:OMP_NERD_FONT = "$($Defaults.nerd_font)"
$env:OMP_DEFAULT_PROMPT = "$($Defaults.posh_prompt)"

# Oh-My-Posh Environment Variables
$POSH_ENV_VARS = @{
  "OMP_THEMES_DIR"     = "$($ThemesDir)\themes"
  "OMP_NERD_FONT"      = "$($Defaults.nerd_font)"
  "OMP_DEFAULT_PROMPT" = "$($Defaults.posh_prompt)"
}
Set-ProfileEnvironment -Variables $POSH_ENV_VARS

# Set preferred Nerd Font
Try
{
  Set-ConsoleFont -Name $Defaults.nerd_font -Height 17 
} Catch
{
}

# Cleanup PS Module version of oh-my-posh
Get-Module oh-my-posh -ListAvailable | Uninstall-Module -Force -Verbose

Try
{
  #$global:OMP_GLOBAL_SESSIONSTATE = $PSCmdlet.SessionState
  Write-Host "Initializing Oh-My-Posh..."
  Initialize-OhMyPosh
} Catch
{
}

# Create HomeDir in not exist
$HomeDir = $Defaults.home_dir
$TestHomeDir = Test-Path $HomeDir
if(!$TestHomeDir)
{ $null = New-Item -ItemType Directory -Path $HomeDir 
}

# TODO Setup WSL Instances
# make sure env variables are refreshed
# Run PS7 Profile
& $PROFILE.CurrentUserAllHosts

Write-Host -ForegroundColor Yellow @"

====================================================================
|************************ ATTENTION ! *****************************|
|                                                                  |
|   It is Strongly Recommended to Restart your Terminal Session    |
|                                                                  |
| Some Module and Assembly Conflicts may be resolved by Restarting |
|                                                                  |
|************************ ATTENTION ! *****************************|
====================================================================
"@

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
if (!($PowerShellYaml)) {
  Install-Module -Name PowerShell-Yaml -Force
  Import-Module PowerShell-Yaml -Force -ErrorAction SilentlyContinue
}

# Force Load Profile functions
Write-Host -ForegroundColor White "Loading Profile Functions:" -NoNewline
Try {
  Import-Module "$ProfileDir\profile_functions.psm1" -Force -ErrorAction SilentlyContinue
  Write-Host -ForegroundColor Green " OK"
}
Catch {
  Write-Host -ForegroundColor Red " Fail"
}

# Get PowerShell Info from custom function
$Global:PSInfo = Get-PSInfo
# Check if Admin, throw error it not
if (!($PSInfo.is_admin)) {
  throw "Stopping: you must run 'install.ps1' as Administrator"
}

# Scoop Config Path
$ScoopConfigPath = "$ProfileDir\scoop.yaml"

# Get Scoop Package Status
$ScoopStatus = Get-ScoopPackages -ScoopConfigPath $ScoopConfigPath -PSInfo $Global:PSInfo

# Setup Symlinks
# TODO setup symlink handings and move into function
$SymLinkPath = "$ProfileDir\symlinks.yaml"
$SymLinks = Get-Content $SymLinkPath | ConvertFrom-Yaml

ForEach ($Symlink in $SymLinks.Symlinks) {
  # Check if path exists 
  $SymLinkPath = $ExecutionContext.InvokeCommand.ExpandString($Symlink.target)
  Write-Host "Checking Symlink: $($SymLinkPath):" -ForegroundColor White -NoNewline
  $TestTarget = Test-Path $SymLinkPath
  
  if ($TestTarget) {
    # check if symlink already exists
    $SymLinkExists = Get-Item $SymLinkPath -ErrorAction SilentlyContinue | Where-Object { $_.Attributes -match "ReparsePoint" } 
  | Where-Object { $_.FullName -eq $SymLinkPath -and $_.Target -eq $Symlink.Source }
    if ($SymLinkExists) {
      Write-Host -ForegroundColor Green " OK"
    }
    else {
      Write-Host -ForegroundColor Yellow " missing"
      $Contents = Get-ChildItem $SymLinkPath -Recurse -Force -ErrorAction SilentlyContinue
      if ($Contents) {
        # attempt to rename dir
        $Leaf = Split-Path -Leaf $SymLinkPath
        $Parent = Split-Path -Parent $SymLinkPath
        $BackupPath = "$($Parent)\$($Leaf).$(get-date -Format "yyyyddMM-hhmm").BAK"
        Write-Host -ForegroundColor Yellow "Backuping up current directory: $($SymLinkPath) to: $($BackupPath)"
        # Throw error if data can't be moved to avoid
        Move-Item -Path $SymLinkPath -Destination $BackupPath -Verbose -ErrorAction Stop
      }
      # Create Missing Symlinks
      Write-Host "Creating Symlink: $($Symlink.Source) --> $($SymLinkPath) ..."
      New-Item -ItemType SymbolicLink -Target $Symlink.Source -Path $SymLinkPath -Verbose
    }
  }
}  

# TODO Windows Terminal Settings Config

# TODO Setup PS 5.1 shim profile

# TODO oh-my-posh configuration

# Load oh-my-posh
Import-Module oh-my-posh -Force
Set-PoshPrompt -Theme "half-life"
# Load Terminal Icons
Import-Module Terminal-Icons -Force
# Perform basic PSReadline config
Import-Module PSReadLine -Force
Set-PSreadLineOption -PredictionViewStyle ListView -PredictionSource HistoryAndPlugin


# TODO Setup WSL Instances
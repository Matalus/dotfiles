# Colletion of profile functions

# Function to check is PowerShell is running as Admin
function Get-PSInfo {
  $PSAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent(
    )).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
  )
  $PSCore = if ($PSVersionTable.PSVersion -gt [version]"7.0.0") {
    $true
  }
  else {
    $false
  }
  $PSHost = $Host.Name
  # return info object
  $PSInfoObject = [PSCustomObject]@{
    is_admin = $PSAdmin
    ps_core  = $PSCore
    ps_host  = $PSHost
  }
  return $PSInfoObject
}

# Install Scoop
function Install-Scoop ($PSInfo) {
  Write-Host "Installing Scoop..."
  if ($PSInfo.PSAdmin) {
    # Run scoop admin install
    Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin"
  }
  else {
    # Install scoop in regular mode
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression 
  }
}

# Return status of scoop packages
function Get-ScoopPackages ($ScoopConfigPath,$PSInfo) {
  # Confirm that Scoop is installed
  Write-Host "Scoop Installed:" -NoNewline
  $TestScoop = Try { Get-Command -Name "scoop.cmd" -ErrorAction SilentlyContinue }Catch {
    $false
  }

  # Attempt to Install Scoop if not installed
  if (!($TestScoop)) {
    Write-Host -ForegroundColor Red " Not Installed"
    Write-Host -ForegroundColor Cyan "Attempting to Install Scoop..."
    Install-Scoop
  }else{
    Write-Host -ForegroundColor Green " OK"
  }

    # Load Scoop Config
    $ScoopConfig = ( Get-Content $ScoopConfigPath ) -join "`n" | ConvertFrom-Yaml

  # Get Required Scoop Apps
  $ScoopAppsRequired = $ScoopConfig.Apps

  # Get Required Buckets from config paths
  $ScoopBucketsRequired = $ScoopAppsRequired | Where-Object {
    $_ -match "/"
  } | ForEach-Object { 
    $_ -split "/" | Select-Object -Index 0 
  } | Select-Object -Unique

  Write-Host "Verifying Scoop Buckets..."
  # Get Installed Scoop Buckets
  [array]$ScoopBuckets = Invoke-Expression "scoop bucket list" 6>$null


    # check for installed buckets and add missing
    ForEach($Bucket in $ScoopBucketsRequired){
      Write-Host -ForegroundColor White "-> $($Bucket):" -NoNewline
      if($Bucket -notin $ScoopBuckets.Name){
        Write-Host -ForegroundColor Yellow " missing"
        Invoke-Expression "scoop bucket add $($Bucket)"
      }else{
        Write-Host -ForegroundColor Green " OK"
      }
    }

  Write-Host "Verifying Scoop Apps..."
  # Get List of Installed Scoop Apps
  [array]$ScoopApps = $ScoopApps = Invoke-Expression "scoop list" 6>$null | ForEach-Object { 
    "$($_.Source)/$($_.Name)" 
  }

  # check for Installed apps and add missing
  ForEach($App in $ScoopAppsRequired){
    Write-Host "-> $($App):" -NoNewLine
    if($App -notin $ScoopApps){
      Write-Host -ForegroundColor Yellow "missing"
      Invoke-Expression "scoop install $($App)"
    }else{
      Write-Host -ForegroundColor Green " OK"
    }
  }
}

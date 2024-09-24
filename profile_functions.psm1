# Collection of profile functions

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
  Write-Host "Installing Scoop " -NoNewline
  if ($PSInfo.is_admin) {
    Write-Host "As Admin..."
    # Run scoop admin install
    Try {
      iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
    }
    Catch {
      # Install scoop in regular mode
      Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
      Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression 
    }
  }
  else {
    Write-Host "As CurrentUser..."
    # Install scoop in regular mode
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression 
  }
}

# Return status of scoop packages
function Get-ScoopPackages ($ScoopConfigPath, $PSInfo) {
  # Confirm that Scoop is installed
  Write-Host "Scoop Installed:" -NoNewline
  $TestScoop = Try { Get-Command -Name "scoop.cmd" -ErrorAction SilentlyContinue }Catch {
    $false
  }

  # Attempt to Install Scoop if not installed
  if (!($TestScoop)) {
    Write-Host -ForegroundColor Red " Not Installed"
    Write-Host -ForegroundColor Cyan "Attempting to Install Scoop..."
    Install-Scoop -PSInfo $PSInfo
  }
  else {
    Write-Host -ForegroundColor Green " OK ✅"
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

  $padvalue = ($ScoopAppsRequired | ForEach-Object { $_.Length } | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum) + 3
  # check for installed buckets and add missing
  ForEach ($Bucket in $ScoopBucketsRequired) {
    Write-Host -ForegroundColor White "-> $($Bucket):".PadRight(100).Substring(0, $padvalue) -NoNewline
    if ($Bucket -notin $ScoopBuckets.Name) {
      Write-Host -ForegroundColor Yellow " missing ⚠️"
      Invoke-Expression "scoop bucket add $($Bucket)"
    }
    else {
      Write-Host -ForegroundColor Green " OK ✅"
    }
  }

  Write-Host "Verifying Scoop Apps..."
  # Get List of Installed Scoop Apps
  [array]$ScoopApps = $ScoopApps = Invoke-Expression "scoop list" 6>$null | ForEach-Object { 
    "$($_.Source)/$($_.Name)" 
  }

  # check for Installed apps and add missing
  ForEach ($App in $ScoopAppsRequired) {
    Write-Host "-> $($App):".PadRight(100).Substring(0, $padvalue) -NoNewLine
    if ($App -notin $ScoopApps) {
      Write-Host -ForegroundColor Yellow "missing "
      Invoke-Expression "scoop install $($App)"
    }
    else {
      Write-Host -ForegroundColor Green " OK ✅"
    }
  }
}

if (-not ("Windows.Native.Kernel32" -as [type])) {
  Add-Type -TypeDefinition @"
    namespace Windows.Native
    {
      using System;
      using System.ComponentModel;
      using System.IO;
      using System.Runtime.InteropServices;
      
      public class Kernel32
      {
        // Constants
        ////////////////////////////////////////////////////////////////////////////
        public const uint FILE_SHARE_READ = 1;
        public const uint FILE_SHARE_WRITE = 2;
        public const uint GENERIC_READ = 0x80000000;
        public const uint GENERIC_WRITE = 0x40000000;
        public static readonly IntPtr INVALID_HANDLE_VALUE = new IntPtr(-1);
        public const int STD_ERROR_HANDLE = -12;
        public const int STD_INPUT_HANDLE = -10;
        public const int STD_OUTPUT_HANDLE = -11;

        // Structs
        ////////////////////////////////////////////////////////////////////////////
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public class CONSOLE_FONT_INFOEX
        {
          private int cbSize;
          public CONSOLE_FONT_INFOEX()
          {
            this.cbSize = Marshal.SizeOf(typeof(CONSOLE_FONT_INFOEX));
          }

          public int FontIndex;
          public short FontWidth;
          public short FontHeight;
          public int FontFamily;
          public int FontWeight;
          [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
          public string FaceName;
        }

        public class Handles
        {
          public static readonly IntPtr StdIn = GetStdHandle(STD_INPUT_HANDLE);
          public static readonly IntPtr StdOut = GetStdHandle(STD_OUTPUT_HANDLE);
          public static readonly IntPtr StdErr = GetStdHandle(STD_ERROR_HANDLE);
        }
        
        // P/Invoke function imports
        ////////////////////////////////////////////////////////////////////////////
        [DllImport("kernel32.dll", SetLastError=true)]
        public static extern bool CloseHandle(IntPtr hHandle);
        
        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        public static extern IntPtr CreateFile
          (
          [MarshalAs(UnmanagedType.LPTStr)] string filename,
          uint access,
          uint share,
          IntPtr securityAttributes, // optional SECURITY_ATTRIBUTES struct or IntPtr.Zero
          [MarshalAs(UnmanagedType.U4)] FileMode creationDisposition,
          uint flagsAndAttributes,
          IntPtr templateFile
          );
          
        [DllImport("kernel32.dll", CharSet=CharSet.Unicode, SetLastError=true)]
        public static extern bool GetCurrentConsoleFontEx
          (
          IntPtr hConsoleOutput, 
          bool bMaximumWindow, 
          // the [In, Out] decorator is VERY important!
          [In, Out] CONSOLE_FONT_INFOEX lpConsoleCurrentFont
          );
          
        [DllImport("kernel32.dll", SetLastError=true)]
        public static extern IntPtr GetStdHandle(int nStdHandle);
        
        [DllImport("kernel32.dll", SetLastError=true)]
        public static extern bool SetCurrentConsoleFontEx
          (
          IntPtr ConsoleOutput, 
          bool MaximumWindow,
          // Again, the [In, Out] decorator is VERY important!
          [In, Out] CONSOLE_FONT_INFOEX ConsoleCurrentFontEx
          );
        
        
        // Wrapper functions
        ////////////////////////////////////////////////////////////////////////////
        public static IntPtr CreateFile(string fileName, uint fileAccess, 
          uint fileShare, FileMode creationDisposition)
        {
          IntPtr hFile = CreateFile(fileName, fileAccess, fileShare, IntPtr.Zero, 
            creationDisposition, 0U, IntPtr.Zero);
          if (hFile == INVALID_HANDLE_VALUE)
          {
            throw new Win32Exception();
          }

          return hFile;
        }

        public static CONSOLE_FONT_INFOEX GetCurrentConsoleFontEx()
        {
          IntPtr hFile = IntPtr.Zero;
          try
          {
            hFile = CreateFile("CONOUT$", GENERIC_READ,
            FILE_SHARE_READ | FILE_SHARE_WRITE, FileMode.Open);
            return GetCurrentConsoleFontEx(hFile);
          }
          finally
          {
            CloseHandle(hFile);
          }
        }

        public static void SetCurrentConsoleFontEx(CONSOLE_FONT_INFOEX cfi)
        {
          IntPtr hFile = IntPtr.Zero;
          try
          {
            hFile = CreateFile("CONOUT$", GENERIC_READ | GENERIC_WRITE,
              FILE_SHARE_READ | FILE_SHARE_WRITE, FileMode.Open);
            SetCurrentConsoleFontEx(hFile, false, cfi);
          }
          finally
          {
            CloseHandle(hFile);
          }
        }

        public static CONSOLE_FONT_INFOEX GetCurrentConsoleFontEx
          (
          IntPtr outputHandle
          )
        {
          CONSOLE_FONT_INFOEX cfi = new CONSOLE_FONT_INFOEX();
          if (!GetCurrentConsoleFontEx(outputHandle, false, cfi))
          {
            throw new Win32Exception();
          }

          return cfi;
        }
      }
    }
"@
}


function Set-ConsoleFont {
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string] $Name,
    [Parameter(Mandatory = $true, Position = 1)]
    [ValidateRange(5, 72)]
    [int] $Height
  )
  
  $cfi = [Windows.Native.Kernel32]::GetCurrentConsoleFontEx()
  $cfi.FontIndex = 0
  $cfi.FontFamily = 0
  $cfi.FaceName = $Name
  $cfi.FontWidth = [int]($Height / 2)
  $cfi.FontHeight = $Height
  [Windows.Native.Kernel32]::SetCurrentConsoleFontEx($cfi)
}

# Get PS Profile Paths
function Get-PSProfile {
  return [pscustomobject]@{
    PS7Profile = & "pwsh.exe" -NoProfile -Command '$PROFILE.CurrentUserAllHosts' | ForEach-Object { split-path -Parent $_ } ;
    PS5Profile = & "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command '$PROFILE.CurrentUserAllHosts' | ForEach-Object { split-path -Parent $_ } ;
  }
}

function Invoke-NativeCommand ($Cmd, $ProcArgs, $WorkDir) {
  # Create Process Info Object
  $proc_info = [System.Diagnostics.ProcessStartInfo]::new()
  $proc_info.FileName = $Cmd
  $proc_info.WorkingDirectory = $WorkDir
  $proc_info.Arguments = $ProcArgs
  $proc_info.RedirectStandardError = $true
  $proc_info.RedirectStandardOutput = $true
  $proc_info.UseShellExecute = $false
  # Run Process
  Try {
    $proc = [System.Diagnostics.Process]::new()
    $proc.StartInfo = $proc_info
    $proc.Start() | Out-Null
    $proc.WaitForExit()
    $proc_out = $proc.StandardOutput.ReadToEnd()
    $proc_err = $proc.StandardError.ReadToEnd()
    [timespan]$RunTime = $proc.ExitTime - $proc.StartTime
    $proc.Dispose()
  }
  Catch {
    $proc.Dispose()
  }
  return [pscustomobject]@{
    output  = $proc_out
    error   = $proc_err
    runtime = $RunTime
  }
}

function Get-ProfileUpdates ($Dir) {
  $remoteurl = Invoke-NativeCommand -Cmd "git.exe" -ProcArgs "remote -v" -WorkDir $Dir
  $remote_fetch = $remoteurl.output -split "`n" | Select-Object -First 1
  Write-Host -ForegroundColor White "Checking for Updates on: " -NoNewline
  Write-Host -ForegroundColor Cyan $remote_fetch
  $fetch = Invoke-NativeCommand -Cmd 'git.exe' -ProcArgs "fetch" -WorkDir $Dir
  
  $local = Invoke-NativeCommand -Cmd 'git.exe' -ProcArgs 'rev-parse HEAD' -WorkDir $Dir
  $remote = Invoke-NativeCommand -Cmd 'git.exe' -ProcArgs 'rev-parse origin/main' -WorkDir $Dir
  $remote_last = Invoke-NativeCommand -Cmd 'git.exe' -ProcArgs "log origin/main -n 1" -WorkDir $Dir

  $update_string = "[local: $($local.output.Substring(0,7)) remote: $($remote.output.Substring(0,7))]"

  if ($local.output -ne $remote.output) {
    Write-Host -ForegroundColor Yellow "Pending Updates $($update_string) ⚠️"
    Write-Host @"
-----------------------------------
$($remote_last.output)
-----------------------------------
"@
    Write-Host -ForegroundColor White "Run " -NoNewline
    Write-Host -ForegroundColor Yellow "Install-ProfileUpdates " -NoNewline
    Write-Host -ForegroundColor White "to update your profile.`r"
  }
  else {
    Write-Host -ForegroundColor Green "No Updates $($update_string)  ✅"
  }
}

function Install-ProfileUpdates {
  Set-Location $env:TERMINAL_PROFILE_ROOT
  Write-Host -ForegroundColor Cyan "Installing Updates"
  Write-Host -ForegroundColor Cyan "Pulling Source Code..."
  $GitInvokes = @(
    "git fetch --all",
    "git pull"
  )
  $GitInvokes | ForEach-Object { Invoke-Expression $_ }
  Write-Host -ForegroundColor Cyan "Reinitializing..."
  Invoke-Expression "$($env:TERMINAL_PROFILE_ROOT)\install.ps1"
}

# TODO set env variables
function Set-ProfileEnvironment ([hashtable]$Variables) {
  $NameLen = $Variables.GetEnumerator() | ForEach-Object {
    $($_.Name.Length) 
  } | Sort-Object -Descending | Select-Object -First 1
  $ValLen = $Variables.GetEnumerator() | ForEach-Object {
    $($_.Value.Length) 
  } | Sort-Object -Descending | Select-Object -First 1

  
  ForEach ($Variable in $Variables.GetEnumerator()) {
    Write-Host -ForegroundColor White "Setting Environment Variable: " -NoNewline
    Write-Host -ForegroundColor Magenta "$($Variable.Name)".PadRight(100).Substring(0, ($NameLen + 2)) -NoNewline
    Write-Host "= $($Variable.Value): ".PadRight(200).Substring(0, ($ValLen + 2)) -NoNewline
    # Set Environment Variable
    [System.Environment]::SetEnvironmentVariable($Variable.Name, $Variable.Value, "Machine")
    Write-Host -ForegroundColor Green " done ✅"
  }
}
# required workaround for occasionally missing function during profile reloads
function Get-PoshStackCount { (Get-Location -Stack).Count }

# init oh my posh
function Initialize-OhMyPosh {
  if(!$env:OMP_DEFAULT_PROMPT){
    $env:OMP_DEFAULT_PROMPT = [System.Environment]::GetEnvironmentVariable("OMP_DEFAULT_PROMPT","Machine")
  }
  if(!$env:OMP_THEMES_DIR){
    $env:OMP_THEMES_DIR = [System.Environment]::GetEnvironmentVariable("OMP_THEMES_DIR","Machine")
  }
  
  $PoshTheme = Get-ChildItem $env:OMP_THEMES_DIR -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -match "$($env:OMP_DEFAULT_PROMPT)\." | Select-Object -First 1
  }
  Try {
    Write-Host -ForegroundColor Cyan "Applying PoshTheme: $($PoshTheme.Name.Replace('.omp.json',''))" -NoNewline
    $null = oh-my-posh init pwsh --config $PoshTheme.FullName | Invoke-Expression -ErrorAction SilentlyContinue
    Write-Host " ✅"
  }
  Catch {
    Write-Host -ForegroundColor Yellow "No PoshTheme found matching: [ $($env:OMP_DEFAULT_PROMPT) ]"
    $null = oh-my-posh init pwsh | Invoke-Expression
  }
}

function Update-PowerShellCore {
  $UpdateCheck = [pscustomobject]@{
    Current = [version]$PSVersionTable.PSVersion | Select-Object Major, Minor, Build;
    Latest  = [version](Invoke-RestMethod -Uri "https://aka.ms/pwsh-buildinfo-stable" | Select-Object -ExpandProperty  ReleaseTag | % { $_ -replace "v" }) | Select-Object Major, Minor, Build
  }
  $CurrentSemantic = ($UpdateCheck.Current.psobject.properties | ForEach-Object { $_.Value }) -join "."
  $LatestSemantic = ($UpdateCheck.Latest.psobject.properties | ForEach-Object { $_.Value }) -join "."
  $VersionSummary = "[ current: $($CurrentSemantic) latest: $($LatestSemantic) ]"

  $NoUpdate = if (
    $UpdateCheck.Current.Major -eq $UpdateCheck.Latest.Major -and
    $UpdateCheck.Current.Minor -eq $UpdateCheck.Latest.Minor -and
    $UpdateCheck.Current.Build -eq $UpdateCheck.Latest.Build
  ) { $true }else { $false }
  if ($NoUpdate) {
    Write-Host "PowerShell is up to date $VersionSummary"
  }
  else {
    Write-Host "PowerShell needs to be updated $VersionSummary"
    if (!(Get-Command -Name pwsh -ErrorAction SilentlyContinue)) {
      winget install --id Microsoft.PowerShell --exact
    }
    else {
      Write-Host -ForegroundColor White "Run " -NoNewline
      Write-Host -ForegroundColor Yellow "winget install --id Microsoft.PowerShell --exact"
      EXIT
    }
  }
}


Export-ModuleMember *-*

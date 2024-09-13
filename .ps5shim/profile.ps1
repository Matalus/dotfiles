# Shim profile, points to Unified PSCore Profile
$DirContext = $pwd # Get Current Directory to revert to when complete

# Get PS7 Profile Path
$PSCoreProfile = & "pwsh.exe" -NoProfile -Command '$PROFILE.CurrentUserAllHosts'

Set-Location $(split-path -parent $PSCoreProfile)
& $PSCoreProfile # Run PSCore Profile

# Revert to former working directory after unified profile script runs
Set-Location $DirContext
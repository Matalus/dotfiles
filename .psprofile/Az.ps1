Write-Host -ForegroundColor Cyan "Setting: AzCLI Options: " -NoNewline

# Set-AzConfig preferences
$setAzConfigSplat = @{
    EnableLoginByWam             = $false
    LoginExperienceV2            = 'Off'
    DisplayBreakingChangeWarning = $false
    DisplaySurveyMessage         = $false
    EnableDataCollection         = $false
    WarningAction                = "SilentlyContinue"
}
if (Get-Module Az.Accounts) {
    $null = Set-AzConfig @setAzConfigSplat
}

# Az PowerShell Tab Comnpletion
Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    $completion_file = New-TemporaryFile
    $env:ARGCOMPLETE_USE_TEMPFILES = 1
    $env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
    $env:COMP_LINE = $wordToComplete
    $env:COMP_POINT = $cursorPosition
    $env:_ARGCOMPLETE = 1
    $env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
    $env:_ARGCOMPLETE_IFS = "`n"
    $env:_ARGCOMPLETE_SHELL = 'powershell'
    az 2>&1 | Out-Null
    Get-Content $completion_file | Sort-Object | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
    }
    Remove-Item $completion_file, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\ARGCOMPLETE_USE_TEMPFILES, 
    Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS, 
    Env:\_ARGCOMPLETE_SHELL
}
Write-Host -ForegroundColor Green "done"
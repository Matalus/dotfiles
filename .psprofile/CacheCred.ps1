#Export Cred File

$RunDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Path = "$RunDir\Cred.csv"

$VarName = read-host -Prompt "Enter Cred Variable Name"
$UserName = Read-Host -Prompt "Enter username to cache"
$Password = Read-Host -Prompt "Enter Password to cache" -AsSecureString

$CredObject = [pscustomobject]@{
   VarName = $VarName
   Username  = $UserName
   Password = $Password | ConvertFrom-SecureString
}

$TestPath = Test-Path $Path
if($TestPath){
   [array]$CredCSV = import-csv $Path | Where-Object {$_.VarName -ne $VarName}
   $CredCSV += $CredObject
}else{
   $CredCSV = @()
   $CredCSV += $CredObject
}


$CredCSV | Select-Object * | Export-Csv $Path -Force -NoTypeInformation
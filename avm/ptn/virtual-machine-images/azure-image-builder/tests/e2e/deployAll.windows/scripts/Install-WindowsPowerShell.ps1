Write-Verbose '##############################################' -Verbose
Write-Verbose '#   Entering Install-WindowsPowerShell.ps1   #' -Verbose
Write-Verbose '##############################################' -Verbose

$psVersion = '7.4.4'
$ps7Url = "https://github.com/PowerShell/PowerShell/releases/download/v$psVersion/PowerShell-$psVersion-win-x64.zip"
$downloadFolder = (Get-Location).Path
$downloadLoc = Join-Path $downloadFolder (Split-Path $ps7Url -Leaf)

if (-not (Test-Path $downloadLoc)) {
    Write-Verbose "Download to [$downloadLoc]" -Verbose
	(New-Object System.Net.WebClient).DownloadFile($ps7Url, $downloadLoc)
    Unblock-File $downloadLoc
    Write-Verbose 'Downloaded' -Verbose
} else {
    Write-Verbose "Already downloaded to [$downloadLoc]" -Verbose
}

$installLoc = "$env:ProgramFiles\PowerShell\7"

if (-not (Test-Path $installLoc)) {
    Write-Verbose "Install to [$installLoc]" -Verbose
    Expand-Archive -Path $downloadLoc -DestinationPath $installLoc
    Write-Verbose 'Installed' -Verbose
} else {
    Write-Verbose "Already installed in [$installLoc]" -Verbose
}

if ($Env:PATH -notlike "*$installLoc*") {
    Write-Verbose 'Set environment variable' -Verbose
    [Environment]::SetEnvironmentVariable('PATH', $Env:PATH + ";$installLoc", [EnvironmentVariableTarget]::Machine)
    $env:Path += ";$installLoc"
    Write-Verbose 'Environment variable set' -Verbose
} else {
    Write-Verbose 'Environment variable already set' -Verbose
}

Write-Verbose 'Try run PS-Core' -Verbose
pwsh -Command 'Write-Host "Hello from the inside"'

Write-Verbose '#############################################' -Verbose
Write-Verbose '#   Exiting Install-WindowsPowerShell.ps1   #' -Verbose
Write-Verbose '#############################################' -Verbose

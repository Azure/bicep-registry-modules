[CmdletBinding()]
param ()

Function log {
    Param (
        [string]$message,
        [string]$logPath = 'C:\temp\hciHostDeploy-3b.log'
    )
    If (!(Test-Path -Path C:\temp)) {
        New-Item -Path C:\temp -ItemType Directory
    }
    Write-Host $message
    Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [hciHostStage3b] - $message"
}

$ErrorActionPreference = 'Stop'

# Uninstall Routing/RemoteAccess to clean up sysprep corruption
# A reboot is required between uninstall and reinstall
log 'Uninstalling Routing and RemoteAccess to fix sysprep corruption...'
Uninstall-WindowsFeature -Name RemoteAccess -ErrorAction SilentlyContinue
Uninstall-WindowsFeature -Name Routing -ErrorAction SilentlyContinue
log 'Uninstall complete - reboot required before reinstall'
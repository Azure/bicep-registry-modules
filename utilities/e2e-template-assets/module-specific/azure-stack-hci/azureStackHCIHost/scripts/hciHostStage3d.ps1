[CmdletBinding()]
param ()

Function log {
    Param (
        [string]$message,
        [string]$logPath = 'C:\temp\hciHostDeploy-3d.log'
    )
    If (!(Test-Path -Path C:\temp)) {
        New-Item -Path C:\temp -ItemType Directory
    }
    Write-Host $message
    Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [hciHostStage3d] - $message"
}

$ErrorActionPreference = 'Stop'

# Install Routing/RemoteAccess after reboot from uninstall
log 'Installing Routing and RemoteAccess...'
Install-WindowsFeature -Name Routing -IncludeManagementTools
Install-WindowsFeature -Name RemoteAccess -IncludeAllSubFeature -IncludeManagementTools
log 'Install complete'

# Verify module is now available
if (!(Test-Path 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\RemoteAccess\RemoteAccess.psd1')) {
    log 'ERROR: RemoteAccess module still not found after clean reinstall!'
    log 'ERROR: The gallery image may need to be rebuilt'
    Write-Error 'RemoteAccess module not found after reinstall' -ErrorAction Stop
}
log 'RemoteAccess module found - proceeding...'

Import-Module 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\RemoteAccess\RemoteAccess.psd1'

# Fix service dependencies
log 'Setting up RemoteAccess service dependencies...'
Set-Service -Name RemoteAccess -StartupType Automatic -ErrorAction SilentlyContinue
Set-Service -Name RasMan -StartupType Automatic -ErrorAction SilentlyContinue
Set-Service -Name SstpSvc -StartupType Automatic -ErrorAction SilentlyContinue
Start-Service -Name RasMan -ErrorAction SilentlyContinue
Start-Service -Name SstpSvc -ErrorAction SilentlyContinue
Start-Sleep -Seconds 5

Install-RemoteAccess -VpnType RoutingOnly
Set-Service -Name RemoteAccess -StartupType Automatic -PassThru | Start-Service
log 'RRAS configured successfully'

log 'Adding DNS forwarders...'
Import-Module 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\DnsServer\DnsServer.psd1'
Add-DnsServerForwarder -IPAddress 8.8.8.8
log 'DNS forwarders added successfully'
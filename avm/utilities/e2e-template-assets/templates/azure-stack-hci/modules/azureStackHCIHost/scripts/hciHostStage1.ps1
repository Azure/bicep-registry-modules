Function log {
  Param (
    [string]$message,
    [string]$logPath = 'C:\temp\hciHostDeploy.log'
  )

  If (!(Test-Path -Path C:\temp)) {
    New-Item -Path C:\temp -ItemType Directory
  }

  Write-Host $message
  Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [hciHostStage1] - $message"
}

$ErrorActionPreference = 'Stop'

# prep host - install hyper-v, AD, DHCP, RRAS
log 'Installing required features and roles...'
$features = @('rsat-hyper-v-tools', 'rsat-clustering', 'rsat-adds', 'rsat-dns-server', 'RSAT-RemoteAccess-Mgmt', 'Routing', 'AD-Domain-Services', 'DHCP')
$missingFeatures = Get-WindowsFeature -Name $features | Where-Object { $_.Installed -eq $false }

ForEach ($missingFeature in $missingFeatures) {
  log "Installing $($missingFeature.Name)..."
  Add-WindowsFeature -Name $missingFeature.Name -IncludeAllSubFeature -IncludeManagementTools

  If ($?) {
    log "Successfully installed $($missingFeature.Name)"
  } Else {
    log "Failed to install $($missingFeature.Name)"
  }
  If (Test-Path -Path C:\Windows\winsxs\pending.xml) {
    log 'Reboot required, exiting...'
  }
}

log 'Enabling Hyper-V...'
Enable-WindowsOptionalFeature -Online -FeatureName 'microsoft-hyper-v-online' -All -NoRestart

# create temp directory
log 'Creating temp directory...'
If (!(Test-Path -Path C:\temp)) {
  New-Item -Path C:\temp -ItemType Directory
}

# create reboot status file
If (Test-Path -Path 'C:\temp\Reboot1Completed.status') {
  log 'Reboot has already been completed, skipping...'
} ElseIf (Test-Path -Path 'C:\temp\Reboot1Initiated.status') {
  log 'Reboot has already been initiated, skipping...'
} Else {
  log 'Reboot required, creating status file...'
  Set-Content -Path 'C:\temp\Reboot1Required.status' -Value 'Reboot 1 Required'
}

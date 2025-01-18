
Function log {
    Param (
        [string]$message,
        [string]$logPath = 'C:\temp\hciHostDeploy-0.log'
    )

    If (!(Test-Path -Path 'C:\temp')) {
        New-Item -Path 'C:\temp' -ItemType Directory
    }

    Write-Host $message
    Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [hciHostStage6] - $message"
}

$ErrorActionPreference = 'Stop'

If (!(Get-PackageProvider -Name 'NuGet' -ListAvailable -ErrorAction 'SilentlyContinue')) { Install-PackageProvider -Name NuGet -MinimumVersion '2.8.5.201' -Force }
If (!(Get-PSRepository -Name 'PSGallery' -ErrorAction 'SilentlyContinue')) { Register-PSRepository -Default }
Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'
foreach ($module in @(
        'Az.Accounts',
        'Az.Resources',
        'WinInetProxy',
        'AsHciADArtifactsPreCreationTool',
        'AzsHCI.ARCinstaller')) {
    if (-not (Get-Module -Name $module -ListAvailable)) {
        log "Installing module [$module]" -Verbose
        $null = Install-Module -Name $module -Force -AllowClobber -Scope 'CurrentUser' -Repository 'PSGallery' -Confirm:$false
    }
}
Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Untrusted'

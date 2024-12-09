<#
.SYNOPSIS
Run the Post-Deployment for the storage account deployment & upload required data to the storage account.

.DESCRIPTION
Run the Post-Deployment for the storage account deployment & upload required data to the storage account.
Any content that should be uploaded must exist as an environment variable with a 'script_' prefix (for example 'script_Initialize-LinuxSoftware_ps1').
The script will fetch any matching environment variable, store it as a file (for example 'script_Initialize__LinuxSoftware_ps1' is stored as 'Initialize-LinuxSoftware.ps1')
and uploade it as blob to the given container.

.PARAMETER StorageAccountName
Required. The name of the Storage Account to upload to

.PARAMETER TargetContainer
Required. The container to upload the files to

.EXAMPLE
. 'Set-StorageContainerContentByEnvVar.ps1' -StorageAccountName 'mystorage' -TargetContainer 'myContainer'

Upload any required data to the storage account 'mystorage' and container 'myContainer'.
#>

[CmdletBinding(SupportsShouldProcess = $True)]
param(
    [Parameter(Mandatory = $true)]
    [string] $StorageAccountName,

    [Parameter(Mandatory = $true)]
    [string] $TargetContainer
)

Write-Verbose 'Fetching & storing scripts' -Verbose
$contentDirectoryName = 'scripts'
$contentDirectory = (New-Item $contentDirectoryName -ItemType 'Directory' -Force).FullName
$scriptPaths = @()
foreach ($scriptEnvVar in (Get-ChildItem 'env:*').Name | Where-Object { $_ -like '__SCRIPT__*' }) {
    # Handle value like 'script_Initialize__LinuxSoftware_ps1'
    $scriptName = $scriptEnvVar -replace '__SCRIPT__', '' -replace '__', '-' -replace '_', '.'
    $scriptContent = (Get-Item env:$scriptEnvVar).Value

    Write-Verbose ('Storing file [{0}] with length [{1}]' -f $scriptName, $scriptContent.Length) -Verbose
    $scriptPaths += (New-Item (Join-Path $contentDirectoryName $scriptName) -ItemType 'File' -Value $scriptContent -Force).FullName
}

Write-Verbose 'Getting storage account context.' -Verbose
$ctx = New-AzStorageContext -StorageAccountName $storageAccountName -UseConnectedAccount

Write-Verbose 'Building paths to the local folders to upload.' -Verbose
Write-Verbose "Content directory: '$contentDirectory'" -Verbose

foreach ($scriptPath in $scriptPaths) {

    try {
        Write-Verbose 'Testing blob container' -Verbose
        Get-AzStorageContainer -Name $targetContainer -Context $ctx -ErrorAction 'Stop'
        Write-Verbose 'Testing blob container SUCCEEDED' -Verbose

        Write-Verbose ('Uploading file [{0}] to container [{1}]' -f (Split-Path $scriptPath -Leaf), $TargetContainer) -Verbose
        if ($PSCmdlet.ShouldProcess(('File [{0}] to container [{1}]' -f (Split-Path $scriptPath -Leaf), $TargetContainer), 'Upload')) {
            $null = Set-AzStorageBlobContent -File $scriptPath -Container $targetContainer -Context $ctx -Force -ErrorAction 'Stop'
        }
        Write-Verbose 'Upload successful' -Verbose
    } catch {
        throw "Upload FAILED: $_"
    }
}

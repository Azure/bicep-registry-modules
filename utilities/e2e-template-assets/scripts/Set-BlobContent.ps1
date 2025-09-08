<#
.SYNOPSIS
Upload a test file to the given Storage Account Container.

.DESCRIPTION
Upload a test file to the given Storage Account Container.

.PARAMETER StorageAccountName
Mandatory. The name of the Storage Account to upload the file to

.PARAMETER ResourceGroupName
Mandatory. The name of the Resource Group containing the Storage Account to upload the file to

.PARAMETER ContainerName
Mandatory. The name of the Storage Account Container to upload the file to

.PARAMETER FileName
Mandatory. The name of the file of the file to create in the container

.EXAMPLE
./Set-BlobContent.ps1 -StorageAccountName 'mystorage' -ResourceGroupName 'storage-rg' -ContainerName 'mycontainer' -FileName 'testCSE.ps1'

Generate a dummy file 'testCSE.ps1' to the Storage Account 'mystorage' Container 'mycontainer' in Resource Group 'storage-rg'
#>
param(
    [Parameter(Mandatory = $true)]
    [string] $StorageAccountName,

    [Parameter(Mandatory = $true)]
    [string] $ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string] $ContainerName,

    [Parameter(Mandatory = $true)]
    [string] $FileName
)

Write-Verbose "Create file [$FileName]" -Verbose
$file = New-Item -Value "echo 'I am content'" -Path $FileName -Force

Write-Verbose "Getting storage account [$StorageAccountName|$ResourceGroupName] context." -Verbose
$storageAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -StorageAccountName $StorageAccountName -ErrorAction 'Stop'

Write-Verbose 'Uploading file [$fileName]' -Verbose
Set-AzStorageBlobContent -File $file.FullName -Container $ContainerName -Context $storageAccount.Context -Force -ErrorAction 'Stop' | Out-Null

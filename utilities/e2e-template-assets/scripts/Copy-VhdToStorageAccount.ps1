<#
.SYNOPSIS
Copy a VHD baked from a given Image Template to a given destination storage account blob container

.DESCRIPTION
Copy a VHD baked from a given Image Template to a given destination storage account blob container

.PARAMETER ImageTemplateName
Mandatory. The name of the Image Template

.PARAMETER ImageTemplateResourceGroup
Mandatory. The resource group name of the Image Template

.PARAMETER DestinationStorageAccountName
Mandatory. The name of the destination storage account

.PARAMETER DestinationContainerName
Optional. The name of the existing destination blob container

.PARAMETER VhdName
Optional. Specify a different name for the destination VHD file

.PARAMETER WaitForComplete
Optional. Run the command synchronously. Wait for the completion of the copy.

.EXAMPLE
./Copy-VhdToStorageAccount -ImageTemplateName 'vhd-img-template-001-2022-07-29-15-54-01' -ImageTemplateResourceGroup 'validation-rg' -DestinationStorageAccountName 'vhdstorage001'

Copy a VHD created by Image Template 'vhd-img-template-001-2022-07-29-15-54-01' in resource group 'validation-rg' to destination storage account 'vhdstorage001' in blob container named 'vhds'. Save the VHD file as 'vhd-img-template-001-2022-07-29-15-54-01.vhd'.

.EXAMPLE
./Copy-VhdToStorageAccount -ImageTemplateName 'vhd-img-template-001-2022-07-29-15-54-01' -ImageTemplateResourceGroup 'validation-rg' -DestinationStorageAccountName 'vhdstorage001' -VhdName 'vhd-img-template-001' -WaitForComplete

Copy a VHD baked by Image Template 'vhd-img-template-001-2022-07-29-15-54-01' in resource group 'validation-rg' to destination storage account 'vhdstorage001' in a blob container named 'vhds' and wait for the completion of the copy. Save the VHD file as 'vhd-img-template-001.vhd'.
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $true)]
    [string] $ImageTemplateName,

    [Parameter(Mandatory = $true)]
    [string] $ImageTemplateResourceGroup,

    [Parameter(Mandatory = $true)]
    [string] $DestinationStorageAccountName,

    [Parameter(Mandatory = $false)]
    [string] $DestinationContainerName = 'vhds',

    [Parameter(Mandatory = $false)]
    [string] $VhdName = $ImageTemplateName,

    [Parameter(Mandatory = $false)]
    [switch] $WaitForComplete
)

begin {
    Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

    # Install required modules
    $currentVerbosePreference = $VerbosePreference
    $VerbosePreference = 'SilentlyContinue'
    $requiredModules = @(
        @{ Name = 'Az.ImageBuilder'; Version = '0.4.0' },
        @{ Name = 'Az.Storage'; Version = '6.0.0' }
    )
    foreach ($module in $requiredModules) {
        $installationInput = @{
            Name       = $module.Name
            Repository = 'PSGallery'
            Scope      = 'CurrentUser'
            Force      = $true
        }
        if ($Module.Version) {
            $installationInput['RequiredVersion'] = $module.Version
        }
        Install-Module @installationInput

        if ($installed = Get-Module -Name $module.Name -ListAvailable) {
            Write-Verbose ('Installed module [{0}] with version [{1}]' -f $installed.Name, $installed.Version) -Verbose
        }
    }
    $VerbosePreference = $currentVerbosePreference
}

process {
    # Retrieving and initializing parameters before the blob copy
    Write-Verbose 'Initializing source storage account parameters before the blob copy' -Verbose
    Write-Verbose ('Retrieving source storage account from Image Template [{0}] in resource group [{1}]' -f $imageTemplateName, $imageTemplateResourceGroup) -Verbose
    Get-InstalledModule
    $imgtRunOutput = Get-AzImageBuilderTemplateRunOutput -ImageTemplateName $imageTemplateName -ResourceGroupName $imageTemplateResourceGroup | Where-Object ArtifactUri -NE $null
    $sourceUri = $imgtRunOutput.ArtifactUri
    $sourceStorageAccountName = $sourceUri.Split('//')[1].Split('.')[0]
    $storageAccountList = Get-AzStorageAccount
    $sourceStorageAccount = $storageAccountList | Where-Object StorageAccountName -EQ $sourceStorageAccountName
    $sourceStorageAccountContext = $sourceStorageAccount.Context
    $sourceStorageAccountRGName = $sourceStorageAccount.ResourceGroupName
    Write-Verbose ('Retrieving artifact uri [{0}] stored in resource group [{1}]' -f $sourceUri, $sourceStorageAccountRGName) -Verbose

    Write-Verbose 'Initializing destination storage account parameters before the blob copy' -Verbose
    $destinationStorageAccount = $storageAccountList | Where-Object StorageAccountName -EQ $destinationStorageAccountName
    $destinationStorageAccountContext = $destinationStorageAccount.Context
    $destinationBlobName = "$vhdName.vhd"
    Write-Verbose ('Planning for destination blob name [{0}] in container [{1}] and storage account [{2}]' -f $destinationBlobName, $destinationContainerName, $destinationStorageAccountName) -Verbose

    # Copying the VHD to a destination blob container
    $resourceActionInputObject = @{
        AbsoluteUri   = $sourceUri
        Context       = $sourceStorageAccountContext
        DestContext   = $destinationStorageAccountContext
        DestBlob      = $destinationBlobName
        DestContainer = $destinationContainerName
        Force         = $true
    }

    if ($PSCmdlet.ShouldProcess('Storage blob copy of VHD [{0}]' -f $destinationBlobName, 'Start')) {
        $destBlob = Start-AzStorageBlobCopy @resourceActionInputObject
        Write-Verbose ('Copied/initialized copy of VHD from URI [{0}] to container [{1}] in storage account [{2}]' -f $sourceUri, $destinationContainerName, $destinationStorageAccountName) -Verbose
    }

    if ($WaitForComplete) {
        $destBlob | Get-AzStorageBlobCopyState -WaitForComplete
    }
}

end {
    Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
}

<#
.SYNOPSIS
Copy a VHD baked from a given Image Template to a given destination storage account blob container

.DESCRIPTION
Copy a VHD from a successful image build to a destination storage account blob container. Wait up to five minutes for the completed build's VHD output to become available.

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
    $artifactDeadline = (Get-Date).ToUniversalTime().AddMinutes(5)
    $imgtRunOutputs = @()
    while ((Get-Date).ToUniversalTime() -lt $artifactDeadline) {
        $imageTemplates = @(Get-AzImageBuilderTemplate -ImageTemplateName $imageTemplateName -ResourceGroupName $imageTemplateResourceGroup -ErrorAction Stop)
        if ($imageTemplates.Count -ne 1) {
            throw ('Expected exactly one image template [{0}] in resource group [{1}].' -f $imageTemplateName, $imageTemplateResourceGroup)
        }
        $imageTemplate = $imageTemplates[0]
        if ($imageTemplate.LastRunStatusRunState -ne 'Succeeded') {
            throw ('Image build [{0}] has not completed successfully. Last run state [{1}], substate [{2}]: {3}' -f $imageTemplateName, $imageTemplate.LastRunStatusRunState, $imageTemplate.LastRunStatusRunSubState, $imageTemplate.LastRunStatusMessage)
        }
        $imgtRunOutputs = @(Get-AzImageBuilderTemplateRunOutput -ImageTemplateName $imageTemplateName -ResourceGroupName $imageTemplateResourceGroup -ErrorAction Stop | Where-Object {
                -not [string]::IsNullOrWhiteSpace($_.ArtifactUri)
            })
        if ($imgtRunOutputs.Count -gt 0) {
            break
        }
        Write-Verbose ('Waiting for the completed image build [{0}] to expose its VHD output.' -f $imageTemplateName) -Verbose
        Start-Sleep -Seconds 15
    }
    if ($imgtRunOutputs.Count -ne 1) {
        throw ('Expected exactly one VHD artifact URI from image template [{0}] in resource group [{1}], but found [{2}]. Check the image build result.' -f $imageTemplateName, $imageTemplateResourceGroup, $imgtRunOutputs.Count)
    }
    $sourceUri = $imgtRunOutputs[0].ArtifactUri
    [uri] $sourceBlobUri = $null
    if (-not [uri]::TryCreate($sourceUri, [UriKind]::Absolute, [ref] $sourceBlobUri) -or $sourceBlobUri.Scheme -notin @('https', 'http')) {
        throw ('Image template [{0}] returned an invalid VHD artifact URI.' -f $imageTemplateName)
    }
    $sourceStorageAccountName = $sourceBlobUri.Host.Split('.')[0]
    $storageAccountList = @(Get-AzStorageAccount -ErrorAction Stop)
    $sourceStorageAccounts = @($storageAccountList | Where-Object StorageAccountName -EQ $sourceStorageAccountName)
    if ($sourceStorageAccounts.Count -ne 1 -or -not $sourceStorageAccounts[0].Context) {
        throw ('Could not resolve exactly one source storage account [{0}] with a storage context.' -f $sourceStorageAccountName)
    }
    $sourceStorageAccountContext = $sourceStorageAccounts[0].Context
    $sourceStorageAccountRGName = $sourceStorageAccounts[0].ResourceGroupName
    Write-Verbose ('Retrieving artifact uri [{0}] stored in resource group [{1}]' -f $sourceUri, $sourceStorageAccountRGName) -Verbose

    Write-Verbose 'Initializing destination storage account parameters before the blob copy' -Verbose
    $destinationStorageAccounts = @($storageAccountList | Where-Object StorageAccountName -EQ $destinationStorageAccountName)
    if ($destinationStorageAccounts.Count -ne 1 -or -not $destinationStorageAccounts[0].Context) {
        throw ('Could not resolve exactly one destination storage account [{0}] with a storage context.' -f $destinationStorageAccountName)
    }
    $destinationStorageAccountContext = $destinationStorageAccounts[0].Context
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
        ErrorAction   = 'Stop'
    }

    if ($PSCmdlet.ShouldProcess('Storage blob copy of VHD [{0}]' -f $destinationBlobName, 'Start')) {
        $destBlobs = @(Start-AzStorageBlobCopy @resourceActionInputObject)
        if ($destBlobs.Count -ne 1) {
            throw ('Expected exactly one destination blob after starting copy of [{0}].' -f $destinationBlobName)
        }
        Write-Verbose ('Started copy of VHD from URI [{0}] to container [{1}] in storage account [{2}]' -f $sourceUri, $destinationContainerName, $destinationStorageAccountName) -Verbose

        if ($WaitForComplete) {
            $copyStates = @($destBlobs[0] | Get-AzStorageBlobCopyState -WaitForComplete -ErrorAction Stop)
            if ($copyStates.Count -ne 1) {
                throw ('Expected exactly one blob copy status for [{0}].' -f $destinationBlobName)
            }
            if ($copyStates[0].Status -ne 'Success') {
                throw ('VHD copy [{0}] ended in state [{1}]: {2}' -f $destinationBlobName, $copyStates[0].Status, $copyStates[0].StatusDescription)
            }
            Write-Verbose ('Completed copy of VHD [{0}] to container [{1}] in storage account [{2}]' -f $destinationBlobName, $destinationContainerName, $destinationStorageAccountName) -Verbose
            $copyStates[0]
        }
    }
}

end {
    Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
}

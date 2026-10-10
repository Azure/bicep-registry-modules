<#
.SYNOPSIS
Deploys and runs the reusable Azure Stack HCI host image builder.

.DESCRIPTION
Skips an existing successful deterministic image version, resumes an active
image build, or deploys the builder resources and starts a new build. It waits
for the build and gallery version replication to succeed in every required
region. An existing unavailable version is never rebuilt or overwritten.

.PARAMETER Location
Location of the resource group, gallery, image definition, and managed identity.
Azure VM Image Builder also creates the image version in the image definition's region.

.PARAMETER BuildLocation
Location of the image template and build VM. Defaults to Location. Use a new
ImageTemplateName when changing an existing template's immutable location.

.PARAMETER ReplicationRegions
Regions where the image must be available. Defaults to Location. Location and
BuildLocation are always included, with case-insensitive region deduplication.
An existing version must already have completed replication in these regions;
otherwise the caller must wait for or repair replication before retrying.

.EXAMPLE
. .\Invoke-HciHostImageBuild.ps1 -AssetBaseUri 'https://example.test/pinned-assets' -BuildLocation australiaeast -ReplicationRegions australiaeast -ImageTemplateName hci-host-image-builder-australiaeast

Preserves the default Southeast Asia resources, builds in Australia East, and
requires completed replicas in both the image-version source and build regions.

.LINK
https://learn.microsoft.com/azure/virtual-machines/linux/image-builder-json#distribute-sharedimage

.LINK
https://learn.microsoft.com/rest/api/compute/gallery-image-versions/get
#>

[CmdletBinding()]
param (
    [Parameter()]
    [string] $TemplateFile = (Join-Path $PSScriptRoot 'hciHostGalleryBuilder.bicep'),

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [ValidatePattern('\S')]
    [string] $Location = 'southeastasia',

    [Parameter()]
    [string] $ResourceGroupName = 'rg-avm-persistent-hci-image',

    [Parameter()]
    [string] $GalleryName = 'galavmpersistenthci',

    [Parameter()]
    [string] $ImageDefinitionName = 'hci-host-image',

    [Parameter()]
    [ValidatePattern('^\d+\.\d+\.\d+$')]
    [string] $ImageVersion = '26.1.0',

    [Parameter()]
    [string] $ImageTemplateName = 'hci-host-image-builder',

    [Parameter(Mandatory)]
    [ValidatePattern('^https://')]
    [string] $AssetBaseUri,

    [Parameter()]
    [ValidatePattern('^https://')]
    [string] $HciVhdxDownloadUri = 'https://azlocalvhds.blob.core.windows.net/images/AzLocal2601.vhdx',

    [Parameter()]
    [ValidateRange(1, 960)]
    [int] $BuildTimeoutInMinutes = 570,

    [Parameter()]
    [bool] $CreateResourceGroup = $true,

    [Parameter()]
    [string] $SubscriptionId = (Get-AzContext).Subscription.Id,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [ValidatePattern('\S')]
    [string] $BuildLocation = $Location,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [ValidatePattern('\S')]
    [string[]] $ReplicationRegions = @($Location)
)

$ErrorActionPreference = 'Stop'
$imageVersionResourceId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Compute/galleries/$GalleryName/images/$ImageDefinitionName/versions/$ImageVersion"
$imageTemplateResourceId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.VirtualMachineImages/imageTemplates/$ImageTemplateName"
$imageVersionApiVersion = '2024-03-03'
$imageTemplateApiVersion = '2025-10-01'
$requiredReplicationRegions = @(
    @($Location, $BuildLocation) + $ReplicationRegions |
        ForEach-Object { $_.Replace(' ', '').ToLowerInvariant() } |
        Select-Object -Unique
)

function Get-ArmResource {
    param (
        [Parameter(Mandatory)]
        [string] $ResourceId,

        [Parameter(Mandatory)]
        [string] $ApiVersion,

        [Parameter()]
        [string] $Expand
    )

    $path = "$ResourceId`?api-version=$ApiVersion"
    if ($Expand) {
        $path += "&`$expand=$Expand"
    }
    $response = Invoke-AzRestMethod -Method GET -Path $path
    if ([int] $response.StatusCode -eq 404) {
        return $null
    }
    if ([int] $response.StatusCode -notin 200, 201) {
        throw "ARM GET [$ResourceId] returned HTTP [$($response.StatusCode)]. $($response.Content)"
    }
    return $response.Content | ConvertFrom-Json
}

function Get-ImageVersionAvailability {
    param (
        [Parameter()]
        [object] $ImageVersionResource,

        [Parameter(Mandatory)]
        [string[]] $RequiredRegions
    )

    $issues = [System.Collections.Generic.List[string]]::new()
    $canWait = $true
    if ($null -eq $ImageVersionResource) {
        $issues.Add('Version not found.')
    } else {
        $properties = $ImageVersionResource.properties
        $provisioningState = [string] $properties.provisioningState
        if ($provisioningState -ne 'Succeeded') {
            $issues.Add("Provisioning state [$provisioningState].")
            $canWait = $provisioningState -in @('Creating', 'Updating')
        }
        if ($properties.publishingProfile.excludeFromLatest -eq $true) {
            $issues.Add('Version is excluded from latest.')
            $canWait = $false
        }

        foreach ($region in $RequiredRegions) {
            $targets = @($properties.publishingProfile.targetRegions | Where-Object {
                ([string] $_.name).Replace(' ', '').ToLowerInvariant() -eq $region
            })
            if ($targets.Count -ne 1) {
                $issues.Add("Region [$region] is missing or duplicated in publishingProfile.targetRegions.")
                $canWait = $false
                continue
            }

            $replicas = @($properties.replicationStatus.summary | Where-Object {
                ([string] $_.region).Replace(' ', '').ToLowerInvariant() -eq $region
            })
            if ($replicas.Count -ne 1) {
                $issues.Add("Region [$region] has no unambiguous replication status.")
                continue
            }
            if ($replicas[0].state -ne 'Completed') {
                $replicaDetails = if ($replicas[0].PSObject.Properties.Name -contains 'details') { $replicas[0].details } else { '' }
                $issues.Add("Region [$region] replication state [$($replicas[0].state)]. $replicaDetails")
                if ($replicas[0].state -eq 'Failed') {
                    $canWait = $false
                }
            }
        }
    }

    return [pscustomobject] @{
        Ready   = $issues.Count -eq 0
        CanWait = $canWait
        Details = $issues -join ' '
    }
}

if ([string]::IsNullOrWhiteSpace($SubscriptionId)) {
    throw 'SubscriptionId is required when no Azure context is available.'
}

$null = Set-AzContext -SubscriptionId $SubscriptionId
$existingVersion = Get-ArmResource -ResourceId $imageVersionResourceId -ApiVersion $imageVersionApiVersion -Expand 'ReplicationStatus'
if ($null -ne $existingVersion) {
    $availability = Get-ImageVersionAvailability -ImageVersionResource $existingVersion -RequiredRegions $requiredReplicationRegions
    if (-not $availability.Ready) {
        throw "Image version [$imageVersionResourceId] already exists but is unavailable. $($availability.Details) No deployment or build was started. Wait for or repair replication before retrying, or choose a new ImageVersion for a new build."
    }
    return [pscustomobject] @{
        BuildStarted            = $false
        BuildStatus             = 'Skipped'
        ImageVersionResourceId  = $imageVersionResourceId
        ImageTemplateResourceId = $imageTemplateResourceId
        ResourceGroupName       = $ResourceGroupName
    }
}

$activeRunStates = @('New', 'Pending', 'Running')
$templateBeforeDeployment = Get-ArmResource -ResourceId $imageTemplateResourceId -ApiVersion $imageTemplateApiVersion
if ($null -ne $templateBeforeDeployment -and
    ([string] $templateBeforeDeployment.location).Replace(' ', '').ToLowerInvariant() -ne $BuildLocation.Replace(' ', '').ToLowerInvariant()) {
    throw "Image template [$ImageTemplateName] has location [$($templateBeforeDeployment.location)], not BuildLocation [$BuildLocation]. Choose a new ImageTemplateName; existing template locations cannot be changed."
}
$resumeActiveRun = $null -ne $templateBeforeDeployment -and
    [string] $templateBeforeDeployment.properties.lastRunStatus.runState -in $activeRunStates
$previousRunStartTime = [datetimeoffset]::MinValue
$observedRunStartTime = [datetimeoffset]::MinValue
if ($resumeActiveRun) {
    if ($templateBeforeDeployment.properties.lastRunStatus.startTime) {
        $observedRunStartTime = [datetimeoffset] $templateBeforeDeployment.properties.lastRunStatus.startTime
    }
} else {
    $deploymentName = "hci-host-image-$($ImageVersion.Replace('.', '-'))"
    $templateParameters = @{
        assetBaseUri          = $AssetBaseUri
        buildLocation         = $BuildLocation
        buildTimeoutInMinutes = $BuildTimeoutInMinutes
        createResourceGroup   = $CreateResourceGroup
        galleryName           = $GalleryName
        hciVhdxDownloadUri    = $HciVhdxDownloadUri
        imageDefinitionName   = $ImageDefinitionName
        imageTemplateName     = $ImageTemplateName
        imageVersion          = $ImageVersion
        location              = $Location
        replicationRegions    = $ReplicationRegions
        resourceGroupName     = $ResourceGroupName
    }
    $deployment = New-AzSubscriptionDeployment `
        -Name $deploymentName `
        -Location $Location `
        -TemplateFile $TemplateFile `
        -TemplateParameterObject $templateParameters

    if ($deployment.ProvisioningState -ne 'Succeeded') {
        throw "Image builder resource deployment [$deploymentName] finished with state [$($deployment.ProvisioningState)]."
    }

    $templateBeforeRun = Get-ArmResource -ResourceId $imageTemplateResourceId -ApiVersion $imageTemplateApiVersion
    if ($templateBeforeRun.properties.lastRunStatus.startTime) {
        $previousRunStartTime = [datetimeoffset] $templateBeforeRun.properties.lastRunStatus.startTime
    }

    $runResponse = Invoke-AzRestMethod -Method POST -Path "$imageTemplateResourceId/run?api-version=$imageTemplateApiVersion"
    if ([int] $runResponse.StatusCode -notin 200, 201, 202) {
        throw "Starting image build [$ImageTemplateName] returned HTTP [$($runResponse.StatusCode)]. $($runResponse.Content)"
    }
}

$deadline = ([datetimeoffset] (Get-Date)).AddMinutes($BuildTimeoutInMinutes)
do {
    if ([datetimeoffset] (Get-Date) -ge $deadline) {
        throw "Timed out after [$BuildTimeoutInMinutes] minutes waiting for image build [$ImageTemplateName]."
    }

    Start-Sleep -Seconds 15
    $template = Get-ArmResource -ResourceId $imageTemplateResourceId -ApiVersion $imageTemplateApiVersion
    $lastRunStatus = $template.properties.lastRunStatus
    if (-not $lastRunStatus.startTime) {
        continue
    }

    $runStartTime = [datetimeoffset] $lastRunStatus.startTime
    if (-not $resumeActiveRun -and $runStartTime -le $previousRunStartTime) {
        continue
    }
    if ($observedRunStartTime -eq [datetimeoffset]::MinValue) {
        $observedRunStartTime = $runStartTime
    } elseif ($runStartTime -ne $observedRunStartTime) {
        throw "Image template [$ImageTemplateName] run changed while waiting for completion."
    }

    $runState = [string] $lastRunStatus.runState
    if ($runState -eq 'Succeeded') {
        break
    }
    if ($runState -notin $activeRunStates) {
        throw "Image build [$ImageTemplateName] finished with state [$runState]. $($lastRunStatus.message)"
    }
} while ($true)

$availability = Get-ImageVersionAvailability -RequiredRegions $requiredReplicationRegions
do {
    if ([datetimeoffset] (Get-Date) -ge $deadline) {
        throw "Image build succeeded, but version [$ImageVersion] was not available in all required regions [$($requiredReplicationRegions -join ', ')] before the timeout. $($availability.Details)"
    }

    $publishedVersion = Get-ArmResource -ResourceId $imageVersionResourceId -ApiVersion $imageVersionApiVersion -Expand 'ReplicationStatus'
    $availability = Get-ImageVersionAvailability -ImageVersionResource $publishedVersion -RequiredRegions $requiredReplicationRegions
    if ($availability.Ready) {
        break
    }
    if (-not $availability.CanWait) {
        throw "Image build succeeded, but version [$ImageVersion] is unavailable. $($availability.Details) Repair the existing version's publication or replication before retrying; it will not be rebuilt."
    }
    Start-Sleep -Seconds 15
} while ($true)

return [pscustomobject] @{
    BuildStarted            = -not $resumeActiveRun
    BuildStatus             = 'Succeeded'
    ImageVersionResourceId  = $imageVersionResourceId
    ImageTemplateResourceId = $imageTemplateResourceId
    ResourceGroupName       = $ResourceGroupName
}

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

.PARAMETER Operation
Complete preserves synchronous behavior. Start returns a receipt after submission.
Observe only reads that receipt's build and replicas, returning Running when its
bounded observation window expires. Neither mode treats Running as ready.

.PARAMETER OperationReceipt
Receipt from Start or a preceding Observe call. Required for Observe; fixes the
resource identities, original run and absolute build deadline across jobs.

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
    [string[]] $ReplicationRegions = @($Location),

    [Parameter()]
    [ValidateSet('Complete', 'Start', 'Observe')]
    [string] $Operation = 'Complete',

    [Parameter()]
    [string] $OperationReceipt,

    [Parameter()]
    [ValidateRange(1, 300)]
    [int] $ObservationTimeoutInMinutes = 270,

    [Parameter()]
    [hashtable] $Tags = @{},

    [Parameter()]
    [string] $ImageBuilderIdentityName = 'id-avm-persistent-hci-image-builder',

    [Parameter()]
    [string] $StagingResourceGroupName = '',

    [Parameter()]
    [datetimeoffset] $BuildDeadlineUtc,
    [Parameter()]
    [bool] $UseScopedContributorRole = $false
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

function Get-HciImageBuildResult {
    param (
        [Parameter(Mandatory)]
        [string] $Status,

        [Parameter(Mandatory)]
        [bool] $Started
    )

    $result = [ordered] @{
        BuildStarted            = $Started
        BuildStatus             = $Status
        ImageVersionResourceId  = $imageVersionResourceId
        ImageTemplateResourceId = $imageTemplateResourceId
        ResourceGroupName       = $ResourceGroupName
    }
    if ($Operation -ne 'Complete') {
        $result.OperationReceipt = if ($Status -eq 'Running') {
            @{
                imageVersionResourceId  = $imageVersionResourceId
                imageTemplateResourceId = $imageTemplateResourceId
                previousRunStartTime    = $previousRunStartTime.ToString('o')
                observedRunStartTime    = $observedRunStartTime.ToString('o')
                deadline                = $deadline.ToString('o')
                requiredRegions         = $requiredReplicationRegions
                operationPath           = $operationPath
            } | ConvertTo-Json -Depth 5 -Compress
        } else { '' }
    }
    return [pscustomobject] $result
}

function ConvertTo-HciImageBuildTimestamp {
    param ([Parameter(Mandatory)] [object] $Value)

    if ($Value -is [datetimeoffset] -or ($Value -is [datetime] -and $Value.Kind -ne [DateTimeKind]::Unspecified)) {
        return ([datetimeoffset] $Value).ToUniversalTime()
    }
    $timestamp = [datetimeoffset]::MinValue
    if ($Value -isnot [string] -or $Value -notmatch '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d{1,7})?(?:Z|[+-]\d{2}:\d{2})$' -or
        -not [datetimeoffset]::TryParse($Value, [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::None, [ref] $timestamp)) {
        throw 'An image build timestamp is missing its valid, absolute time-zone-qualified value.'
    }
    return $timestamp.ToUniversalTime()
}

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

    . (Join-Path $PSScriptRoot 'Get-HciImageVersionAvailability.ps1')
    Get-HciImageVersionAvailability -ImageVersionResource $ImageVersionResource -RequiredRegions $RequiredRegions
}

if ([string]::IsNullOrWhiteSpace($SubscriptionId)) {
    throw 'SubscriptionId is required when no Azure context is available.'
}

$previousRunStartTime = [datetimeoffset]::MinValue
$observedRunStartTime = [datetimeoffset]::MinValue
$operationPath = ''
$deadline = $PSBoundParameters.ContainsKey('BuildDeadlineUtc') ?
    $BuildDeadlineUtc : ([datetimeoffset] (Get-Date)).AddMinutes($BuildTimeoutInMinutes)
if ($Operation -eq 'Observe') {
    $receipt = ConvertFrom-Json -InputObject $OperationReceipt -AsHashtable -ErrorAction Stop
    if ($receipt -isnot [System.Collections.IDictionary] -or
        $receipt.imageVersionResourceId -cne $imageVersionResourceId -or
        $receipt.imageTemplateResourceId -cne $imageTemplateResourceId -or
        ($receipt.requiredRegions -join ',') -cne ($requiredReplicationRegions -join ',')) {
        throw 'The image build receipt does not match the explicitly selected resources and replication regions.'
    }
    $previousRunStartTime = ConvertTo-HciImageBuildTimestamp -Value $receipt.previousRunStartTime
    $observedRunStartTime = ConvertTo-HciImageBuildTimestamp -Value $receipt.observedRunStartTime
    $deadline = ConvertTo-HciImageBuildTimestamp -Value $receipt.deadline
    if ($observedRunStartTime -le $previousRunStartTime -or $deadline -le $observedRunStartTime) {
        throw 'The image build receipt does not identify a new run within its immutable overall deadline.'
    }
    $operationPath = [string] $receipt.operationPath
    $expectedOperationPrefix = "/subscriptions/$SubscriptionId/providers/Microsoft.VirtualMachineImages/locations/$BuildLocation/operations/"
    if ($operationPath -cnotmatch "^$([regex]::Escape($expectedOperationPrefix))[a-zA-Z0-9-]+\?api-version=$imageTemplateApiVersion$") {
        throw 'The image build receipt does not contain a valid operation identity for the selected subscription and region.'
    }
} elseif (-not [string]::IsNullOrEmpty($OperationReceipt)) {
    throw 'OperationReceipt can only be used with Observe.'
}
$deadline = $deadline.ToUniversalTime()
if ($deadline -le [datetimeoffset] (Get-Date)) {
    throw 'Timed out: the recorded overall image deadline has expired. No build will be submitted.'
}

$null = Set-AzContext -SubscriptionId $SubscriptionId
$existingVersion = if ($Operation -ne 'Observe') {
    Get-ArmResource -ResourceId $imageVersionResourceId -ApiVersion $imageVersionApiVersion -Expand 'ReplicationStatus'
} else { $null }
if ($null -ne $existingVersion) {
    $availability = Get-ImageVersionAvailability -ImageVersionResource $existingVersion -RequiredRegions $requiredReplicationRegions
    if (-not $availability.Ready) {
        throw "Image version [$imageVersionResourceId] already exists but is unavailable. $($availability.Details) No deployment or build was started. Wait for or repair replication before retrying, or choose a new ImageVersion for a new build."
    }
    return Get-HciImageBuildResult -Status 'Skipped' -Started $false
}

$activeRunStates = @('New', 'Pending', 'Running')
$templateBeforeDeployment = Get-ArmResource -ResourceId $imageTemplateResourceId -ApiVersion $imageTemplateApiVersion
if ($null -ne $templateBeforeDeployment -and
    ([string] $templateBeforeDeployment.location).Replace(' ', '').ToLowerInvariant() -ne $BuildLocation.Replace(' ', '').ToLowerInvariant()) {
    throw "Image template [$ImageTemplateName] has location [$($templateBeforeDeployment.location)], not BuildLocation [$BuildLocation]. Choose a new ImageTemplateName; existing template locations cannot be changed."
}
$resumeActiveRun = $Operation -eq 'Observe' -or ($null -ne $templateBeforeDeployment -and
    [string] $templateBeforeDeployment.properties.lastRunStatus.runState -in $activeRunStates)
if ($Operation -eq 'Observe') {
    if ($null -eq $templateBeforeDeployment) {
        throw 'The image template in the build receipt no longer exists; no build was submitted.'
    }
} elseif ($resumeActiveRun) {
    if ($Operation -eq 'Start') {
        throw 'An image build is already active. Observe its recorded operation; Start cannot adopt or resubmit it.'
    }
    if ($templateBeforeDeployment.properties.lastRunStatus.startTime) {
        $observedRunStartTime = [datetimeoffset] $templateBeforeDeployment.properties.lastRunStatus.startTime
        if (-not $PSBoundParameters.ContainsKey('BuildDeadlineUtc')) {
            $deadline = $observedRunStartTime.AddMinutes($BuildTimeoutInMinutes)
        }
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
        imageBuilderIdentityName = $ImageBuilderIdentityName
        stagingResourceGroupName = $StagingResourceGroupName
        useScopedContributorRole = $UseScopedContributorRole
        tags                  = $Tags
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
    if ($Operation -eq 'Start') {
        $operationUri = $null
        $headerValues = $null
        $header = if ($runResponse.Headers -is [System.Net.Http.Headers.HttpResponseHeaders] -and
            $runResponse.Headers.TryGetValues('Azure-AsyncOperation', [ref] $headerValues) -and @($headerValues).Count -eq 1) {
            @($headerValues)[0]
        }
        $expectedOperationPrefix = "/subscriptions/$SubscriptionId/providers/Microsoft.VirtualMachineImages/locations/$BuildLocation/operations/"
        if (-not [uri]::TryCreate([string] $header, [UriKind]::Absolute, [ref] $operationUri) -or
            $operationUri.Scheme -cne 'https' -or $operationUri.Authority -cne 'management.azure.com' -or
            $operationUri.UserInfo -or $operationUri.Fragment -or
            $operationUri.PathAndQuery -cnotmatch "^$([regex]::Escape($expectedOperationPrefix))[a-zA-Z0-9-]+\?api-version=$imageTemplateApiVersion$") {
            throw 'The submitted image build returned no unambiguous operation identity. Its outcome is uncertain; do not resubmit or recreate.'
        }
        $operationPath = $operationUri.PathAndQuery
    }
}

if ($Operation -eq 'Start') {
    $identityDeadline = ([datetimeoffset] (Get-Date)).AddMinutes(2)
    do {
        if ([datetimeoffset] (Get-Date) -ge $deadline -or [datetimeoffset] (Get-Date) -ge $identityDeadline) {
            throw 'The submitted image operation has no observable run identity. Its outcome is uncertain; do not resubmit or recreate.'
        }
        $startedTemplate = Get-ArmResource -ResourceId $imageTemplateResourceId -ApiVersion $imageTemplateApiVersion
        if ($startedTemplate.properties.lastRunStatus.startTime) {
            $startedAt = ConvertTo-HciImageBuildTimestamp -Value $startedTemplate.properties.lastRunStatus.startTime
            if ($startedAt -gt $previousRunStartTime) {
                $observedRunStartTime = $startedAt
                break
            }
        }
        Start-Sleep -Seconds 15
    } while ($true)
    return Get-HciImageBuildResult -Status 'Running' -Started (-not $resumeActiveRun)
}
$observationDeadline = ([datetimeoffset] (Get-Date)).AddMinutes($ObservationTimeoutInMinutes)
do {
    if ([datetimeoffset] (Get-Date) -ge $deadline) {
        throw "Timed out after [$BuildTimeoutInMinutes] minutes waiting for image build [$ImageTemplateName]."
    }
    if ($Operation -eq 'Observe' -and [datetimeoffset] (Get-Date) -ge $observationDeadline) {
        return Get-HciImageBuildResult -Status 'Running' -Started $false
    }

    Start-Sleep -Seconds 15
    if ($Operation -eq 'Observe') {
        $operationResponse = Invoke-AzRestMethod -Method GET -Path $operationPath
        if ([int] $operationResponse.StatusCode -ne 200) {
            throw "Reading the recorded image operation returned HTTP [$($operationResponse.StatusCode)]."
        }
        $operationState = (ConvertFrom-Json -InputObject $operationResponse.Content -AsHashtable -ErrorAction Stop).status
        if ($operationState -notin @('Succeeded', 'InProgress', 'Running', 'Accepted')) {
            throw "The recorded image operation has failed or unknown status [$operationState]."
        }
        if ($operationState -ne 'Succeeded') {
            continue
        }
    }
    $template = Get-ArmResource -ResourceId $imageTemplateResourceId -ApiVersion $imageTemplateApiVersion
    $lastRunStatus = $template.properties.lastRunStatus
    if (-not $lastRunStatus.startTime) {
        continue
    }

    $runStartTime = [datetimeoffset] $lastRunStatus.startTime
    if ($runStartTime -le $previousRunStartTime) {
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
    if ($Operation -eq 'Observe' -and [datetimeoffset] (Get-Date) -ge $observationDeadline) {
        return Get-HciImageBuildResult -Status 'Running' -Started $false
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

return Get-HciImageBuildResult -Status 'Succeeded' -Started ($Operation -ne 'Observe' -and -not $resumeActiveRun)

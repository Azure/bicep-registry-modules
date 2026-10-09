<#
.SYNOPSIS
Deploys and runs the reusable Azure Stack HCI host image builder.

.DESCRIPTION
Skips an existing successful deterministic image version, resumes an active
image build, or deploys the builder resources and starts a new build. It waits
for the build and gallery version publication to succeed.
#>

[CmdletBinding()]
param (
    [Parameter()]
    [string] $TemplateFile = (Join-Path $PSScriptRoot 'hciHostGalleryBuilder.bicep'),

    [Parameter()]
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
    [string] $SubscriptionId = (Get-AzContext).Subscription.Id
)

$ErrorActionPreference = 'Stop'
$imageVersionResourceId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Compute/galleries/$GalleryName/images/$ImageDefinitionName/versions/$ImageVersion"
$imageTemplateResourceId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.VirtualMachineImages/imageTemplates/$ImageTemplateName"
$imageVersionApiVersion = '2024-03-03'
$imageTemplateApiVersion = '2025-10-01'

function Get-ArmResource {
    param (
        [Parameter(Mandatory)]
        [string] $ResourceId,

        [Parameter(Mandatory)]
        [string] $ApiVersion
    )

    $response = Invoke-AzRestMethod -Method GET -Path "$ResourceId`?api-version=$ApiVersion"
    if ([int] $response.StatusCode -eq 404) {
        return $null
    }
    if ([int] $response.StatusCode -notin 200, 201) {
        throw "ARM GET [$ResourceId] returned HTTP [$($response.StatusCode)]. $($response.Content)"
    }
    return $response.Content | ConvertFrom-Json
}

function Test-SuccessfulImageVersion {
    param (
        [Parameter()]
        [object] $ImageVersionResource
    )

    return (
        $null -ne $ImageVersionResource -and
        $ImageVersionResource.properties.provisioningState -eq 'Succeeded' -and
        $ImageVersionResource.properties.publishingProfile.excludeFromLatest -ne $true
    )
}

if ([string]::IsNullOrWhiteSpace($SubscriptionId)) {
    throw 'SubscriptionId is required when no Azure context is available.'
}

$null = Set-AzContext -SubscriptionId $SubscriptionId
$existingVersion = Get-ArmResource -ResourceId $imageVersionResourceId -ApiVersion $imageVersionApiVersion
if (Test-SuccessfulImageVersion -ImageVersionResource $existingVersion) {
    return [pscustomobject] @{
        BuildStarted          = $false
        BuildStatus           = 'Skipped'
        ImageVersionResourceId = $imageVersionResourceId
        ImageTemplateResourceId = $imageTemplateResourceId
        ResourceGroupName     = $ResourceGroupName
    }
}

$activeRunStates = @('New', 'Pending', 'Running')
$templateBeforeDeployment = Get-ArmResource -ResourceId $imageTemplateResourceId -ApiVersion $imageTemplateApiVersion
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
        assetBaseUri         = $AssetBaseUri
        buildTimeoutInMinutes = $BuildTimeoutInMinutes
        createResourceGroup  = $CreateResourceGroup
        galleryName          = $GalleryName
        hciVhdxDownloadUri   = $HciVhdxDownloadUri
        imageDefinitionName  = $ImageDefinitionName
        imageTemplateName    = $ImageTemplateName
        imageVersion         = $ImageVersion
        location             = $Location
        resourceGroupName    = $ResourceGroupName
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

$deadline = [datetimeoffset]::UtcNow.AddMinutes($BuildTimeoutInMinutes)
do {
    if ([datetimeoffset]::UtcNow -ge $deadline) {
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

do {
    if ([datetimeoffset]::UtcNow -ge $deadline) {
        throw "Image build succeeded, but version [$ImageVersion] was not published successfully before the timeout."
    }

    $publishedVersion = Get-ArmResource -ResourceId $imageVersionResourceId -ApiVersion $imageVersionApiVersion
    if (Test-SuccessfulImageVersion -ImageVersionResource $publishedVersion) {
        break
    }
    Start-Sleep -Seconds 15
} while ($true)

return [pscustomobject] @{
    BuildStarted           = -not $resumeActiveRun
    BuildStatus            = 'Succeeded'
    ImageVersionResourceId = $imageVersionResourceId
    ImageTemplateResourceId = $imageTemplateResourceId
    ResourceGroupName      = $ResourceGroupName
}

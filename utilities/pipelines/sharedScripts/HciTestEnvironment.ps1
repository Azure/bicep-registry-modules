. (Join-Path $PSScriptRoot 'HciImageReceipt.ps1')

function Get-HciEnvironmentKey {
    [CmdletBinding()]
    param ([Parameter(Mandatory)] [string] $Value)

    [Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData(
            [System.Text.Encoding]::UTF8.GetBytes($Value)
        )).ToLowerInvariant()
}

function Get-HciEnvironmentParameterMap {
    [CmdletBinding()]
    param (
        [string] $GitHubVariables = '{}',
        [string] $GitHubSecrets = '{}',
        [string] $KeyVaultName
    )

    . (Join-Path $PSScriptRoot 'Get-CIParameterMap.ps1')
    $definitions = @{
        arbLocalAdminAndDeploymentUserPass   = @{ type = 'secureString' }
        arbDeploymentAppId                  = @{ type = 'secureString' }
        arbDeploymentSPObjectId              = @{ type = 'secureString' }
        arbDeploymentServicePrincipalSecret = @{ type = 'secureString' }
        hciHostImageReferenceId              = @{ type = 'secureString' }
        builtInServicePrincipalObjectId     = @{ type = 'string' }
    }
    Get-CIParameterMap -TemplateParameters $definitions -GitHubVariables $GitHubVariables -GitHubSecrets $GitHubSecrets -KeyVaultName $KeyVaultName
}

function Get-HciTestSubscription {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $ModulePath,
        [Parameter(Mandatory)] [string] $TestSubscriptionIds,
        [Parameter(Mandatory)] [int] $SubscriptionIndex,
        [Parameter(Mandatory)] [string] $SubscriptionKey,
        [Parameter(Mandatory)] [string] $RepoRootPath
    )

    . (Join-Path $PSScriptRoot 'Get-TestSubscriptionList.ps1')
    $selected = @(Get-TestSubscriptionList -TestSubscriptionIds $TestSubscriptionIds -ModulePath $ModulePath -RepoRootPath $RepoRootPath |
        Where-Object { $_.index -eq $SubscriptionIndex })
    if ($selected.Count -ne 1 -or $selected[0].key -cne $SubscriptionKey -or $selected[0].tag -cne 'Azure Local') {
        throw 'The pinned Azure Local subscription no longer belongs to the required reserved pool.'
    }
    return $selected[0]
}

function Get-HciEnvironmentContext {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $RepoRootPath,
        [Parameter(Mandatory)] [guid] $SubscriptionId,
        [Parameter(Mandatory)] [guid] $TenantId,
        [Parameter(Mandatory)] [ValidatePattern('^[a-f0-9]{64}$')] [string] $Owner,
        [string] $HciHostImageReferenceId
    )

    if ($SubscriptionId -eq [guid]::Empty -or $TenantId -eq [guid]::Empty) {
        throw 'Explicit nonempty tenant and reserved subscription identities are required.'
    }
    $azureContext = Get-AzContext -ErrorAction Stop
    if ($null -eq $azureContext -or [guid] $azureContext.Subscription.Id -ne $SubscriptionId -or
        [guid] $azureContext.Tenant.Id -ne $TenantId -or $azureContext.Environment.Name -cne 'AzureCloud') {
        throw 'The authenticated Azure context does not match the reserved environment tenant, subscription and cloud.'
    }
    $assetRoot = Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'module-specific' 'azure-stack-hci'
    $configText = Get-Content -LiteralPath (Join-Path $assetRoot 'environment.json') -Raw -ErrorAction Stop
    $config = ConvertFrom-Json -InputObject $configText -AsHashtable -ErrorAction Stop
    if ($config.version -cne '1' -or $config.location -cne 'australiaeast' -or
        $config.imageVersion -cnotmatch '^\d+\.\d+\.\d+$' -or
        $config.imageTimeoutMinutes -ne 570 -or $config.foundationTimeoutMinutes -ne 660) {
        throw 'Unsupported Azure Local environment contract.'
    }
    $payloadUri = $null
    if ($config.hciVhdxDownloadUri -isnot [string] -or
        -not [uri]::TryCreate($config.hciVhdxDownloadUri, [UriKind]::Absolute, [ref] $payloadUri) -or
        $payloadUri.Scheme -cne 'https' -or $payloadUri.UserInfo -or $payloadUri.Query -or $payloadUri.Fragment -or
        $config.hciVhdxSha256 -isnot [string] -or $config.hciVhdxSha256 -cnotmatch '\A[0-9a-fA-F]{64}\z') {
        throw 'The Azure Local payload contract requires a public HTTPS URI and a pinned SHA256 digest.'
    }
    $groupNames = @($config.controlResourceGroupName, $config.foundationResourceGroupName, $config.imageResourceGroupName, $config.stagingResourceGroupName)
    if (($groupNames | Sort-Object -Unique).Count -ne 4 -or
        @($groupNames | Where-Object { $_ -isnot [string] -or $_ -cnotmatch '^rg-avm-ci-azure-local-[a-z-]+$' }).Count -gt 0) {
        throw 'The environment must have four distinct, explicitly named CI-owned resource groups.'
    }
    foreach ($name in @('galleryName', 'imageDefinitionName', 'imageTemplateName', 'imageBuilderIdentityName', 'clusterName', 'customLocationName', 'logicalNetworkName', 'deploymentName')) {
        if ($config[$name] -isnot [string] -or $config[$name] -cnotmatch '^[a-z][a-z0-9-]{0,63}$') {
            throw "Invalid explicit environment name [$name]."
        }
    }
    $subscriptionRoot = "/subscriptions/$($SubscriptionId.ToString('D'))"
    $groupIds = @{}
    foreach ($kind in @('control', 'foundation', 'image', 'staging')) {
        $name = $kind -eq 'staging' ? $config.stagingResourceGroupName : $config["${kind}ResourceGroupName"]
        $groupIds[$kind] = "$subscriptionRoot/resourceGroups/$name"
    }
    $ownedImageId = "$($groupIds.image)/providers/Microsoft.Compute/galleries/$($config.galleryName)/images/$($config.imageDefinitionName)/versions/$($config.imageVersion)"
    $externalImage = -not [string]::IsNullOrEmpty($HciHostImageReferenceId)
    $imageId = $externalImage ? $HciHostImageReferenceId : $ownedImageId
    if ($imageId -notmatch '^/subscriptions/[0-9a-f-]{36}/resourceGroups/[a-z0-9_.()-]+/providers/Microsoft\.Compute/galleries/[a-z0-9_.-]+/images/[a-z0-9_.-]+/versions/\d+\.\d+\.\d+$') {
        throw 'The host image must be an immutable Azure Compute Gallery image-version resource ID.'
    }
    $imageSubscriptionId = [guid]::Empty
    if (-not [guid]::TryParse(($imageId -split '/')[2], [ref] $imageSubscriptionId) -or $imageSubscriptionId -eq [guid]::Empty) {
        throw 'The host image resource ID must contain a valid, nonempty subscription identity.'
    }
    if ($externalImage -and @(@($groupIds.control, $groupIds.foundation) | Where-Object {
                $imageId.StartsWith("$_/", [StringComparison]::OrdinalIgnoreCase)
            }).Count -gt 0) {
        throw 'An external read-only image cannot be inside the control or foundation resource group registered for environment recreation.'
    }
    $ownedKinds = $externalImage ? @('foundation') : @('foundation', 'image', 'staging')
    $ownedNames = @($ownedKinds | ForEach-Object { ($groupIds[$_] -split '/')[-1] })
    $tags = @{
        lifecycle           = 'tenant-persistent'
        'avm-owner'         = 'Azure/bicep-registry-modules'
        'avm-environment'   = 'azure-local'
        'avm-version'       = $config.version
        'avm-contract'      = Get-HciEnvironmentKey -Value ($config | ConvertTo-Json -Depth 5 -Compress)
        'avm-tenant'        = $TenantId.ToString('D')
        'avm-subscription'  = $SubscriptionId.ToString('D')
        'avm-owned-groups'  = $ownedNames -join ';'
        'avm-image-key'     = Get-HciEnvironmentKey -Value $imageId.ToLowerInvariant()
        'avm-image-external' = $externalImage.ToString()
    }
    return @{
        Config                  = $config
        AssetRoot               = $assetRoot
        RepoRootPath            = $RepoRootPath
        SubscriptionId          = $SubscriptionId.ToString('D')
        TenantId                = $TenantId.ToString('D')
        Owner                   = $Owner
        Tags                    = $tags
        GroupIds                = $groupIds
        OwnedGroupIds           = @($ownedKinds | ForEach-Object { $groupIds[$_] })
        ExternalImage           = $externalImage
        ImageVersionResourceId  = $imageId
        ImageTemplateResourceId = "$($groupIds.image)/providers/Microsoft.VirtualMachineImages/imageTemplates/$($config.imageTemplateName)"
        DeploymentResourceId    = "$($groupIds.foundation)/providers/Microsoft.Resources/deployments/$($config.deploymentName)"
    }
}

function Get-HciArmResource {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $ResourceId,
        [Parameter(Mandatory)] [string] $ApiVersion,
        [string] $Expand,
        [switch] $AllowNotFound
    )

    $path = "${ResourceId}?api-version=$ApiVersion"
    if ($Expand) { $path += "&`$expand=$Expand" }
    $response = Invoke-AzRestMethod -Method GET -Path $path -ErrorAction Stop
    $content = ConvertFrom-Json -InputObject $response.Content -AsHashtable -NoEnumerate -ErrorAction Stop
    if ($response.StatusCode -is [array] -or $content -isnot [System.Collections.IDictionary]) {
        throw "Cannot verify Azure Local resource [$ResourceId]: malformed ARM response."
    }
    if ($content.tags -is [System.Collections.IDictionary]) {
        foreach ($name in @($content.tags.Keys)) {
            if ($content.tags[$name] -is [datetime] -or $content.tags[$name] -is [datetimeoffset]) {
                $content.tags[$name] = ([datetimeoffset] $content.tags[$name]).ToUniversalTime().ToString('o')
            }
        }
    }
    $notFoundCodes = if ($ResourceId -match '/resourceGroups/[^/]+$') {
        @('ResourceGroupNotFound')
    } elseif ($ResourceId -match '/providers/Microsoft\.Resources/deployments/[^/]+$') {
        @('DeploymentNotFound', 'ResourceGroupNotFound')
    } else {
        @('ResourceNotFound', 'ResourceGroupNotFound')
    }
    $errorTarget = $content.error.target
    if ($AllowNotFound -and $response.StatusCode -eq 404 -and
        $content.error.code -in $notFoundCodes -and
        ($null -eq $errorTarget -or ($errorTarget -is [string] -and ($errorTarget -eq '' -or $errorTarget -ieq $ResourceId)))) {
        return $null
    }
    if ($response.StatusCode -ne 200 -or
        $content.error -or $content.id -isnot [string] -or $content.id -ine $ResourceId) {
        throw "Cannot verify Azure Local resource [$ResourceId]: HTTP [$($response.StatusCode)]."
    }
    return $content
}

function Get-HciOwnedGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [hashtable] $Context,
        [Parameter(Mandatory)] [string] $ResourceId,
        [switch] $AllowNotFound
    )

    if ($ResourceId -notin @($Context.GroupIds.control) + $Context.OwnedGroupIds) {
        throw 'The resource group is not in the exact environment ownership registry.'
    }
    $group = Get-HciArmResource -ResourceId $ResourceId -ApiVersion '2024-03-01' -AllowNotFound:$AllowNotFound
    if ($null -eq $group) { return $null }
    foreach ($tag in $Context.Tags.GetEnumerator()) {
        if ($group.tags[$tag.Key] -cne $tag.Value) {
            throw "Resource group [$ResourceId] has missing or mismatched ownership/version tag [$($tag.Key)]. It will not be adopted."
        }
    }
    if ($group.location -cne $Context.Config.location -or $group.properties.provisioningState -cne 'Succeeded') {
        throw "Owned resource group [$ResourceId] is not provisioned in the registered location."
    }
    return $group
}

function Get-HciEnvironmentRegistry {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [hashtable] $Context,
        [switch] $RequireOwner,
        [switch] $AllowNotFound
    )

    $azureContext = Get-AzContext -ErrorAction Stop
    if ($null -eq $azureContext -or [guid] $azureContext.Subscription.Id -ne [guid] $Context.SubscriptionId -or
        [guid] $azureContext.Tenant.Id -ne [guid] $Context.TenantId -or $azureContext.Environment.Name -cne 'AzureCloud') {
        throw 'The Azure context changed; environment ownership cannot be used in another tenant, subscription or cloud.'
    }
    $registry = Get-HciOwnedGroup -Context $Context -ResourceId $Context.GroupIds.control -AllowNotFound:$AllowNotFound
    if ($null -ne $registry -and $RequireOwner -and
        ($registry.tags['avm-active-owner'] -cne $Context.Owner -or
            $registry.tags['avm-state'] -cnotin @('Preparing', 'InUse', 'Recreating'))) {
        throw 'The environment is owned by another operation or is blocked pending operator investigation.'
    }
    return $registry
}

function Set-HciEnvironmentState {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)] [hashtable] $Context,
        [Parameter(Mandatory)] [hashtable] $Values,
        [switch] $Acquire
    )

    $registry = Get-HciEnvironmentRegistry -Context $Context -RequireOwner:(-not $Acquire)
    if ($Acquire -and ($registry.tags['avm-state'] -cne 'Idle' -or $registry.tags['avm-active-owner'])) {
        throw 'The environment is not idle. Unfinished tests, preparation or uncertain cleanup block reuse and recreation.'
    }
    if (-not $PSCmdlet.ShouldProcess($Context.GroupIds.control, 'Update the environment ownership record')) {
        throw 'The environment ownership update was not performed.'
    }
    $null = Update-AzTag -ResourceId $Context.GroupIds.control -Operation Merge -Tag $Values -ErrorAction Stop
    $updated = Get-HciEnvironmentRegistry -Context $Context
    foreach ($entry in $Values.GetEnumerator()) {
        if ($updated.tags[$entry.Key] -cne [string] $entry.Value) {
            throw 'The environment ownership record changed concurrently; no further action is safe.'
        }
    }
}

function Assert-HciImageReady {
    [CmdletBinding()]
    param ([Parameter(Mandatory)] [hashtable] $Context)

    . (Join-Path $Context.AssetRoot 'Get-HciImageVersionAvailability.ps1')
    $image = Get-HciArmResource -ResourceId $Context.ImageVersionResourceId -ApiVersion '2024-03-03' -Expand 'ReplicationStatus'
    $availability = Get-HciImageVersionAvailability -ImageVersionResource ([pscustomobject] $image) -RequiredRegions @($Context.Config.location)
    if (-not $availability.Ready) {
        throw "The immutable host image is not usable in the reserved region. $($availability.Details)"
    }
}

function Remove-HciOwnedResourceGroup {
    [CmdletBinding(SupportsShouldProcess)]
    param ([Parameter(Mandatory)] [hashtable] $Context)

    $registry = Get-HciEnvironmentRegistry -Context $Context -RequireOwner
    if ($registry.tags['avm-state'] -cne 'Recreating' -or $registry.tags['avm-image-state'] -cnotin @('None', 'Ready') -or
        $registry.tags['avm-foundation-state'] -cnotin @('None', 'Provisioned', 'Ready')) {
        throw 'Unfinished or uncertain preparation blocks recreation.'
    }
    foreach ($id in $Context.OwnedGroupIds) {
        $null = Get-HciOwnedGroup -Context $Context -ResourceId $id
        foreach ($deployment in @(Get-AzResourceGroupDeployment -ResourceGroupName ($id -split '/')[-1] -ErrorAction Stop)) {
            if ($deployment.ProvisioningState -cnotin @('Succeeded', 'Failed', 'Canceled')) {
                throw "Resource group [$id] has an unfinished deployment; recreation is blocked."
            }
        }
    }
    if (-not $Context.ExternalImage) {
        $template = Get-HciArmResource -ResourceId $Context.ImageTemplateResourceId -ApiVersion '2025-10-01' -AllowNotFound
        if ($template -and $template.properties.lastRunStatus.runState -cnotin @('Succeeded', 'Failed', 'Canceled', 'Cancelled')) {
            throw 'An unfinished or unknown image build blocks recreation.'
        }
    }
    $deadline = (Get-Date).ToUniversalTime().AddMinutes(120)
    if (-not $PSCmdlet.ShouldProcess(($Context.OwnedGroupIds -join ', '), 'Remove only the registered owned environment groups')) {
        throw 'Registered environment group removal was not performed.'
    }
    foreach ($id in $Context.OwnedGroupIds) {
        if ($null -eq (Get-HciOwnedGroup -Context $Context -ResourceId $id -AllowNotFound)) {
            continue
        }
        $response = Invoke-AzRestMethod -Method DELETE -Path "${id}?api-version=2024-03-01" -ErrorAction Stop
        if ($response.StatusCode -notin @(200, 202, 204)) {
            throw "Deletion of the exact registered group [$id] was not accepted."
        }
        while ($null -ne (Get-HciArmResource -ResourceId $id -ApiVersion '2024-03-01' -AllowNotFound)) {
            if ((Get-Date).ToUniversalTime() -ge $deadline) {
                throw 'Owned-group deletion is not confirmed. The environment remains blocked; no replacement was submitted.'
            }
            Start-Sleep -Seconds 30
        }
    }
}

function Start-HciEnvironmentPreparation {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)] [hashtable] $Context,
        [Parameter(Mandatory)] [ValidatePattern('^[a-f0-9]{40}$')] [string] $SourceCommit,
        [string] $RunIdentity,
        [string] $ReceiptStorageAccountName,
        [bool] $Recreate = $false,
        [bool] $Maintenance = $false
    )

    if (-not $Maintenance) {
        throw 'Shared Azure Local provisioning is available only through the dedicated setup workflow [platform.hci.prepare.yml].'
    }
    if (-not $PSCmdlet.ShouldProcess($Context.GroupIds.control, ($Recreate ? 'Acquire and recreate the registered environment' : 'Acquire and prepare the registered environment'))) {
        throw 'Environment preparation was not performed.'
    }
    if ($Context.ExternalImage) {
        Assert-HciImageReady -Context $Context
    }
    $registry = Get-HciEnvironmentRegistry -Context $Context -AllowNotFound
    if ($null -eq $registry) {
        if ($Recreate) { throw 'There is no registered environment to recreate.' }
        foreach ($id in $Context.OwnedGroupIds) {
            if ($null -ne (Get-HciArmResource -ResourceId $id -ApiVersion '2024-03-01' -AllowNotFound)) {
                throw "Unregistered resource group [$id] already exists. Preparation will not adopt it."
            }
        }
        $tags = $Context.Tags.Clone()
        $tags += @{
            'avm-active-owner'     = $Context.Owner
            'avm-state'            = 'Preparing'
            'avm-generation'       = [guid]::NewGuid().ToString('N')
            'avm-image-state'      = 'None'
            'avm-foundation-state' = 'None'
        }
        $null = New-AzResourceGroup -Name $Context.Config.controlResourceGroupName -Location $Context.Config.location -Tag $tags -ErrorAction Stop
    } else {
        foreach ($id in $Context.OwnedGroupIds) { $null = Get-HciOwnedGroup -Context $Context -ResourceId $id }
        Set-HciEnvironmentState -Context $Context -Acquire -Values @{
            'avm-active-owner' = $Context.Owner
            'avm-state'        = $Recreate ? 'Recreating' : 'Preparing'
        }
        if ($Recreate) {
            Remove-HciOwnedResourceGroup -Context $Context
            Set-HciEnvironmentState -Context $Context -Values @{
                'avm-state'            = 'Preparing'
                'avm-generation'       = [guid]::NewGuid().ToString('N')
                'avm-image-state'      = 'None'
                'avm-foundation-state' = 'None'
            }
        }
    }
    $registry = Get-HciEnvironmentRegistry -Context $Context -RequireOwner
    foreach ($id in $Context.OwnedGroupIds) {
        $group = Get-HciOwnedGroup -Context $Context -ResourceId $id -AllowNotFound
        if ($null -eq $group) {
            $null = New-AzResourceGroup -Name ($id -split '/')[-1] -Location $Context.Config.location -Tag $Context.Tags -ErrorAction Stop
            $null = Get-HciOwnedGroup -Context $Context -ResourceId $id
        }
    }
    if ($registry.tags['avm-image-state'] -ceq 'Ready' -or $Context.ExternalImage) {
        Assert-HciImageReady -Context $Context
        Set-HciEnvironmentState -Context $Context -Values @{ 'avm-image-state' = 'Ready' }
        return
    }
    if ($registry.tags['avm-image-state'] -cne 'None') {
        throw 'The image operation is unfinished or uncertain. A new build will not be submitted.'
    }
    if ($null -ne (Get-HciArmResource -ResourceId $Context.ImageVersionResourceId -ApiVersion '2024-03-03' -AllowNotFound)) {
        Assert-HciImageReady -Context $Context
        Set-HciEnvironmentState -Context $Context -Values @{ 'avm-image-state' = 'Ready' }
        return
    }
    $deadline = ([datetimeoffset] (Get-Date)).ToUniversalTime().AddMinutes($Context.Config.imageTimeoutMinutes)
    Set-HciEnvironmentState -Context $Context -Values @{
        'avm-image-state'    = 'Submitting'
        'avm-image-deadline' = $deadline.ToString('o')
    }
    $store = Get-HciImageReceiptContext -Context $Context -SourceCommit $SourceCommit -RunIdentity $RunIdentity -StorageAccountName $ReceiptStorageAccountName
    $pending = New-HciImageReceipt -Store $store
    $build = @{
        TemplateFile              = Join-Path $Context.AssetRoot 'hciHostGalleryBuilder.bicep'
        AssetBaseUri              = "https://raw.githubusercontent.com/Azure/bicep-registry-modules/$SourceCommit/utilities/e2e-template-assets/module-specific/azure-stack-hci"
        SubscriptionId            = $Context.SubscriptionId
        Location                  = $Context.Config.location
        BuildLocation             = $Context.Config.location
        ReplicationRegions        = @($Context.Config.location)
        ResourceGroupName         = $Context.Config.imageResourceGroupName
        StagingResourceGroupName  = $Context.Config.stagingResourceGroupName
        GalleryName               = $Context.Config.galleryName
        ImageDefinitionName       = $Context.Config.imageDefinitionName
        ImageVersion              = $Context.Config.imageVersion
        HciVhdxDownloadUri         = $Context.Config.hciVhdxDownloadUri
        HciVhdxSha256              = $Context.Config.hciVhdxSha256
        ImageTemplateName         = $Context.Config.imageTemplateName
        ImageBuilderIdentityName  = $Context.Config.imageBuilderIdentityName
        Tags                      = $Context.Tags
        CreateResourceGroup       = $false
        UseScopedContributorRole  = $true
        BuildDeadlineUtc          = $deadline
        BuildTimeoutInMinutes     = $Context.Config.imageTimeoutMinutes
        Operation                 = 'Start'
    }
    $result = . (Join-Path $Context.AssetRoot 'Invoke-HciHostImageBuild.ps1') @build
    if ($result.BuildStatus -eq 'Skipped') {
        Assert-HciImageReady -Context $Context
        Set-HciEnvironmentState -Context $Context -Values @{ 'avm-image-state' = 'Ready' }
    } elseif ($result.BuildStatus -in @('Running', 'Succeeded')) {
        try {
            $accepted = Set-HciImageReceipt -Store $store -PendingETag $pending.ETag -OperationReceipt $result.OperationReceipt
            $receipt = ConvertFrom-HciPrivateJson -Value $result.OperationReceipt
            Set-HciEnvironmentState -Context $Context -Values @{
                'avm-image-state'    = 'Running'
                'avm-image-start'    = $receipt.observedRunStartTime
                'avm-image-previous' = $receipt.previousRunStartTime
                'avm-image-operation' = $receipt.operationId
                'avm-image-receipt' = $accepted.Key
                'avm-image-etag' = $accepted.ETag
                'avm-image-hash' = $accepted.Hash
                'avm-image-poll-after' = $result.PollNotBeforeUtc
            }
            if ($result.BuildStatus -eq 'Succeeded') {
                Assert-HciImageReady -Context $Context
                Set-HciEnvironmentState -Context $Context -Values @{ 'avm-image-state' = 'Ready' }
            }
        } finally {
            $receipt = $null
            if ($result.OperationReceipt -is [securestring]) { $result.OperationReceipt.Dispose() }
        }
    } else {
        throw 'Image submission returned an unexpected result; the environment remains blocked.'
    }
}

function Wait-HciEnvironmentImage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [hashtable] $Context,
        [Parameter(Mandatory)] [ValidatePattern('^[a-f0-9]{40}$')] [string] $SourceCommit,
        [string] $RunIdentity,
        [string] $ReceiptStorageAccountName
    )

    $registry = Get-HciEnvironmentRegistry -Context $Context -RequireOwner
    if ($registry.tags['avm-image-state'] -ceq 'Ready') {
        Assert-HciImageReady -Context $Context
        return
    }
    if ($registry.tags['avm-state'] -cne 'Preparing' -or $registry.tags['avm-image-state'] -cne 'Running' -or $Context.ExternalImage) {
        throw 'There is no recorded owned image operation to observe.'
    }
    $store = Get-HciImageReceiptContext -Context $Context -SourceCommit $SourceCommit -RunIdentity $RunIdentity -StorageAccountName $ReceiptStorageAccountName
    $receipt = Get-HciImageReceipt -Store $store -Tags $registry.tags
    $build = @{
        AssetBaseUri             = "https://raw.githubusercontent.com/Azure/bicep-registry-modules/$SourceCommit/utilities/e2e-template-assets/module-specific/azure-stack-hci"
        SubscriptionId           = $Context.SubscriptionId
        Location                 = $Context.Config.location
        BuildLocation            = $Context.Config.location
        ReplicationRegions       = @($Context.Config.location)
        ResourceGroupName        = $Context.Config.imageResourceGroupName
        GalleryName              = $Context.Config.galleryName
        ImageDefinitionName      = $Context.Config.imageDefinitionName
        ImageVersion             = $Context.Config.imageVersion
        ImageTemplateName        = $Context.Config.imageTemplateName
        Operation                = 'Observe'
        OperationReceipt         = $receipt
        PollNotBeforeUtc          = $registry.tags['avm-image-poll-after']
        ObservationTimeoutInMinutes = 270
    }
    try {
        $result = . (Join-Path $Context.AssetRoot 'Invoke-HciHostImageBuild.ps1') @build
    } finally {
        $build.OperationReceipt.Dispose()
    }
    if ($result.OperationReceipt -is [securestring]) { $result.OperationReceipt.Dispose() }
    if ($result.BuildStatus -eq 'Succeeded') {
        Assert-HciImageReady -Context $Context
        Set-HciEnvironmentState -Context $Context -Values @{ 'avm-image-state' = 'Ready' }
    } elseif ($result.BuildStatus -ne 'Running') {
        throw 'Image observation returned an unexpected result; the environment remains blocked.'
    } else {
        Set-HciEnvironmentState -Context $Context -Values @{ 'avm-image-poll-after' = $result.PollNotBeforeUtc }
    }
}

function Start-HciEnvironmentFoundation {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)] [hashtable] $Context,
        [Parameter(Mandatory)] [hashtable] $Parameters,
        [bool] $ImageOnly = $false
    )

    $registry = Get-HciEnvironmentRegistry -Context $Context -RequireOwner
    if ($registry.tags['avm-state'] -cne 'Preparing' -or $registry.tags['avm-image-state'] -cne 'Ready') {
        throw 'Foundation preparation requires a completed, recorded image operation.'
    }
    Assert-HciImageReady -Context $Context
    if ($ImageOnly -or $registry.tags['avm-foundation-state'] -cin @('Provisioned', 'Ready')) { return }
    if ($registry.tags['avm-foundation-state'] -cne 'None') {
        throw 'The original foundation operation is unfinished or uncertain; it will not be resubmitted.'
    }
    $null = Get-HciOwnedGroup -Context $Context -ResourceId $Context.GroupIds.foundation
    if (Get-HciArmResource -ResourceId $Context.DeploymentResourceId -ApiVersion '2022-09-01' -AllowNotFound) {
        throw 'An unrecorded foundation deployment already exists; it will not be adopted or overwritten.'
    }
    foreach ($name in @('arbLocalAdminAndDeploymentUserPass', 'arbDeploymentAppId', 'arbDeploymentSPObjectId', 'arbDeploymentServicePrincipalSecret', 'builtInServicePrincipalObjectId')) {
        if (-not $Parameters.ContainsKey($name) -or $null -eq $Parameters[$name] -or $Parameters[$name].Length -eq 0) {
            throw "Required existing CI identity/credential parameter [$name] is missing. No foundation deployment was submitted."
        }
    }
    $compiled = bicep build (Join-Path $Context.AssetRoot 'foundation.bicep') --stdout
    if ($LASTEXITCODE -ne 0) { throw 'The Azure Local foundation did not compile.' }
    $template = $compiled -join [Environment]::NewLine | ConvertFrom-Json -AsHashtable
    $values = @{
        location                = $Context.Config.location
        tags                    = $Context.Tags
        clusterName             = $Context.Config.clusterName
        customLocationName      = $Context.Config.customLocationName
        logicalNetworkName      = $Context.Config.logicalNetworkName
        generation              = $registry.tags['avm-generation']
        hciHostImageReferenceId  = $Context.ImageVersionResourceId
    }
    foreach ($name in @('arbLocalAdminAndDeploymentUserPass', 'arbDeploymentAppId', 'arbDeploymentSPObjectId', 'arbDeploymentServicePrincipalSecret', 'builtInServicePrincipalObjectId')) {
        $value = $Parameters[$name]
        $values[$name] = $value -is [securestring] ? ([pscredential]::new('ci', $value)).GetNetworkCredential().Password : $value
    }
    $armParameters = @{}
    foreach ($entry in $values.GetEnumerator()) { $armParameters[$entry.Key] = @{ value = $entry.Value } }
    $payload = @{ properties = @{ mode = 'Incremental'; template = $template; parameters = $armParameters } } | ConvertTo-Json -Depth 100 -Compress
    if (-not $PSCmdlet.ShouldProcess($Context.DeploymentResourceId, 'Submit the registered foundation deployment once')) {
        throw 'Foundation submission was not performed.'
    }
    Set-HciEnvironmentState -Context $Context -Values @{
        'avm-foundation-state'    = 'Submitting'
        'avm-foundation-deadline' = ([datetimeoffset] (Get-Date)).ToUniversalTime().AddMinutes($Context.Config.foundationTimeoutMinutes).ToString('o')
    }
    $response = Invoke-AzRestMethod -Method PUT -Path "$($Context.DeploymentResourceId)?api-version=2022-09-01" -Payload $payload -ErrorAction Stop
    if ($response.StatusCode -notin @(200, 201, 202)) {
        throw 'Foundation submission was not confirmed. Its outcome is uncertain; no replacement will be submitted.'
    }
    $submitted = ConvertFrom-Json -InputObject $response.Content -AsHashtable -ErrorAction Stop
    $correlationId = [guid]::Empty
    if ($submitted.id -ine $Context.DeploymentResourceId -or
        -not [guid]::TryParse([string] $submitted.properties.correlationId, [ref] $correlationId) -or $correlationId -eq [guid]::Empty) {
        throw 'The foundation submission returned no verifiable operation identity; the environment remains blocked.'
    }
    $deployment = Get-HciArmResource -ResourceId $Context.DeploymentResourceId -ApiVersion '2022-09-01'
    if ($deployment.properties.correlationId -ine $correlationId.ToString('D')) {
        throw 'The foundation operation changed after submission; the environment remains blocked.'
    }
    Set-HciEnvironmentState -Context $Context -Values @{
        'avm-foundation-state'     = 'Running'
        'avm-foundation-operation' = $correlationId.ToString('D')
    }
}

function Wait-HciEnvironmentFoundation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [hashtable] $Context,
        [bool] $ImageOnly = $false
    )

    $registry = Get-HciEnvironmentRegistry -Context $Context -RequireOwner
    if ($ImageOnly -or $registry.tags['avm-foundation-state'] -cin @('Provisioned', 'Ready')) { return }
    if ($registry.tags['avm-state'] -cne 'Preparing' -or $registry.tags['avm-foundation-state'] -cne 'Running') {
        throw 'There is no recorded foundation operation to observe.'
    }
    . (Join-Path $Context.RepoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceDeployment' 'New-TemplateDeployment.ps1')
    $overallDeadline = [datetimeoffset]::Parse($registry.tags['avm-foundation-deadline'])
    $windowDeadline = ([datetimeoffset] (Get-Date)).AddMinutes(270)
    if ($overallDeadline -lt $windowDeadline) { $windowDeadline = $overallDeadline }
    $inputObject = @{
        DeploymentScope       = 'resourcegroup'
        DeploymentName        = $Context.Config.deploymentName
        SubscriptionId        = $Context.SubscriptionId
        ResourceGroupName     = $Context.Config.foundationResourceGroupName
        ExpectedDeploymentId  = $Context.DeploymentResourceId
        ExpectedCorrelationId = $registry.tags['avm-foundation-operation']
        RecoveryDeadlineUtc   = $windowDeadline.UtcDateTime
    }
    $before = Get-HciArmResource -ResourceId $Context.DeploymentResourceId -ApiVersion '2022-09-01'
    if ($before.properties.correlationId -ine $registry.tags['avm-foundation-operation']) {
        throw 'The foundation operation was replaced; observation cannot continue.'
    }
    try {
        $result = Wait-TemplateDeployment @inputObject
    } catch [System.TimeoutException] {
        if ($_.Exception.Data.Contains('ReadErrorRecord') -or [datetimeoffset] (Get-Date) -ge $overallDeadline) { throw }
        Write-Information 'The foundation is still pending; the next preparation job observes the same recorded operation.' -InformationAction Continue
        return
    }
    if ($result.ProvisioningState -cne 'Succeeded' -or $result.CorrelationId -ine $registry.tags['avm-foundation-operation']) {
        throw 'The recorded foundation operation did not succeed; no replacement or automatic destruction will occur.'
    }
    Set-HciEnvironmentState -Context $Context -Values @{ 'avm-foundation-state' = 'Provisioned' }
}

function Get-HciEnvironmentReadiness {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [hashtable] $Context,
        [bool] $ImageOnly = $false,
        [switch] $RefreshKubernetes
    )

    $registry = Get-HciEnvironmentRegistry -Context $Context
    if ($RefreshKubernetes -and
        ($registry.tags['avm-state'] -cne 'Preparing' -or $registry.tags['avm-active-owner'] -cne $Context.Owner)) {
        throw 'Kubernetes readiness refresh requires active setup ownership.'
    }
    if ($registry.tags['avm-state'] -cne 'Idle' -or $registry.tags['avm-active-owner']) {
        $registry = Get-HciEnvironmentRegistry -Context $Context -RequireOwner
    }
    if ($registry.tags['avm-image-state'] -cne 'Ready') { throw 'The image is not ready.' }
    Assert-HciImageReady -Context $Context
    foreach ($id in $Context.OwnedGroupIds) { $null = Get-HciOwnedGroup -Context $Context -ResourceId $id }
    $result = @{
        ImageVersionResourceId = $Context.ImageVersionResourceId
        ExternalImage          = $Context.ExternalImage
        OwnedResourceIds       = @($Context.GroupIds.control) + $Context.OwnedGroupIds
        Foundation             = $null
    }
    if ($ImageOnly) { return $result }
    if ($registry.tags['avm-foundation-state'] -cnotin @('Provisioned', 'Ready')) {
        throw 'The foundation is not provisioned; test consumers are blocked.'
    }
    $deployment = Get-HciArmResource -ResourceId $Context.DeploymentResourceId -ApiVersion '2022-09-01'
    if ($deployment.properties.provisioningState -cne 'Succeeded' -or
        $deployment.properties.correlationId -ine $registry.tags['avm-foundation-operation']) {
        throw 'The exact recorded foundation deployment is no longer successful.'
    }
    $foundation = $deployment.properties.outputs.environment.value
    $prefix = $Context.GroupIds.foundation
    $expected = @{
        clusterResourceId        = "$prefix/providers/Microsoft.AzureStackHCI/clusters/$($Context.Config.clusterName)"
        customLocationResourceId = "$prefix/providers/Microsoft.ExtendedLocation/customLocations/$($Context.Config.customLocationName)"
        logicalNetworkResourceId = "$prefix/providers/Microsoft.AzureStackHCI/logicalNetworks/$($Context.Config.logicalNetworkName)"
    }
    foreach ($entry in $expected.GetEnumerator()) {
        if ($foundation[$entry.Key] -ine $entry.Value) { throw "Foundation output [$($entry.Key)] does not match its registered identity." }
    }
    $cluster = Get-HciArmResource -ResourceId $expected.clusterResourceId -ApiVersion '2024-04-01'
    if ($cluster.properties.provisioningState -cne 'Succeeded' -or $cluster.properties.status -cne 'ConnectedRecently' -or
        $cluster.properties.connectivityStatus -cne 'Connected') {
        throw 'The Azure Local cluster is not provisioned and connected.'
    }
    if ($foundation.clusterNodeNames -isnot [array] -or $foundation.clusterNodeNames.Count -ne 1 -or $foundation.clusterNodeNames[0] -cne 'hcinode1') {
        throw 'The registered single-node foundation contract changed.'
    }
    $node = Get-HciArmResource -ResourceId "$prefix/providers/Microsoft.HybridCompute/machines/hcinode1" -ApiVersion '2024-07-10'
    if ($node.properties.status -cne 'Connected' -or $node.properties.provisioningState -cne 'Succeeded') {
        throw 'The Azure Local Arc node is not provisioned and connected.'
    }
    $customLocation = Get-HciArmResource -ResourceId $expected.customLocationResourceId -ApiVersion '2021-08-15'
    if ($customLocation.properties.provisioningState -cne 'Succeeded' -or
        $customLocation.properties.hostResourceId -notmatch "^$([regex]::Escape($prefix))/providers/Microsoft\.ResourceConnector/appliances/[a-z0-9_.()-]+$" -or
        -not $customLocation.properties.namespace -or @($customLocation.properties.clusterExtensionIds).Count -eq 0) {
        throw 'The custom location is not ready or does not point at an owned Arc resource bridge.'
    }
    $bridge = Get-HciArmResource -ResourceId $customLocation.properties.hostResourceId -ApiVersion '2022-10-27'
    if ($bridge.properties.provisioningState -cne 'Succeeded' -or $bridge.properties.status -cne 'Running') {
        throw 'The Arc resource bridge is not provisioned and running.'
    }
    foreach ($extensionId in $customLocation.properties.clusterExtensionIds) {
        if ($extensionId -notmatch "^$([regex]::Escape($bridge.id))/providers/Microsoft\.KubernetesConfiguration/extensions/[a-z0-9_.()-]+$") {
            throw 'A custom-location extension is outside the registered resource bridge.'
        }
        $extension = Get-HciArmResource -ResourceId $extensionId -ApiVersion '2023-05-01'
        if ($extension.properties.provisioningState -cne 'Succeeded') { throw 'A custom-location extension is not ready.' }
    }
    $network = Get-HciArmResource -ResourceId $expected.logicalNetworkResourceId -ApiVersion '2024-01-01'
    if ($network.properties.provisioningState -cne 'Succeeded' -or $network.extendedLocation.name -ine $expected.customLocationResourceId -or
        $network.properties.vmSwitchName -cne $foundation.vSwitchName -or
        @($network.properties.subnets | Where-Object { $_.properties.addressPrefix -ceq '172.20.0.0/24' -and $_.properties.ipAllocationMethod -ceq 'Static' }).Count -ne 1) {
        throw 'The shared Azure Local readiness network does not match the prepared topology.'
    }
    if ($RefreshKubernetes) {
        . (Join-Path $Context.AssetRoot 'Initialize-KubernetesVersionReadiness.ps1') -CustomLocationResourceId $expected.customLocationResourceId
        Set-HciEnvironmentState -Context $Context -Values @{
            'avm-foundation-state'   = 'Ready'
            'avm-kubernetes-version' = $DeploymentScriptOutputs.kubernetesVersion
        }
        $foundation.kubernetesVersion = $DeploymentScriptOutputs.kubernetesVersion
    } else {
        $foundation.kubernetesVersion = $registry.tags['avm-kubernetes-version']
        if ($foundation.kubernetesVersion -cnotmatch '^\d+\.\d+\.\d+$') { throw 'Kubernetes node-image readiness was not established.' }
    }
    $result.Foundation = $foundation
    return $result
}

function Enter-HciEnvironmentTest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [hashtable] $Context,
        [bool] $ImageOnly = $false
    )

    try {
        $registry = Get-HciEnvironmentRegistry -Context $Context -AllowNotFound
        if ($null -eq $registry) { throw 'The reserved environment has not been set up.' }
        if ($registry.tags['avm-state'] -cne 'Idle' -or $registry.tags['avm-active-owner']) {
            throw 'The reserved environment is not idle; unfinished setup, tests or cleanup must be resolved first.'
        }
        if ($registry.tags['avm-image-state'] -cne 'Ready' -or
            (-not $ImageOnly -and $registry.tags['avm-foundation-state'] -cne 'Ready')) {
            throw 'The required shared image or foundation is not ready.'
        }
        $result = Get-HciEnvironmentReadiness -Context $Context -ImageOnly:$ImageOnly
        Set-HciEnvironmentState -Context $Context -Acquire -Values @{
            'avm-state'        = 'InUse'
            'avm-active-owner' = $Context.Owner
        }
        return $result
    } catch [System.Management.Automation.RuntimeException] {
        throw [System.InvalidOperationException]::new(
            "The shared Azure Local environment cannot be used. Run the dedicated setup workflow [platform.hci.prepare.yml] after resolving this state: $($_.Exception.Message)",
            $_.Exception
        )
    }
}

function Exit-HciEnvironment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [hashtable] $Context,
        [bool] $CleanupConfirmed = $false,
        [bool] $Maintenance = $false
    )

    $registry = Get-HciEnvironmentRegistry -Context $Context -RequireOwner
    if (($Maintenance -and $registry.tags['avm-state'] -cne 'Preparing') -or
        (-not $Maintenance -and ($registry.tags['avm-state'] -cne 'InUse' -or -not $CleanupConfirmed))) {
        throw 'Environment ownership cannot be released without confirmed test cleanup or completed manual preparation.'
    }
    if ($registry.tags['avm-image-state'] -cne 'Ready' -or $registry.tags['avm-foundation-state'] -cin @('Submitting', 'Running')) {
        throw 'An unfinished preparation operation blocks release.'
    }
    Set-HciEnvironmentState -Context $Context -Values @{ 'avm-state' = 'Idle'; 'avm-active-owner' = '' }
}

. (Join-Path $PSScriptRoot 'HciTestEnvironment.ps1')

function Write-HciEnvironmentProjection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $RepoRootPath,
        [Parameter(Mandatory)] [string] $TestSubscriptionIds,
        [Parameter(Mandatory)] [ValidatePattern('^[a-f0-9]{64}$')] [string] $SubscriptionKey,
        [Parameter(Mandatory)] [guid] $TenantId,
        [Parameter(Mandatory)] [ValidatePattern('^[a-f0-9]{64}$')] [string] $Owner,
        [Parameter(Mandatory)] [string] $OutputPath,
        [bool] $ImageOnly = $false,
        [string] $GitHubVariables = '{}',
        [string] $GitHubSecrets = '{}',
        [string] $KeyVaultName
    )

    $repoRoot = [IO.Path]::GetFullPath($RepoRootPath)
    $normalizedOutputPath = [IO.Path]::GetFullPath($OutputPath)
    $comparison = $IsWindows ? [StringComparison]::OrdinalIgnoreCase : [StringComparison]::Ordinal
    $outputDirectory = [IO.Path]::GetDirectoryName($normalizedOutputPath)
    if (-not [IO.Path]::IsPathFullyQualified($OutputPath) -or
        [string]::Equals($normalizedOutputPath, $repoRoot, $comparison) -or
        $normalizedOutputPath.StartsWith("$repoRoot$([IO.Path]::DirectorySeparatorChar)", $comparison) -or
        -not (Test-Path -LiteralPath $outputDirectory -PathType Container) -or
        (Test-Path -LiteralPath $normalizedOutputPath)) {
        throw 'The HCI projection requires a new runner-local file outside the checkout.'
    }

    . (Join-Path $repoRoot 'utilities' 'pipelines' 'sharedScripts' 'Get-TestSubscriptionList.ps1')
    $reservationPath = 'avm/res/azure-stack-hci/logical-network'
    $selected = @(Get-TestSubscriptionList -TestSubscriptionIds $TestSubscriptionIds `
            -ModulePath $reservationPath -RepoRootPath $repoRoot |
            Where-Object { $_.key -ceq $SubscriptionKey -and $_.tag -ceq 'Azure Local' })
    if ($selected.Count -ne 1) {
        throw 'The projection caller did not select exactly one canonical Azure Local subscription.'
    }
    $subscription = $selected[0]

    $parameters = Get-HciEnvironmentParameterMap -GitHubVariables $GitHubVariables `
        -GitHubSecrets $GitHubSecrets -KeyVaultName $KeyVaultName
    $externalImageId = $parameters.hciHostImageReferenceId
    if ($externalImageId -is [securestring]) {
        $externalImageId = ([pscredential]::new('ci', $externalImageId)).GetNetworkCredential().Password
    }
    $context = Get-HciEnvironmentContext -RepoRootPath $repoRoot -SubscriptionId $subscription.id `
        -TenantId $TenantId -Owner $Owner -HciHostImageReferenceId $externalImageId
    $registry = Get-HciEnvironmentRegistry -Context $context -AllowNotFound
    if ($null -eq $registry) {
        throw 'The Azure Local fixture has not been provisioned.'
    }
    $state = [string] $registry.tags['avm-state']
    $generation = [string] $registry.tags['avm-generation']
    if ($state -cne 'Idle' -or $registry.tags['avm-active-owner'] -or
        $generation -cnotmatch '^[a-f0-9]{32}$') {
        throw "The Azure Local fixture is not idle and validated: [$state]."
    }
    $readiness = Get-HciEnvironmentReadiness -Context $context -ImageOnly:$ImageOnly

    $projection = [ordered] @{
        schemaVersion = 1
        environment = 'azure-local'
        state = $state
        generation = $generation
        subscriptionId = $subscription.id
        tenantId = $TenantId.ToString('D')
        location = $context.Config.location
        imageVersionResourceId = $readiness.ImageVersionResourceId
        externalImage = $readiness.ExternalImage
        imageOnly = $ImageOnly
    }
    if (-not $ImageOnly) {
        $projection.clusterResourceId = $readiness.Foundation.clusterResourceId
        $projection.customLocationResourceId = $readiness.Foundation.customLocationResourceId
        $projection.logicalNetworkResourceId = $readiness.Foundation.logicalNetworkResourceId
        $projection.vSwitchName = $readiness.Foundation.vSwitchName
        $projection.kubernetesVersion = $readiness.Foundation.kubernetesVersion
    }

    $projection | ConvertTo-Json -Depth 5 -Compress |
        Set-Content -LiteralPath $normalizedOutputPath -Encoding utf8NoBOM -ErrorAction Stop
    return $projection
}

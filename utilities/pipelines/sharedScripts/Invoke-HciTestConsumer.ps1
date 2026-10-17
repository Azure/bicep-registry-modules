. (Join-Path $PSScriptRoot 'HciTestEnvironment.ps1')
. (Join-Path $PSScriptRoot 'Get-CIParameterMap.ps1')
. (Join-Path $PSScriptRoot 'Get-ModuleDeploymentData.ps1')
. (Join-Path $PSScriptRoot '..' 'e2eValidation' 'resourceRemoval' 'helper' 'Remove-Deployment.ps1')

function Initialize-HciTestConsumer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $RepoRootPath,
        [Parameter(Mandatory)] [string] $ModulePath,
        [Parameter(Mandatory)] [hashtable] $TestCase,
        [Parameter(Mandatory)] [string] $TestSubscriptionIds,
        [Parameter(Mandatory)] [guid] $TenantId,
        [Parameter(Mandatory)] [string] $RunIdentity,
        [Parameter(Mandatory)] [string] $RunnerTempPath,
        [string] $GitHubVariables = '{}',
        [string] $GitHubSecrets = '{}',
        [string] $KeyVaultName
    )

    if ($TestCase.e2eIgnore -eq $true) { throw 'An ignored test cannot acquire shared environment ownership.' }
    $subscription = Get-HciTestSubscription -ModulePath $ModulePath -TestSubscriptionIds $TestSubscriptionIds `
        -SubscriptionIndex $TestCase.subscriptionIndex -SubscriptionKey $TestCase.subscriptionKey -RepoRootPath $RepoRootPath
    if ($TestCase.environmentConcurrencyGroup -cne "avm-hci-$($subscription.key)") {
        throw 'The consumer did not select the canonical shared-environment lock.'
    }
    $comparison = $IsWindows ? [StringComparison]::OrdinalIgnoreCase : [StringComparison]::Ordinal
    $repoRoot = [IO.Path]::GetFullPath($RepoRootPath)
    $moduleRoot = [IO.Path]::GetFullPath((Join-Path $repoRoot $ModulePath))
    $templatePath = [IO.Path]::GetFullPath((Join-Path $moduleRoot $TestCase.path))
    if (-not $templatePath.StartsWith("$moduleRoot$([IO.Path]::DirectorySeparatorChar)", $comparison)) {
        throw 'The reserved test file must be inside its selected module.'
    }
    if (-not [IO.Path]::IsPathFullyQualified($RunnerTempPath) -or
        -not (Test-Path -LiteralPath $RunnerTempPath -PathType Container) -or
        [string]::Equals([IO.Path]::GetFullPath($RunnerTempPath), $repoRoot, $comparison) -or
        [IO.Path]::GetFullPath($RunnerTempPath).StartsWith("$repoRoot$([IO.Path]::DirectorySeparatorChar)", $comparison)) {
        throw 'Consumer data requires an existing runner temporary directory outside the checkout.'
    }
    $contextFile = Join-Path $RunnerTempPath 'avm-hci-test-context.json'
    $dataFile = Join-Path $RunnerTempPath 'avm-module-deployment-data.json'
    if ((Test-Path -LiteralPath $contextFile) -or (Test-Path -LiteralPath $dataFile)) {
        throw 'Consumer data already exists; it will not be overwritten or reused.'
    }
    if ([IO.Path]::GetExtension($templatePath) -eq '.bicep') {
        $template = bicep build $templatePath --stdout | ConvertFrom-Json -AsHashtable
        if ($LASTEXITCODE -ne 0) { throw 'Failed to compile the reserved test template.' }
    } else {
        $template = Get-Content -LiteralPath $templatePath -Raw -ErrorAction Stop | ConvertFrom-Json -AsHashtable
    }
    $definitions = $template.parameters ?? @{}
    $imageOnly = $ModulePath -ceq 'avm/res/azure-stack-hci/cluster'
    if (-not $definitions.ContainsKey('resourceGroupName') -or
        ($imageOnly -and -not $definitions.ContainsKey('hciHostImageReferenceId')) -or
        (-not $imageOnly -and -not $definitions.ContainsKey('preparedHciEnvironment'))) {
        throw 'This reserved test is not wired to consume the prepared environment.'
    }
    $parameters = Get-CIParameterMap -TemplateParameters $definitions -TemplateDefinitions ($template.definitions ?? @{}) `
        -GitHubVariables $GitHubVariables -GitHubSecrets $GitHubSecrets -KeyVaultName $KeyVaultName
    $hciParameters = Get-HciEnvironmentParameterMap -GitHubVariables $GitHubVariables `
        -GitHubSecrets $GitHubSecrets -KeyVaultName $KeyVaultName
    $externalImageId = $hciParameters.hciHostImageReferenceId
    if ($externalImageId -is [securestring]) {
        $externalImageId = ([pscredential]::new('ci', $externalImageId)).GetNetworkCredential().Password
    }
    $owner = Get-HciEnvironmentKey -Value "$RunIdentity|$ModulePath|$($TestCase.path)"
    $context = Get-HciEnvironmentContext -RepoRootPath $RepoRootPath -SubscriptionId $subscription.id `
        -TenantId $TenantId -Owner $owner -HciHostImageReferenceId $externalImageId
    $testGroupName = "dep-avm-hci-$($owner.Substring(0, 20))"
    if ($parameters.resourceGroupName -and $parameters.resourceGroupName -cne $testGroupName) {
        throw 'Reserved Azure Local tests cannot override their per-run disposable resource group.'
    }
    $context.TestResourceGroupId = "/subscriptions/$($context.SubscriptionId)/resourceGroups/$testGroupName"
    $context | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $contextFile -Encoding utf8NoBOM

    $result = Enter-HciEnvironmentTest -Context $context -ImageOnly:$imageOnly
    $overrides = @{ resourceGroupName = $testGroupName }
    if ($definitions.ContainsKey('hciHostImageReferenceId')) {
        $overrides.hciHostImageReferenceId = $result.ImageVersionResourceId
    }
    if (-not $imageOnly) {
        $overrides.preparedHciEnvironment = @{
            customLocationResourceId = $result.Foundation.customLocationResourceId
            vSwitchName = $result.Foundation.vSwitchName
            kubernetesVersion = $result.Foundation.kubernetesVersion
        } | ConvertTo-Json -Compress
    }
    @{
        parameterOverrides = $overrides
        protectedResourceIds = @($context.GroupIds.control) + $context.OwnedGroupIds + @($context.ImageVersionResourceId)
    } | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $dataFile -Encoding utf8NoBOM
    $data = Get-ModuleDeploymentData -FilePath $dataFile
    $null = Resolve-ModuleDeploymentParameterOverride -ParameterOverrides $data.ParameterOverrides `
        -TemplateParameters $definitions -TemplateDefinitions ($template.definitions ?? @{})
}

function Complete-HciTestConsumer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $ContextFile,
        [string] $DeploymentOutcome = 'unknown',
        [string] $CleanupStatus = 'unknown'
    )

    if ($DeploymentOutcome -cne 'success' -or $CleanupStatus -cne 'confirmed') {
        throw "Shared environment ownership is retained: deployment outcome [$DeploymentOutcome], cleanup status [$CleanupStatus]. Resolve the failed or unconfirmed test before reuse."
    }
    $context = Get-Content -LiteralPath $ContextFile -Raw -ErrorAction Stop | ConvertFrom-Json -AsHashtable
    if ($context.Owner -cnotmatch '^[a-f0-9]{64}$' -or
        $context.TestResourceGroupId -cne "/subscriptions/$($context.SubscriptionId)/resourceGroups/dep-avm-hci-$($context.Owner.Substring(0, 20))") {
        throw 'The consumer context does not identify its exact disposable resource group.'
    }
    $registry = Get-HciEnvironmentRegistry -Context $context -RequireOwner
    if ($null -eq $registry -or $registry.tags['avm-state'] -cne 'InUse' -or
        $registry.tags['avm-active-owner'] -cne $context.Owner) {
        throw 'The shared environment is not owned by this test consumer.'
    }
    $absent = Test-CleanupResourceAbsent -ResourceId $context.TestResourceGroupId
    if ($absent -isnot [bool] -or -not $absent) {
        throw 'The disposable HCI test group was not confirmed absent; ownership is retained.'
    }
    Exit-HciEnvironment -Context $context -CleanupConfirmed:$true
}

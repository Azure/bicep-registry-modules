function Invoke-HciPreparationStep {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [ValidateSet('Begin', 'ImageObserve', 'FoundationStart', 'FoundationObserve', 'Ready')] [string] $Stage,
        [Parameter(Mandatory)] [string] $RepoRootPath,
        [Parameter(Mandatory)] [string] $ModulePath,
        [Parameter(Mandatory)] [hashtable] $TestCase,
        [Parameter(Mandatory)] [string] $TestSubscriptionIds,
        [Parameter(Mandatory)] [guid] $TenantId,
        [Parameter(Mandatory)] [string] $RunIdentity,
        [Parameter(Mandatory)] [string] $SourceCommit,
        [string] $GitHubVariables = '{}',
        [string] $GitHubSecrets = '{}',
        [string] $KeyVaultName,
        [bool] $Recreate = $false,
        [bool] $Maintenance = $false
    )

    . (Join-Path $PSScriptRoot 'HciTestEnvironment.ps1')
    $subscription = Get-HciTestSubscription -ModulePath $ModulePath -TestSubscriptionIds $TestSubscriptionIds `
        -SubscriptionIndex $TestCase.subscriptionIndex -SubscriptionKey $TestCase.subscriptionKey -RepoRootPath $RepoRootPath
    if ($TestCase.environmentConcurrencyGroup -cne "avm-hci-$($subscription.key)") {
        throw 'The preparation caller did not select the canonical shared-environment lock.'
    }
    $parameters = Get-HciEnvironmentParameterMap -GitHubVariables $GitHubVariables `
        -GitHubSecrets $GitHubSecrets -KeyVaultName $KeyVaultName
    $externalImageId = $parameters.hciHostImageReferenceId
    if ($externalImageId -is [securestring]) {
        $externalImageId = ([pscredential]::new('ci', $externalImageId)).GetNetworkCredential().Password
    }
    $context = Get-HciEnvironmentContext -RepoRootPath $RepoRootPath -SubscriptionId $subscription.id -TenantId $TenantId `
        -Owner (Get-HciEnvironmentKey -Value "$RunIdentity|$ModulePath|$($TestCase.path)") -HciHostImageReferenceId $externalImageId
    $imageOnly = $ModulePath -ceq 'avm/res/azure-stack-hci/cluster' -and -not $Maintenance
    if ($Stage -eq 'Begin') {
        foreach ($name in @('arbLocalAdminAndDeploymentUserPass', 'arbDeploymentAppId', 'arbDeploymentSPObjectId', 'arbDeploymentServicePrincipalSecret')) {
            if (-not $parameters.ContainsKey($name) -or $parameters[$name].Length -eq 0) {
                throw "Required existing CI credential [$name] is missing; preparation has not started."
            }
        }
        $providers = @(
            'Microsoft.Compute', 'Microsoft.VirtualMachineImages', 'Microsoft.ManagedIdentity',
            'Microsoft.Network', 'Microsoft.Storage', 'Microsoft.KeyVault', 'Microsoft.Maintenance',
            'Microsoft.ContainerInstance', 'Microsoft.AzureStackHCI', 'Microsoft.HybridCompute',
            'Microsoft.GuestConfiguration', 'Microsoft.HybridConnectivity', 'Microsoft.ResourceConnector',
            'Microsoft.ExtendedLocation', 'Microsoft.KubernetesConfiguration', 'Microsoft.HybridContainerService'
        )
        foreach ($provider in $providers) {
            $record = @(Get-AzResourceProvider -ProviderNamespace $provider -ErrorAction Stop)
            if ($record.Count -ne 1 -or $record[0].RegistrationState -cne 'Registered') {
                throw "Required provider [$provider] is not registered in the reserved subscription. Complete approved subscription preparation first."
            }
        }
    }
    switch ($Stage) {
        'Begin' {
            Start-HciEnvironmentPreparation -Context $context -SourceCommit $SourceCommit -Recreate:$Recreate -Maintenance:$Maintenance
        }
        'ImageObserve' {
            Wait-HciEnvironmentImage -Context $context -SourceCommit $SourceCommit
        }
        'FoundationStart' {
            if (-not $imageOnly -and -not $parameters.builtInServicePrincipalObjectId) {
                $servicePrincipals = @(Get-AzADServicePrincipal -ApplicationId '1412d89f-b8a8-4111-b4fd-e82905cbd85d' -ErrorAction Stop)
                if ($servicePrincipals.Count -ne 1 -or -not $servicePrincipals[0].Id) {
                    throw 'The existing Azure Stack HCI resource-provider service principal could not be resolved.'
                }
                $parameters.builtInServicePrincipalObjectId = $servicePrincipals[0].Id
            }
            Start-HciEnvironmentFoundation -Context $context -Parameters $parameters -ImageOnly:$imageOnly
        }
        'FoundationObserve' {
            Wait-HciEnvironmentFoundation -Context $context -ImageOnly:$imageOnly
        }
        'Ready' {
            $result = Get-HciEnvironmentReadiness -Context $context -ImageOnly:$imageOnly -RefreshKubernetes
            if ($Maintenance) { Exit-HciEnvironment -Context $context -Maintenance:$true }
            return $result
        }
    }
}

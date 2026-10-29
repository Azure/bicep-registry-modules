. (Join-Path $PSScriptRoot 'HciTestEnvironment.ps1')
. (Join-Path $PSScriptRoot '..' 'platform' 'deploymentRemoval' 'Clear-SubscriptionDeploymentHistory.ps1')

function Invoke-HciDeploymentHistoryCleanup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $RepoRootPath,
        [Parameter(Mandatory)] [hashtable] $TestCase,
        [Parameter(Mandatory)] [string] $TestSubscriptionIds,
        [Parameter(Mandatory)] [guid] $TenantId,
        [Parameter(Mandatory)] [string] $RunIdentity,
        [string] $GitHubVariables = '{}',
        [string] $GitHubSecrets = '{}',
        [string] $KeyVaultName,
        [int] $MaxDeploymentRetentionInDays = 14
    )

    $subscription = Get-HciTestSubscription -ModulePath 'avm/res/azure-stack-hci/cluster' `
        -TestSubscriptionIds $TestSubscriptionIds -SubscriptionIndex $TestCase.subscriptionIndex `
        -SubscriptionKey $TestCase.subscriptionKey -RepoRootPath $RepoRootPath
    if ($TestCase.environmentConcurrencyGroup -cne "avm-hci-$($subscription.key)") {
        throw 'History maintenance requires the canonical shared-environment lock.'
    }
    $parameters = Get-HciEnvironmentParameterMap -GitHubVariables $GitHubVariables `
        -GitHubSecrets $GitHubSecrets -KeyVaultName $KeyVaultName
    $externalImageId = $parameters.hciHostImageReferenceId
    if ($externalImageId -is [securestring]) {
        $externalImageId = ([pscredential]::new('ci', $externalImageId)).GetNetworkCredential().Password
    }
    $context = Get-HciEnvironmentContext -RepoRootPath $RepoRootPath -SubscriptionId $subscription.id -TenantId $TenantId `
        -Owner (Get-HciEnvironmentKey -Value "$RunIdentity|history|$($subscription.key)") -HciHostImageReferenceId $externalImageId
    $registry = Get-HciEnvironmentRegistry -Context $context -AllowNotFound
    if ($null -eq $registry) {
        foreach ($id in $context.OwnedGroupIds) {
            if ($null -ne (Get-HciOwnedGroup -Context $context -ResourceId $id -AllowNotFound)) {
                throw 'Unregistered shared resources exist; their deployment history must be preserved.'
            }
        }
    } else {
        if ($registry.tags['avm-state'] -cne 'Idle' -or $registry.tags['avm-active-owner'] -or
            $registry.tags['avm-image-state'] -cne 'Ready' -or
            $registry.tags['avm-foundation-state'] -cnotin @('None', 'Provisioned', 'Ready')) {
            throw 'Active or unconfirmed shared-environment state blocks history cleanup; teardown evidence is preserved.'
        }
        Set-HciEnvironmentState -Context $context -Acquire -Values @{
            'avm-state' = 'Preparing'
            'avm-active-owner' = $context.Owner
        }
    }
    Clear-SubscriptionDeploymentHistory -SubscriptionId $subscription.id `
        -MaxDeploymentRetentionInDays $MaxDeploymentRetentionInDays -WaitForCompletion
    if ($null -ne $registry) {
        Exit-HciEnvironment -Context $context -Maintenance:$true
    }
}

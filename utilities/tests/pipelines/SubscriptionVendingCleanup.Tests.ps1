param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Subscription vending cleanup target' {
    BeforeAll {
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceRemoval' 'Invoke-ModuleDeploymentCleanup.ps1')
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceRemoval' 'helper' 'Invoke-ResourceRemoval.ps1')
        function Invoke-ResourceLockRemoval {
            param()
        }
    }

    It 'derives the isolated target during ordinary BAMI cleanup' {
        Mock Initialize-DeploymentRemoval { @{} }

        Invoke-ModuleDeploymentCleanup -TemplateFilePath 'main.bicep' -DeploymentNames 'test' -ManagementGroupId 'avm-subscription-vending'

        Should -Invoke Initialize-DeploymentRemoval -Times 1 -Exactly -ParameterFilter {
            $SubscriptionCleanupManagementGroupId -eq 'avm-subscription-vending'
        }
    }

    It 'rejects a mismatched BAMI target before cleanup begins' {
        Mock Initialize-DeploymentRemoval {}

        { Invoke-ModuleDeploymentCleanup -TemplateFilePath 'main.bicep' -DeploymentNames 'test' -ManagementGroupId 'avm-subscription-vending' -SubscriptionCleanupManagementGroupId 'other' } |
            Should -Throw '*isolated avm-subscription-vending*'
        Should -Invoke Initialize-DeploymentRemoval -Times 0 -Exactly
    }

    It 'uses the legacy target when the optional target is omitted or empty' -ForEach @(
        @{ Target = $null }
        @{ Target = '' }
    ) {
        Mock Invoke-ResourceLockRemoval {}
        Mock Get-AzSubscription { @{ Id = '11111111-1111-1111-1111-111111111111'; Name = 'dep-sub-blzv-tests'; State = 'Disabled' } }
        Mock Select-AzSubscription {}
        Mock Get-AzResourceGroup { $null }
        Mock Get-AzManagementGroupSubscription {}
        Mock New-AzManagementGroupSubscription {}

        Invoke-ResourceRemoval -Type 'Microsoft.Subscription/aliases' -ResourceId '/providers/Microsoft.Subscription/aliases/dep-sub-blzv-tests' -SubscriptionCleanupManagementGroupId $Target -Confirm:$false

        Should -Invoke New-AzManagementGroupSubscription -Times 1 -Exactly -ParameterFilter { $GroupName -eq 'bicep-lz-vending-automation-decom' }
    }

    It 'uses the BAMI target and rejects legacy BAMI target before mutation' {
        Mock Invoke-ResourceLockRemoval {}
        Mock Get-AzSubscription { @{ Id = '11111111-1111-1111-1111-111111111111'; Name = 'dep-sub-blzv-tests'; State = 'Disabled' } }
        Mock Select-AzSubscription {}
        Mock Get-AzResourceGroup { $null }
        Mock Get-AzManagementGroupSubscription {}
        Mock New-AzManagementGroupSubscription {}

        Invoke-ResourceRemoval -Type 'Microsoft.Subscription/aliases' -ResourceId '/providers/Microsoft.Subscription/aliases/dep-sub-blzv-tests' -SubscriptionCleanupManagementGroupId 'avm-subscription-vending' -Confirm:$false
        Should -Invoke New-AzManagementGroupSubscription -Times 1 -Exactly -ParameterFilter { $GroupName -eq 'avm-subscription-vending' }

        { Invoke-ResourceRemoval -Type 'Microsoft.Subscription/aliases' -ResourceId '/providers/Microsoft.Subscription/aliases/dep-sub-blzv-tests' -SubscriptionCleanupManagementGroupId 'bicep-lz-vending-automation-decom' -Confirm:$false } |
            Should -Throw '*must not use the legacy*'
        Should -Invoke Select-AzSubscription -Times 1 -Exactly
    }

    It 'does not mutate the subscription in WhatIf mode' {
        Mock Invoke-ResourceLockRemoval {}
        Mock Select-AzSubscription {}
        Mock New-AzManagementGroupSubscription {}

        Invoke-ResourceRemoval -Type 'Microsoft.Subscription/aliases' -ResourceId '/providers/Microsoft.Subscription/aliases/dep-sub-blzv-tests' -SubscriptionCleanupManagementGroupId 'avm-subscription-vending' -WhatIf

        Should -Invoke Select-AzSubscription -Times 0 -Exactly
        Should -Invoke New-AzManagementGroupSubscription -Times 0 -Exactly
    }
}

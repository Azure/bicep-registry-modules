param(
    [Parameter(Mandatory = $false)]
    [string] $repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent.Parent.FullName
)

$script:repoRootPath = $repoRootPath

Describe 'Test sequence ordering' {

    BeforeEach {
        . (Join-Path $repoRootPath 'avm' 'utilities' 'pipelines' 'e2eValidation' 'resourceRemoval' 'helper' 'Get-OrderedResourcesList.ps1')
    }

    It 'Remove first sequence should be as expected' {

        $orderListInputObject = @{
            ResourcesToOrder    = @(
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mySa/blobServices/default'
                    type       = 'Microsoft.Storage/storageAccounts/blobServices'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/mySubnet'
                    type       = 'Microsoft.Network/virtualNetworks/subnets'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mySa'
                    type       = 'Microsoft.Storage/storageAccounts'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/myVnet'
                    type       = 'Microsoft.Network/virtualNetworks'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Authorization/roleAssignments/2-2-2-2-2'
                    type       = 'Microsoft.Authorization/roleAssignments'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/networkSecurityGroups/myNsg'
                    type       = 'Microsoft.Network/networkSecurityGroups'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myMsi'
                    type       = 'Microsoft.ManagedIdentity/userAssignedIdentities'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/providers/Microsoft.Authorization/roleAssignments/4-4-4-4-4'
                    type       = 'Microsoft.Authorization/roleAssignments'
                }
                @{
                    resourceId = '/providers/Microsoft.Subscription/aliases/mySub'
                    type       = 'Microsoft.Subscription/aliases'
                }
                @{
                    resourceId = '/providers/Microsoft.Management/managementGroups/myMg/subscriptions/1-1-1-1-1'
                    type       = 'bicep-lz-vending-automation-child/subscriptions'
                }
            )
            RemoveFirstSequence = @(
                'Microsoft.Authorization/roleAssignments',
                'Microsoft.ManagedIdentity/userAssignedIdentities'
                'Microsoft.Storage/storageAccounts'
            )
            RemoveLastSequence  = @()
        }
        $orderedList = Get-OrderedResourcesList @orderListInputObject

        $orderedList.resourceId | Should -Be @(
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Authorization/roleAssignments/2-2-2-2-2',
            '/subscriptions/1-1-1-1-1/providers/Microsoft.Authorization/roleAssignments/4-4-4-4-4',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myMsi',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mySa',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mySa/blobServices/default',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/mySubnet',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/myVnet',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/networkSecurityGroups/myNsg',
            '/providers/Microsoft.Subscription/aliases/mySub',
            '/providers/Microsoft.Management/managementGroups/myMg/subscriptions/1-1-1-1-1'
        )
    }
    It 'Remove last sequence should be as expected' {

        $orderListInputObject = @{
            ResourcesToOrder    = @(
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mySa/blobServices/default'
                    type       = 'Microsoft.Storage/storageAccounts/blobServices'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/mySubnet'
                    type       = 'Microsoft.Network/virtualNetworks/subnets'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mySa'
                    type       = 'Microsoft.Storage/storageAccounts'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/myVnet'
                    type       = 'Microsoft.Network/virtualNetworks'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Authorization/roleAssignments/2-2-2-2-2'
                    type       = 'Microsoft.Authorization/roleAssignments'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/networkSecurityGroups/myNsg'
                    type       = 'Microsoft.Network/networkSecurityGroups'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myMsi'
                    type       = 'Microsoft.ManagedIdentity/userAssignedIdentities'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/providers/Microsoft.Authorization/roleAssignments/4-4-4-4-4'
                    type       = 'Microsoft.Authorization/roleAssignments'
                }
                @{
                    resourceId = '/providers/Microsoft.Subscription/aliases/mySub'
                    type       = 'Microsoft.Subscription/aliases'
                }
                @{
                    resourceId = '/providers/Microsoft.Management/managementGroups/myMg/subscriptions/1-1-1-1-1'
                    type       = 'bicep-lz-vending-automation-child/subscriptions'
                }
            )
            RemoveFirstSequence = @()
            RemoveLastSequence  = @(
                'Microsoft.Authorization/roleAssignments',
                'Microsoft.ManagedIdentity/userAssignedIdentities'
                'Microsoft.Storage/storageAccounts',
                'Microsoft.Subscription/aliases'
            )
        }
        $orderedList = Get-OrderedResourcesList @orderListInputObject

        $orderedList.resourceId | Should -Be @(
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mySa/blobServices/default',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/mySubnet',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/myVnet',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/networkSecurityGroups/myNsg',
            '/providers/Microsoft.Management/managementGroups/myMg/subscriptions/1-1-1-1-1',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Authorization/roleAssignments/2-2-2-2-2',
            '/subscriptions/1-1-1-1-1/providers/Microsoft.Authorization/roleAssignments/4-4-4-4-4',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myMsi',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mySa'
            '/providers/Microsoft.Subscription/aliases/mySub'
        )
    }

    It 'Remove sequence should be as expected if both first & last priorities are provided' {

        $orderListInputObject = @{
            ResourcesToOrder    = @(
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mySa/blobServices/default'
                    type       = 'Microsoft.Storage/storageAccounts/blobServices'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/mySubnet'
                    type       = 'Microsoft.Network/virtualNetworks/subnets'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mySa'
                    type       = 'Microsoft.Storage/storageAccounts'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/myVnet'
                    type       = 'Microsoft.Network/virtualNetworks'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Authorization/roleAssignments/2-2-2-2-2'
                    type       = 'Microsoft.Authorization/roleAssignments'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/networkSecurityGroups/myNsg'
                    type       = 'Microsoft.Network/networkSecurityGroups'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myMsi'
                    type       = 'Microsoft.ManagedIdentity/userAssignedIdentities'
                }
                @{
                    resourceId = '/providers/Microsoft.Subscription/aliases/mySub'
                    type       = 'Microsoft.Subscription/aliases'
                }
                @{
                    resourceId = '/subscriptions/1-1-1-1-1/providers/Microsoft.Authorization/roleAssignments/4-4-4-4-4'
                    type       = 'Microsoft.Authorization/roleAssignments'
                }
            )
            RemoveFirstSequence = @(
                'Microsoft.Authorization/roleAssignments',
                'Microsoft.ManagedIdentity/userAssignedIdentities'
            )
            RemoveLastSequence  = @(
                'Microsoft.Storage/storageAccounts/blobServices',
                'Microsoft.Storage/storageAccounts'
                'Microsoft.Subscription/aliases'
            )
        }
        $orderedList = Get-OrderedResourcesList @orderListInputObject

        $orderedList.resourceId | Should -Be @(
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Authorization/roleAssignments/2-2-2-2-2',
            '/subscriptions/1-1-1-1-1/providers/Microsoft.Authorization/roleAssignments/4-4-4-4-4',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myMsi',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/mySubnet',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/myVnet',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Network/networkSecurityGroups/myNsg',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mySa/blobServices/default',
            '/subscriptions/1-1-1-1-1/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mySa',
            '/providers/Microsoft.Subscription/aliases/mySub'
        )
    }
}

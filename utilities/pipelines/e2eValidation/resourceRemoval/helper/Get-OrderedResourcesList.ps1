<#
.SYNOPSIS
Order the given resources as per the provided ordered resource type list

.DESCRIPTION
Order the given resources as per the provided ordered resource type list.
Any resources not in that list will be appended after.

.PARAMETER ResourcesToOrder
Mandatory. The resources to order. Items are stacked as per their order in the list (i.e. the first items is put on top, then the next, etc.)
Each item should be in format:
@{
    name        = '...'
    resourceID = '...'
    type        = '...'
}

.PARAMETER RemoveFirstSequence
Optional. The order of resource types to remove before all others. If no sequence is provided, the list is returned as is

.PARAMETER RemoveLastSequence
Optional. The order of resource types to remove after all others. If no sequence is provided, the list is returned as is

.EXAMPLE
Get-OrderedResourcesList -ResourcesToOrder @(@{ name = 'myAccount'; resourceId '(..)/Microsoft.Automation/automationAccounts/myAccount'; type = 'Microsoft.Automation/automationAccounts'}) -RemoveFirstSequence @('Microsoft.Insights/diagnosticSettings','Microsoft.Automation/automationAccounts')

Order the given list of resources which would put the diagnostic settings to the front of the list, then the automation account, then the rest. As only one item exists, the list is returned as is.
#>
function Get-OrderedResourcesList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable[]] $ResourcesToOrder,

        [Parameter(Mandatory = $false)]
        [string[]] $RemoveFirstSequence = @(),

        [Parameter(Mandatory = $false)]
        [string[]] $RemoveLastSequence = @()
    )

    # Order resources to remove first. Going from back to front of the list to stack in the correct order
    for ($orderIndex = ($RemoveFirstSequence.Count - 1); $orderIndex -ge 0; $orderIndex--) {
        $searchItem = $RemoveFirstSequence[$orderIndex]
        if ($elementsContained = $resourcesToOrder | Where-Object { $_.type -eq $searchItem }) {
            $resourcesToOrder = @() + $elementsContained + ($resourcesToOrder | Where-Object { $_.type -ne $searchItem })
        }
    }

    # Order resources to remove last. Going from front to back of the list to stack in the correct order
    for ($orderIndex = 0; $orderIndex -lt $RemoveLastSequence.Count; $orderIndex++) {
        $searchItem = $RemoveLastSequence[$orderIndex]
        if ($elementsContained = $resourcesToOrder | Where-Object { $_.type -eq $searchItem }) {
            $resourcesToOrder = @() + ($resourcesToOrder | Where-Object { $_.type -ne $searchItem }) + $elementsContained
        }
    }

    return $resourcesToOrder
}

$RemoveFirstSequence = @(
    'Microsoft.Authorization/locks',
    'Microsoft.VirtualMachineImages/imageTemplates', # Must be removed before their MSI & should be removed before its entities permissions are removed
    'Microsoft.DevOpsInfrastructure/pools' # Must be removed before vnet role assignments and other resources it depends on like a virtual network
    'Microsoft.Authorization/roleAssignments',
    'Microsoft.Insights/diagnosticSettings',
    'Microsoft.Network/privateEndpoints/privateDnsZoneGroups',
    'Microsoft.Network/privateEndpoints',
    'Microsoft.Network/virtualHubs/routingIntent', # Must be deleted before e.g., an Azure Firewall that it is referencing
    'Microsoft.Network/azureFirewalls', # Must be deleted before e.g., a Virtual Hub that it is using.
    'Microsoft.Network/expressRouteGateways', # Must be deleted before the Virtual Hub it is attached to
    'Microsoft.Network/vpnGateways', # Must be deleted before the Virtual Hub it is attached to
    'Microsoft.Network/p2sVpnGateways', # Must be deleted before the Virtual Hub it is attached to
    'Microsoft.Network/virtualHubs',
    'Microsoft.Network/virtualWans',
    'Microsoft.OperationsManagement/solutions',
    'Microsoft.OperationalInsights/workspaces/linkedServices',
    'Microsoft.OperationalInsights/workspaces',
    'Microsoft.KeyVault/vaults',
    'Microsoft.Authorization/policyExemptions',
    'Microsoft.Authorization/policyAssignments',
    'Microsoft.Authorization/policySetDefinitions',
    'Microsoft.Authorization/policyDefinitions'
    'Microsoft.Sql/managedInstances',
    'Microsoft.MachineLearningServices/workspaces',
    'Microsoft.Compute/virtualMachines',
    'Microsoft.ContainerInstance/containerGroups' # Must be removed before their MSI
    'Microsoft.ManagedIdentity/userAssignedIdentities',
    'Microsoft.Databricks/workspaces',
    'Microsoft.NetApp/netAppAccounts/capacityPools/volumes', # Must be deleted before netapp account capacity pool & attached policies because if any policies are linked to a volume their removal with fail
    'Microsoft.NetApp/netAppAccounts/backupPolicies', # Must be deleted before netapp volume backup can be removed because the Resource Provider does not allow deleting the account as long as it has nested resources
    'Microsoft.NetApp/netAppAccounts/backupVaults/backups', # Must be deleted before netapp account backup vault because you cannot delete a backup vault while it still contains backups
    'Microsoft.NetApp/netAppAccounts/backupVaults', # Must be deleted before netapp account because the Resource Provider does not allow deleting the account as long as it has nested resources
    'Microsoft.NetApp/netAppAccounts/snapshotPolicies', # Must be deleted before netapp account because the Resource Provider does not allow deleting the account as long as it has nested resources
    'Microsoft.NetApp/netAppAccounts/capacityPools', # Must be deleted before netapp account because the Resource Provider does not allow deleting the account as long as it has nested resources
    'Microsoft.Network/virtualNetworkGateways', # Must be deleted before the Public IP that is associated with it
    'Microsoft.Network/loadBalancers', # Must be deleted before e.g. a GatewaySubnet that is associated with it
    'Microsoft.DataProtection/backupVaults', # This resource has a custom removal logic and hence needs to be deleted before its resource group
    'Microsoft.CognitiveServices/accounts/projects',
    'Microsoft.CognitiveServices/accounts',
    'Microsoft.KeyVault/managedHSMs/keys', # Should be deleted before e.g. a SQL server that is associated with it to avoid issues with access token expiration
    'Microsoft.Sql/servers/databases', # Should be deleted before its parent SQL server to save time during removal
    'Microsoft.Sql/servers',
    'Microsoft.Cdn/profiles',
    'Microsoft.Resources/resourceGroups'
)
$rawTargetResourceIdsToRemove = @(
    '/subscriptions/3f0ec788-73ce-4285-9a30-1deb2337a88e/resourceGroups/dep-avmx-network.expressRouteGateway-nergwaf-rg/providers/Microsoft.Network/virtualHubs/dep-avmx-hub-nergwaf',
    '/subscriptions/3f0ec788-73ce-4285-9a30-1deb2337a88e/resourceGroups/dep-avmx-network.expressRouteGateway-nergwaf-rg/providers/Microsoft.Network/virtualWans/dep-avmx-vwan-nergwaf',
    '/subscriptions/3f0ec788-73ce-4285-9a30-1deb2337a88e/resourceGroups/dep-avmx-network.expressRouteGateway-nergwaf-rg',
    '/subscriptions/3f0ec788-73ce-4285-9a30-1deb2337a88e/resourceGroups/dep-avmx-network.expressRouteGateway-nergwaf-rg/providers/Microsoft.Network/expressRouteGateways/avmxnergwaf001'
)

. 'C:\dev\ip\bicep-registry-modules\Upstream-Azure\utilities\pipelines\e2eValidation\resourceRemoval\helper\Get-ResourceIdsAsFormattedObjectList.ps1'
[array] $resourcesToRemove = Get-ResourceIdsAsFormattedObjectList -ResourceIds $rawTargetResourceIdsToRemove

$resourceIdsToIgnore = @(
    '/subscriptions/{0}/resourceGroups/NetworkWatcherRG' -f $azContext.Subscription.Id
)

# Resource IDs starting with a prefix in the below list are ignored by the removal
$resourceIdPrefixesToIgnore = @(
    '/subscriptions/{0}/providers/Microsoft.Security/autoProvisioningSettings/' -f $azContext.Subscription.Id
    '/subscriptions/{0}/providers/Microsoft.Security/deviceSecurityGroups/' -f $azContext.Subscription.Id
    '/subscriptions/{0}/providers/Microsoft.Security/iotSecuritySolutions/' -f $azContext.Subscription.Id
    '/subscriptions/{0}/providers/Microsoft.Security/pricings/' -f $azContext.Subscription.Id
    '/subscriptions/{0}/providers/Microsoft.Security/securityContacts/' -f $azContext.Subscription.Id
    '/subscriptions/{0}/providers/Microsoft.Security/workspaceSettings/' -f $azContext.Subscription.Id
)
[regex] $ignorePrefix_regex = '(?i)^(' + (($resourceIdPrefixesToIgnore | ForEach-Object { [regex]::escape($_) }) -join '|') + ')'


if ($resourcesToIgnore = $resourcesToRemove | Where-Object { $_.resourceId -in $resourceIdsToIgnore -or $_.resourceId -match $ignorePrefix_regex }) {
    Write-Verbose 'Resources excluded from removal:' -Verbose
    $resourcesToIgnore | ForEach-Object { Write-Verbose ('- Ignore [{0}]' -f $_.resourceId) -Verbose }
}

[array] $resourcesToRemove = $resourcesToRemove | Where-Object { $_.resourceId -notin $resourceIdsToIgnore -and $_.resourceId -notmatch $ignorePrefix_regex }
Write-Verbose ('Total number of deployments after filtering all dependency resources [{0}]' -f $resourcesToRemove.Count) -Verbose


$removeLastSequence = @(
    'Microsoft.Subscription/aliases'
)

$orderListInputObject = @{
    ResourcesToOrder    = $resourcesToRemove
    RemoveFirstSequence = $RemoveFirstSequence
    RemoveLastSequence  = $RemoveLastSequence
}
[array] $resourcesToRemove = Get-OrderedResourcesList @orderListInputObject
$resourcesToRemove.resourceId

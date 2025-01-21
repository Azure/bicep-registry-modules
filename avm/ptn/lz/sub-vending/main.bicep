metadata name = 'Sub-vending'
metadata description = 'This module deploys a subscription to accelerate deployment of landing zones. For more information on how to use it, please visit this [Wiki](https://github.com/Azure/bicep-lz-vending/wiki).'
metadata details = '''These are the input parameters for the Bicep module: [`main.bicep`](./main.bicep)

This is the orchestration module that is used and called by a consumer of the module to deploy a Landing Zone Subscription and its associated resources, based on the parameter input values that are provided to it at deployment time.

> For more information and examples please see the [wiki](https://github.com/Azure/bicep-lz-vending/wiki)'''

targetScope = 'managementGroup'

//Imports
import { roleAssignmentType } from 'modules/subResourceWrapper.bicep'

// PARAMETERS

// Subscription Parameters
@description('''Optional. Whether to create a new Subscription using the Subscription Alias resource. If `false`, supply an existing Subscription''s ID in the parameter named `existingSubscriptionId` instead to deploy resources to an existing Subscription.''')
param subscriptionAliasEnabled bool = true

@maxLength(63)
@description('''Optional. The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, - and _. The maximum length is 63 characters.

The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.

> The value for this parameter and the parameter named `subscriptionAliasName` are usually set to the same value for simplicity. But they can be different if required for a reason.

> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.
''')
param subscriptionDisplayName string = ''

@maxLength(63)
@description('''Optional. The name of the Subscription Alias, that will be created by this module.

The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.

> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.
''')
param subscriptionAliasName string = ''

@description('''Optional. The Billing Scope for the new Subscription alias, that will be created by this module.

A valid Billing Scope looks like `/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts/{enrollmentAccountName}` and is case sensitive.

> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.
''')
param subscriptionBillingScope string = ''

@allowed([
  'DevTest'
  'Production'
])
@description('''Optional. The workload type can be either `Production` or `DevTest` and is case sensitive.

> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.
''')
param subscriptionWorkload string = 'Production'

@maxLength(36)
@description('''Optional. The Azure Active Directory Tenant ID (GUID) to which the Subscription should be attached to.

> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants)**.''')
param subscriptionTenantId string = ''

@maxLength(36)
@description('''Optional. The Azure Active Directory principals object ID (GUID) to whom should be the Subscription Owner.

> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants)**.''')
param subscriptionOwnerId string = ''

@maxLength(36)
@description('''Optional. An existing subscription ID. Use this when you do not want the module to create a new subscription. But do want to manage the management group membership. A subscription ID should be provided in the example format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.''')
param existingSubscriptionId string = ''

// Subscription Resources Wrapper Parameters
@description('''Optional. Whether to move the Subscription to the specified Management Group supplied in the parameter `subscriptionManagementGroupId`.
''')
param subscriptionManagementGroupAssociationEnabled bool = true

@description('''Optional. The destination Management Group ID for the new Subscription that will be created by this module (or the existing one provided in the parameter `existingSubscriptionId`).

**IMPORTANT:** Do not supply the display name of the Management Group. The Management Group ID forms part of the Azure Resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.
''')
param subscriptionManagementGroupId string = ''

@description('''Optional. An object of Tag key & value pairs to be appended to a Subscription.

> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.
''')
param subscriptionTags object = {}

@description('''Optional. Whether to create a Virtual Network or not.

If set to `true` ensure you also provide values for the following parameters at a minimum:

- `virtualNetworkResourceGroupName`
- `virtualNetworkResourceGroupLockEnabled`
- `virtualNetworkLocation`
- `virtualNetworkName`
- `virtualNetworkAddressSpace`

> Other parameters may need to be set based on other parameters that you enable that are listed above. Check each parameters documentation for further information.
''')
param virtualNetworkEnabled bool = false

@maxLength(90)
@description('''Optional. The name of the Resource Group to create the Virtual Network in that is created by this module.
''')
param virtualNetworkResourceGroupName string = ''

@description('''Optional. An object of Tag key & value pairs to be appended to the Resource Group that the Virtual Network is created in.

> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.
''')
param virtualNetworkResourceGroupTags object = {}

@description('''Optional. Enables the deployment of a `CanNotDelete` resource locks to the Virtual Networks Resource Group that is created by this module.
''')
param virtualNetworkResourceGroupLockEnabled bool = true

@description('''Optional. The location of the virtual network. Use region shortnames e.g. `uksouth`, `eastus`, etc. Defaults to the region where the ARM/Bicep deployment is targeted to unless overridden.
''')
param virtualNetworkLocation string = deployment().location

@minLength(2)
@maxLength(64)
@description('''Optional. The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.
''')
param virtualNetworkName string?

@description('''Optional. An object of tag key/value pairs to be set on the Virtual Network that is created.

> **NOTE:** Tags will be overwritten on resource if any exist already.
''')
param virtualNetworkTags object = {}

@description('''Optional. The address space of the Virtual Network that will be created by this module, supplied as multiple CIDR blocks in an array, e.g. `["10.0.0.0/16","172.16.0.0/12"]`.''')
param virtualNetworkAddressSpace array = []

@description('''Optional. The custom DNS servers to use on the Virtual Network, e.g. `["10.4.1.4", "10.2.1.5"]`. If left empty (default) then Azure DNS will be used for the Virtual Network.
''')
param virtualNetworkDnsServers array = []

@description('''Optional. The resource ID of an existing DDoS Network Protection Plan that you wish to link to this Virtual Network.
''')
param virtualNetworkDdosPlanResourceId string = ''

@description('''Optional. Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.
''')
param virtualNetworkPeeringEnabled bool = false

@description('''Optional. The resource ID of the Virtual Network or Virtual WAN Hub in the hub to which the created Virtual Network, by this module, will be peered/connected to via Virtual Network Peering or a Virtual WAN Virtual Hub Connection.
''')
param hubNetworkResourceId string = ''

@description('''Optional. Enables the use of remote gateways in the specified hub virtual network.

> **IMPORTANT:** If no gateways exist in the hub virtual network, set this to `false`, otherwise peering will fail to create.
''')
param virtualNetworkUseRemoteGateways bool = true

@description('''Optional. Enables the ability for the Virtual WAN Hub Connection to learn the default route 0.0.0.0/0 from the Hub.
''')
param virtualNetworkVwanEnableInternetSecurity bool = true

@description('''Optional. The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty the `defaultRouteTable` will be associated.
''')
param virtualNetworkVwanAssociatedRouteTableResourceId string = ''

@description('''Optional. An array of of objects of virtual hub route table resource IDs to propagate routes to. If left blank/empty the `defaultRouteTable` will be propagated to only.

Each object must contain the following `key`:
- `id` = The Resource ID of the Virtual WAN Virtual Hub Route Table IDs you wish to propagate too

> **IMPORTANT:** If you provide any Route Tables in this array of objects you must ensure you include also the `defaultRouteTable` Resource ID as an object in the array as it is not added by default when a value is provided for this parameter.
''')
param virtualNetworkVwanPropagatedRouteTablesResourceIds array = []

@description('''Optional. An array of virtual hub route table labels to propagate routes to. If left blank/empty the default label will be propagated to only.
''')
param virtualNetworkVwanPropagatedLabels array = []

@description('''Optional. Indicates whether routing intent is enabled on the Virtual Hub within the Virtual WAN.
''')
param vHubRoutingIntentEnabled bool = false

@description('''Optional. Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.
''')
param roleAssignmentEnabled bool = false

@description('''Optional. Supply an array of objects containing the details of the role assignments to create.

Each object must contain the following `keys`:
- `principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too.
- `definition` = The Name of one of the pre-defined built-In RBAC Roles or a Resource ID of a Built-in or custom RBAC Role Definition as follows:
  - You can only provide the RBAC role name of the pre-defined roles (Contributor, Owner, Reader, Role Based Access Control Administrator (Preview), and User Access Administrator). We only provide those roles as they are the most common ones to assign to a new subscription, also to reduce the template size and complexity in case we define each and every Built-in RBAC role.
  - You can provide the Resource ID of a Built-in or custom RBAC Role Definition
    - e.g. `/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
- `relativeScope` = 2 options can be provided for input value:
    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope
    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group.
''')
@metadata({
  example: '''
  [
    {
      // Contributor role assignment at subscription scope
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: '/Contributor'
      relativeScope: ''
    }
    {
      // Owner role assignment at resource group scope
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: '/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
      relativeScope: '/resourceGroups/{resourceGroupName}'
    }
  ]
  '''
})
param roleAssignments roleAssignmentType = []

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The name of the resource group to create the deployment script for resource providers registration.')
param deploymentScriptResourceGroupName string = 'rsg-${deployment().location}-ds'

@description('Optional. The name of the deployment script to register resource providers.')
param deploymentScriptName string = 'ds-${deployment().location}'

@description('Optional. The name of the user managed identity for the resource providers registration deployment script.')
param deploymentScriptManagedIdentityName string = 'id-${deployment().location}'

@maxLength(64)
@description('Optional. The name of the private virtual network for the deployment script. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.')
param deploymentScriptVirtualNetworkName string = 'vnet-${deployment().location}'

@description('Optional. The name of the network security group for the deployment script private subnet.')
param deploymentScriptNetworkSecurityGroupName string = 'nsg-${deployment().location}'

@description('Optional. The address prefix of the private virtual network for the deployment script.')
param virtualNetworkDeploymentScriptAddressPrefix string = '192.168.0.0/24'

@description('Optional. The name of the storage account for the deployment script.')
param deploymentScriptStorageAccountName string = 'stgds${substring(uniqueString(deployment().name, virtualNetworkLocation), 0, 10)}'

@description('Optional. The location of the deployment script. Use region shortnames e.g. uksouth, eastus, etc.')
param deploymentScriptLocation string = deployment().location

@description('''
Optional. An object of resource providers and resource providers features to register. If left blank/empty, no resource providers will be registered.
''')
param resourceProviders object = {
  'Microsoft.ApiManagement': []
  'Microsoft.AppPlatform': []
  'Microsoft.Authorization': []
  'Microsoft.Automation': []
  'Microsoft.AVS': []
  'Microsoft.Blueprint': []
  'Microsoft.BotService': []
  'Microsoft.Cache': []
  'Microsoft.Cdn': []
  'Microsoft.CognitiveServices': []
  'Microsoft.Compute': []
  'Microsoft.ContainerInstance': []
  'Microsoft.ContainerRegistry': []
  'Microsoft.ContainerService': []
  'Microsoft.CostManagement': []
  'Microsoft.CustomProviders': []
  'Microsoft.Databricks': []
  'Microsoft.DataLakeAnalytics': []
  'Microsoft.DataLakeStore': []
  'Microsoft.DataMigration': []
  'Microsoft.DataProtection': []
  'Microsoft.DBforMariaDB': []
  'Microsoft.DBforMySQL': []
  'Microsoft.DBforPostgreSQL': []
  'Microsoft.DesktopVirtualization': []
  'Microsoft.Devices': []
  'Microsoft.DevTestLab': []
  'Microsoft.DocumentDB': []
  'Microsoft.EventGrid': []
  'Microsoft.EventHub': []
  'Microsoft.HDInsight': []
  'Microsoft.HealthcareApis': []
  'Microsoft.GuestConfiguration': []
  'Microsoft.KeyVault': []
  'Microsoft.Kusto': []
  'microsoft.insights': []
  'Microsoft.Logic': []
  'Microsoft.MachineLearningServices': []
  'Microsoft.Maintenance': []
  'Microsoft.ManagedIdentity': []
  'Microsoft.ManagedServices': []
  'Microsoft.Management': []
  'Microsoft.Maps': []
  'Microsoft.MarketplaceOrdering': []
  'Microsoft.Media': []
  'Microsoft.MixedReality': []
  'Microsoft.Network': []
  'Microsoft.NotificationHubs': []
  'Microsoft.OperationalInsights': []
  'Microsoft.OperationsManagement': []
  'Microsoft.PolicyInsights': []
  'Microsoft.PowerBIDedicated': []
  'Microsoft.Relay': []
  'Microsoft.RecoveryServices': []
  'Microsoft.Resources': []
  'Microsoft.Search': []
  'Microsoft.Security': []
  'Microsoft.SecurityInsights': []
  'Microsoft.ServiceBus': []
  'Microsoft.ServiceFabric': []
  'Microsoft.Sql': []
  'Microsoft.Storage': []
  'Microsoft.StreamAnalytics': []
  'Microsoft.Web': []
}

@sys.description('Optional. The number of blank ARM deployments to create sequentially to introduce a delay to the Subscription being moved to the target Management Group being, if set, to allow for background platform RBAC inheritance to occur.')
param managementGroupAssociationDelayCount int = 15

// VARIABLES

var existingSubscriptionIDEmptyCheck = empty(existingSubscriptionId)
  ? 'No Subscription ID Provided'
  : existingSubscriptionId

// Deployment name variables
// LIMITS: Tenant = 64, Management Group = 64, Subscription = 64, Resource Group = 64
var deploymentNames = {
  createSubscription: take(
    'lz-vend-sub-create-${subscriptionAliasName}-${uniqueString(subscriptionAliasName, subscriptionDisplayName, subscriptionBillingScope, subscriptionWorkload, deployment().name)}',
    64
  )
  createSubscriptionResources: take(
    'lz-vend-sub-res-create-${subscriptionAliasName}-${uniqueString(subscriptionAliasName, subscriptionDisplayName, subscriptionBillingScope, subscriptionWorkload, existingSubscriptionId, deployment().name)}',
    64
  )
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.lz-subvending.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, virtualNetworkLocation), 0, 4)}'
  location: virtualNetworkLocation
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

module createSubscription './modules/subscriptionAlias.bicep' = if (subscriptionAliasEnabled && empty(existingSubscriptionId)) {
  scope: managementGroup()
  name: deploymentNames.createSubscription
  params: {
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionAliasName: subscriptionAliasName
    subscriptionDisplayName: subscriptionDisplayName
    subscriptionWorkload: subscriptionWorkload
    subscriptionTenantId: subscriptionTenantId
    subscriptionOwnerId: subscriptionOwnerId
  }
}

module createSubscriptionResources './modules/subResourceWrapper.bicep' = if (subscriptionAliasEnabled || !empty(existingSubscriptionId)) {
  name: deploymentNames.createSubscriptionResources
  params: {
    subscriptionId: (subscriptionAliasEnabled && empty(existingSubscriptionId))
      ? createSubscription.outputs.subscriptionId
      : existingSubscriptionId
    managementGroupAssociationDelayCount: managementGroupAssociationDelayCount
    subscriptionManagementGroupAssociationEnabled: subscriptionManagementGroupAssociationEnabled
    subscriptionManagementGroupId: subscriptionManagementGroupId
    subscriptionTags: subscriptionTags
    virtualNetworkEnabled: virtualNetworkEnabled
    virtualNetworkResourceGroupName: virtualNetworkResourceGroupName
    virtualNetworkResourceGroupTags: virtualNetworkResourceGroupTags
    virtualNetworkResourceGroupLockEnabled: virtualNetworkResourceGroupLockEnabled
    virtualNetworkLocation: virtualNetworkLocation
    virtualNetworkName: virtualNetworkName
    virtualNetworkTags: virtualNetworkTags
    virtualNetworkAddressSpace: virtualNetworkAddressSpace
    virtualNetworkDnsServers: virtualNetworkDnsServers
    virtualNetworkDdosPlanResourceId: virtualNetworkDdosPlanResourceId
    virtualNetworkPeeringEnabled: virtualNetworkPeeringEnabled
    hubNetworkResourceId: hubNetworkResourceId
    virtualNetworkUseRemoteGateways: virtualNetworkUseRemoteGateways
    virtualNetworkVwanEnableInternetSecurity: virtualNetworkVwanEnableInternetSecurity
    virtualNetworkVwanAssociatedRouteTableResourceId: virtualNetworkVwanAssociatedRouteTableResourceId
    virtualNetworkVwanPropagatedRouteTablesResourceIds: virtualNetworkVwanPropagatedRouteTablesResourceIds
    virtualNetworkVwanPropagatedLabels: virtualNetworkVwanPropagatedLabels
    vHubRoutingIntentEnabled: vHubRoutingIntentEnabled
    roleAssignmentEnabled: roleAssignmentEnabled
    roleAssignments: roleAssignments
    deploymentScriptResourceGroupName: deploymentScriptResourceGroupName
    deploymentScriptName: deploymentScriptName
    deploymentScriptManagedIdentityName: deploymentScriptManagedIdentityName
    resourceProviders: resourceProviders
    deploymentScriptVirtualNetworkName: deploymentScriptVirtualNetworkName
    deploymentScriptLocation: deploymentScriptLocation
    deploymentScriptNetworkSecurityGroupName: deploymentScriptNetworkSecurityGroupName
    virtualNetworkDeploymentScriptAddressPrefix: virtualNetworkDeploymentScriptAddressPrefix
    deploymentScriptStorageAccountName: deploymentScriptStorageAccountName
    enableTelemetry: enableTelemetry
  }
}

// OUTPUTS

@description('The Subscription ID that has been created or provided.')
output subscriptionId string = (subscriptionAliasEnabled && empty(existingSubscriptionId))
  ? createSubscription.outputs.subscriptionId
  : contains(existingSubscriptionIDEmptyCheck, 'No Subscription ID Provided')
      ? existingSubscriptionIDEmptyCheck
      : '${existingSubscriptionId}'

@description('The Subscription Resource ID that has been created or provided.')
output subscriptionResourceId string = (subscriptionAliasEnabled && empty(existingSubscriptionId))
  ? createSubscription.outputs.subscriptionResourceId
  : contains(existingSubscriptionIDEmptyCheck, 'No Subscription ID Provided')
      ? existingSubscriptionIDEmptyCheck
      : '/subscriptions/${existingSubscriptionId}'

@description('The Subscription Owner State. Only used when creating MCA Subscriptions across tenants.')
output subscriptionAcceptOwnershipState string = (subscriptionAliasEnabled && empty(existingSubscriptionId) && !empty(subscriptionTenantId) && !empty(subscriptionOwnerId))
  ? createSubscription.outputs.subscriptionAcceptOwnershipState
  : 'N/A'

@description('The Subscription Ownership URL. Only used when creating MCA Subscriptions across tenants.')
output subscriptionAcceptOwnershipUrl string = (subscriptionAliasEnabled && empty(existingSubscriptionId) && !empty(subscriptionTenantId) && !empty(subscriptionOwnerId))
  ? createSubscription.outputs.subscriptionAcceptOwnershipUrl
  : 'N/A'

@description('The resource providers that failed to register.')
output failedResourceProviders string = !empty(resourceProviders)
  ? createSubscriptionResources.outputs.failedProviders
  : ''

@description('The resource providers features that failed to register.')
output failedResourceProvidersFeatures string = !empty(resourceProviders)
  ? createSubscriptionResources.outputs.failedFeatures
  : ''

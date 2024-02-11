targetScope = 'managementGroup'

// METADATA - Used by PSDocs

metadata name = '`main.bicep` Parameters'

metadata description = 'This module is designed to accelerate deployment of landing zones (aka Subscriptions) within an Azure AD Tenant.'

metadata details = '''These are the input parameters for the Bicep module: [`main.bicep`](./main.bicep)

This is the orchestration module that is used and called by a consumer of the module to deploy a Landing Zone Subscription and its associated resources, based on the parameter input values that are provided to it at deployment time.

> For more information and examples please see the [wiki](https://github.com/Azure/bicep-lz-vending/wiki)'''

// PARAMETERS

// Subscription Parameters
@metadata({
  example: true
})
@sys.description('''Whether to create a new Subscription using the Subscription Alias resource. If `false`, supply an existing Subscription's ID in the parameter named `existingSubscriptionId` instead to deploy resources to an existing Subscription.

- Type: Boolean
''')
param subscriptionAliasEnabled bool = true

@metadata({
  example: 'sub-bicep-lz-vending-example-001'
})
@maxLength(63)
@sys.description('''The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, - and _. The maximum length is 63 characters.

The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.

> The value for this parameter and the parameter named `subscriptionAliasName` are usually set to the same value for simplicity. But they can be different if required for a reason.

> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**

- Type: String
- Default value: `''` *(empty string)*
''')
param subscriptionDisplayName string = ''

@metadata({
  example: 'sub-bicep-lz-vending-example-001'
})
@maxLength(63)
@sys.description('''The name of the Subscription Alias, that will be created by this module.

The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.

> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**

- Type: String
- Default value: `''` *(empty string)*
''')
param subscriptionAliasName string = ''

@metadata({
  example: 'providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456'
})
@sys.description('''The Billing Scope for the new Subscription alias, that will be created by this module.

A valid Billing Scope starts with `/providers/Microsoft.Billing/billingAccounts/` and is case sensitive.

> See below [example in parameter file](#parameter-file) for an example

> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**

- Type: String
- Default value: `''` *(empty string)*
''')
param subscriptionBillingScope string = ''

@metadata({
  example: 'Production'
})
@allowed([
  'DevTest'
  'Production'
])
@sys.description('''The workload type can be either `Production` or `DevTest` and is case sensitive.

> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**

- Type: String
''')
param subscriptionWorkload string = 'Production'

@metadata({
  example: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
})
@maxLength(36)
@sys.description('''The Azure Active Directory Tenant ID (GUID) to which the Subscription should be attached to.

> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants).**

- Type: String
- Default value: `''` *(empty string)*
''')
param subscriptionTenantId string = ''

@metadata({
  example: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
})
@maxLength(36)
@sys.description('''The Azure Active Directory principals object ID (GUID) to whom should be the Subscription Owner.

> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants).**

- Type: String
- Default value: `''` *(empty string)*
''')
param subscriptionOwnerId string = ''

@metadata({
  example: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
})
@maxLength(36)
@sys.description('''An existing subscription ID. Use this when you do not want the module to create a new subscription. But do want to manage the management group membership. A subscription ID should be provided in the example format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.

- Type: String
- Default value: `''` *(empty string)*
''')
param existingSubscriptionId string = ''

// Subscription Resources Wrapper Parameters
@metadata({
  example: true
})
@sys.description('''Whether to move the Subscription to the specified Management Group supplied in the parameter `subscriptionManagementGroupId`.

- Type: Boolean
''')
param subscriptionManagementGroupAssociationEnabled bool = true

@metadata({
  example: 'alz-landingzones-corp'
})
@sys.description('''The destination Management Group ID for the new Subscription that will be created by this module (or the existing one provided in the parameter `existingSubscriptionId`).

**IMPORTANT:** Do not supply the display name of the Management Group. The Management Group ID forms part of the Azure Resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.

> See below [example in parameter file](#parameter-file) for an example

- Type: String
- Default value: `''` *(empty string)*
''')
param subscriptionManagementGroupId string = ''

@metadata({
  example: {
    tagKey1: 'value'
    'tag-key-2': 'value'
  }
})
@sys.description('''An object of Tag key & value pairs to be appended to a Subscription.

> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.

- Type: `{}` Object
- Default value: `{}` *(empty object)*
''')
param subscriptionTags object = {}

@metadata({
  example: true
})
@sys.description('''Whether to create a Virtual Network or not.

If set to `true` ensure you also provide values for the following parameters at a minimum:

- `virtualNetworkResourceGroupName`
- `virtualNetworkResourceGroupLockEnabled`
- `virtualNetworkLocation`
- `virtualNetworkName`
- `virtualNetworkAddressSpace`

> Other parameters may need to be set based on other parameters that you enable that are listed above. Check each parameters documentation for further information.

- Type: Boolean
''')
param virtualNetworkEnabled bool = false

@metadata({
  example: 'rg-networking-001'
})
@maxLength(90)
@sys.description('''The name of the Resource Group to create the Virtual Network in that is created by this module.

- Type: String
- Default value: `''` *(empty string)*
''')
param virtualNetworkResourceGroupName string = ''

@metadata({
  example: {
    tagKey1: 'value'
    'tag-key-2': 'value'
  }
})
@sys.description('''An object of Tag key & value pairs to be appended to the Resource Group that the Virtual Network is created in.

> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.

- Type: `{}` Object
- Default value: `{}` *(empty object)*
''')
param virtualNetworkResourceGroupTags object = {}

@metadata({
  example: true
})
@sys.description('''Enables the deployment of a `CanNotDelete` resource locks to the Virtual Networks Resource Group that is created by this module.

- Type: Boolean
''')
param virtualNetworkResourceGroupLockEnabled bool = true

@metadata({
  example: 'uksouth'
})
@sys.description('''The location of the virtual network. Use region shortnames e.g. `uksouth`, `eastus`, etc. Defaults to the region where the ARM/Bicep deployment is targeted to unless overridden.

- Type: String
''')
param virtualNetworkLocation string = deployment().location

@metadata({
  example: 'vnet-example-001'
})
@maxLength(64)
@sys.description('''The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.

- Type: String
- Default value: `''` *(empty string)*
''')
param virtualNetworkName string = ''

@metadata({
  example: {
    tagKey1: 'value'
    'tag-key-2': 'value'
  }
})
@sys.description('''An object of tag key/value pairs to be set on the Virtual Network that is created.

> **NOTE:** Tags will be overwritten on resource if any exist already.

- Type: `{}` Object
- Default value: `{}` *(empty object)*
''')
param virtualNetworkTags object = {}

@metadata({
  example: [
    '10.0.0.0/16'
  ]
})
@sys.description('''The address space of the Virtual Network that will be created by this module, supplied as multiple CIDR blocks in an array, e.g. `["10.0.0.0/16","172.16.0.0/12"]`

- Type: `[]` Array
- Default value: `[]` *(empty array)*
''')
param virtualNetworkAddressSpace array = []

@metadata({
  example: [
    '10.4.1.4'
    '10.2.1.5'
  ]
})
@sys.description('''The custom DNS servers to use on the Virtual Network, e.g. `["10.4.1.4", "10.2.1.5"]`. If left empty (default) then Azure DNS will be used for the Virtual Network.

- Type: `[]` Array
- Default value: `[]` *(empty array)*
''')
param virtualNetworkDnsServers array = []

@metadata({
  example: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/ddosProtectionPlans/xxxxxxxxxx'
})
@sys.description('''The resource ID of an existing DDoS Network Protection Plan that you wish to link to this Virtual Network.

**Example Expected Values:**
- `''` (empty string)
- DDoS Netowrk Protection Plan Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/ddosProtectionPlans/xxxxxxxxxx`

- Type: String
- Default value: `''` *(empty string)*
''')
param virtualNetworkDdosPlanId string = ''

@metadata({
  example: true
})
@sys.description('''Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.

- Type: Boolean
''')
param virtualNetworkPeeringEnabled bool = false

@metadata({
  example: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualNetworks/xxxxxxxxxx'
})
@sys.description('''The resource ID of the Virtual Network or Virtual WAN Hub in the hub to which the created Virtual Network, by this module, will be peered/connected to via Virtual Network Peering or a Virtual WAN Virtual Hub Connection.

**Example Expected Values:**
- `''` (empty string)
- Hub Virtual Network Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualNetworks/xxxxxxxxxx`
- Virtual WAN Virtual Hub Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxxx`

- Type: String
- Default value: `''` *(empty string)*
''')
param hubNetworkResourceId string = ''

@metadata({
  example: true
})
@sys.description('''Enables the use of remote gateways in the specified hub virtual network.

> **IMPORTANT:** If no gateways exist in the hub virtual network, set this to `false`, otherwise peering will fail to create.

- Type: Boolean
''')
param virtualNetworkUseRemoteGateways bool = true

@metadata({
  example: true
})
@sys.description('''Enables the ability for the Virtual WAN Hub Connection to learn the default route 0.0.0.0/0 from the Hub.

- Type: Boolean
''')
param virtualNetworkVwanEnableInternetSecurity bool = true

@metadata({
  example: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/xxxxxxxxx'
})
@sys.description('''The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty the `defaultRouteTable` will be associated.

- Type: String
- Default value: `''` *(empty string)* = Which means if the parameter `virtualNetworkPeeringEnabled` is `true` and also the parameter `hubNetworkResourceId` is not empty then the `defaultRouteTable` will be associated of the provided Virtual Hub in the parameter `hubNetworkResourceId`.
    - e.g. `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/defaultRouteTable`
''')
param virtualNetworkVwanAssociatedRouteTableResourceId string = ''

@metadata({
  example: [
    {
      id: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/defaultRouteTable'
    }
    {
      id: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/xxxxxxxxx'
    }
  ]
})
@sys.description('''An array of of objects of virtual hub route table resource IDs to propagate routes to. If left blank/empty the `defaultRouteTable` will be propagated to only.

Each object must contain the following `key`:
- `id` = The Resource ID of the Virtual WAN Virtual Hub Route Table IDs you wish to propagate too

> See below [example in parameter file](#parameter-file)

> **IMPORTANT:** If you provide any Route Tables in this array of objects you must ensure you include also the `defaultRouteTable` Resource ID as an object in the array as it is not added by default when a value is provided for this parameter.

- Type: `[]` Array
- Default value: `[]` *(empty array)*
''')
param virtualNetworkVwanPropagatedRouteTablesResourceIds array = []

@metadata({
  example: [
    'default'
    'anotherLabel'
  ]
})
@sys.description('''An array of virtual hub route table labels to propagate routes to. If left blank/empty the default label will be propagated to only.

- Type: `[]` Array
- Default value: `[]` *(empty array)*
''')
param virtualNetworkVwanPropagatedLabels array = []

@metadata({
  example: false
})
@sys.description('''Indicates whether routing intent is enabled on the Virtual Hub within the Virtual WAN.

- Type: Boolean
''')
param vHubRoutingIntentEnabled bool = false

@metadata({
  example: true
})
@sys.description('''Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.

- Type: Boolean
''')
param roleAssignmentEnabled bool = false

@metadata({
  example: [
    {
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: 'Contributor'
      relativeScope: ''
    }
    {
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: '/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      relativeScope: ''
    }
    {
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: 'Reader'
      relativeScope: '/resourceGroups/rsg-networking-001'
    }
    {
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: '/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      relativeScope: '/resourceGroups/rsg-networking-001'
    }
  ]
})
@sys.description('''Supply an array of objects containing the details of the role assignments to create.

Each object must contain the following `keys`:
- `principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too.
- `definition` = The Name of one of the pre-defined built-In RBAC Roles or a Resource ID of a Built-in or custom RBAC Role Definition as follows:
  - You can only provide the RBAC role name of the pre-defined roles (Contributor, Owner, Reader, Network Contributor, Role Based Access Control Administrator (Preview), User Access Administrator, Security Admin). We only provide those roles as they are the most common ones to assign to a new subscription, also to reduce the template size and complexity in case we define each and every Built-in RBAC role.
  - You can provide the Resource ID of a Built-in or custom RBAC Role Definition
    - e.g. `/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
  - You can provide the RBAC role Id of a Built-in RBAC Role Definition
    - e.g. `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
- `relativeScope` = 2 options can be provided for input value:
    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope
    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group

> See below [example in parameter file](#parameter-file) of various combinations

- Type: `[]` Array
- Default value: `[]` *(empty array)*
''')
param roleAssignments array = []

@metadata({
  example: false
})
@sys.description('''Disable telemetry collection by this module.

For more information on the telemetry collected by this module, that is controlled by this parameter, see this page in the wiki: [Telemetry Tracking Using Customer Usage Attribution (PID)](https://github.com/Azure/bicep-lz-vending/wiki/Telemetry)
''')
param disableTelemetry bool = false

@sys.description('Guid for the deployment script resources names based on subscription Id.')
var deploymentScriptResourcesSubGuid = substring((subscriptionAliasEnabled && empty(existingSubscriptionId)) ? createSubscription.outputs.subscriptionId : existingSubscriptionId,0,6)

@sys.description('The name of the resource group to create the deployment script for resource providers registration.')
param deploymentScriptResourceGroupName string = 'rsg-${deployment().location}-ds'

@sys.description('The name of the deployment script to register resource providers')
param deploymentScriptName string = 'ds-${deployment().location}'

@sys.description('The name of the user managed identity for the resource providers registration deployment script.')
param deploymentScriptManagedIdentityName string = 'id-${deployment().location}'

@maxLength(64)
@sys.description('The name of the private virtual network for the deployment script. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.')
param deploymentScriptVirtualNetworkName string = 'vnet-${deployment().location}'

@sys.description('The name of the network security group for the deployment script private subnet.')
param deploymentScriptNetworkSecurityGroupName string = 'nsg-${deployment().location}'

@sys.description('The address prefix of the private virtual network for the deployment script.')
param virtualNetworkDeploymentScriptAddressPrefix string = '192.168.0.0/24'

@sys.description('The name of the storage account for the deployment script.')
param deploymentScriptStorageAccountName string = 'stglzds${deployment().location}'

@metadata({
  example: {
    'Microsoft.Compute' : ['InGuestHotPatchVMPreview']
    'Microsoft.Storage' : []
  }

})
@sys.description('''
An object of resource providers and resource providers features to register. If left blank/empty, no resource providers will be registered.

- Type: `{}` Object
- Default value: `{
  'Microsoft.ApiManagement'             : []
    'Microsoft.AppPlatform'             : []
    'Microsoft.Authorization'           : []
    'Microsoft.Automation'              : []
    'Microsoft.AVS'                     : []
    'Microsoft.Blueprint'               : []
    'Microsoft.BotService'              : []
    'Microsoft.Cache'                   : []
    'Microsoft.Cdn'                     : []
    'Microsoft.CognitiveServices'       : []
    'Microsoft.Compute'                 : []
    'Microsoft.ContainerInstance'       : []
    'Microsoft.ContainerRegistry'       : []
    'Microsoft.ContainerService'        : []
    'Microsoft.CostManagement'          : []
    'Microsoft.CustomProviders'         : []
    'Microsoft.Databricks'              : []
    'Microsoft.DataLakeAnalytics'       : []
    'Microsoft.DataLakeStore'           : []
    'Microsoft.DataMigration'           : []
    'Microsoft.DataProtection'          : []
    'Microsoft.DBforMariaDB'            : []
    'Microsoft.DBforMySQL'              : []
    'Microsoft.DBforPostgreSQL'         : []
    'Microsoft.DesktopVirtualization'   : []
    'Microsoft.Devices'                 : []
    'Microsoft.DevTestLab'              : []
    'Microsoft.DocumentDB'              : []
    'Microsoft.EventGrid'               : []
    'Microsoft.EventHub'                : []
    'Microsoft.HDInsight'               : []
    'Microsoft.HealthcareApis'          : []
    'Microsoft.GuestConfiguration'      : []
    'Microsoft.KeyVault'                : []
    'Microsoft.Kusto'                   : []
    'microsoft.insights'                : []
    'Microsoft.Logic'                   : []
    'Microsoft.MachineLearningServices' : []
    'Microsoft.Maintenance'             : []
    'Microsoft.ManagedIdentity'         : []
    'Microsoft.ManagedServices'         : []
    'Microsoft.Management'              : []
    'Microsoft.Maps'                    : []
    'Microsoft.MarketplaceOrdering'     : []
    'Microsoft.Media'                   : []
    'Microsoft.MixedReality'            : []
    'Microsoft.Network'                 : []
    'Microsoft.NotificationHubs'        : []
    'Microsoft.OperationalInsights'     : []
    'Microsoft.OperationsManagement'    : []
    'Microsoft.PolicyInsights'          : []
    'Microsoft.PowerBIDedicated'        : []
    'Microsoft.Relay'                   : []
    'Microsoft.RecoveryServices'        : []
    'Microsoft.Resources'               : []
    'Microsoft.Search'                  : []
    'Microsoft.Security'                : []
    'Microsoft.SecurityInsights'        : []
    'Microsoft.ServiceBus'              : []
    'Microsoft.ServiceFabric'           : []
    'Microsoft.Sql'                     : []
    'Microsoft.Storage'                 : []
    'Microsoft.StreamAnalytics'         : []
    'Microsoft.TimeSeriesInsights'      : []
    'Microsoft.Web'                     : []
}`
''')
param resourceProviders object = {
  'Microsoft.ApiManagement'             : []
    'Microsoft.AppPlatform'             : []
    'Microsoft.Authorization'           : []
    'Microsoft.Automation'              : []
    'Microsoft.AVS'                     : []
    'Microsoft.Blueprint'               : []
    'Microsoft.BotService'              : []
    'Microsoft.Cache'                   : []
    'Microsoft.Cdn'                     : []
    'Microsoft.CognitiveServices'       : []
    'Microsoft.Compute'                 : []
    'Microsoft.ContainerInstance'       : []
    'Microsoft.ContainerRegistry'       : []
    'Microsoft.ContainerService'        : []
    'Microsoft.CostManagement'          : []
    'Microsoft.CustomProviders'         : []
    'Microsoft.Databricks'              : []
    'Microsoft.DataLakeAnalytics'       : []
    'Microsoft.DataLakeStore'           : []
    'Microsoft.DataMigration'           : []
    'Microsoft.DataProtection'          : []
    'Microsoft.DBforMariaDB'            : []
    'Microsoft.DBforMySQL'              : []
    'Microsoft.DBforPostgreSQL'         : []
    'Microsoft.DesktopVirtualization'   : []
    'Microsoft.Devices'                 : []
    'Microsoft.DevTestLab'              : []
    'Microsoft.DocumentDB'              : []
    'Microsoft.EventGrid'               : []
    'Microsoft.EventHub'                : []
    'Microsoft.HDInsight'               : []
    'Microsoft.HealthcareApis'          : []
    'Microsoft.GuestConfiguration'      : []
    'Microsoft.KeyVault'                : []
    'Microsoft.Kusto'                   : []
    'microsoft.insights'                : []
    'Microsoft.Logic'                   : []
    'Microsoft.MachineLearningServices' : []
    'Microsoft.Maintenance'             : []
    'Microsoft.ManagedIdentity'         : []
    'Microsoft.ManagedServices'         : []
    'Microsoft.Management'              : []
    'Microsoft.Maps'                    : []
    'Microsoft.MarketplaceOrdering'     : []
    'Microsoft.Media'                   : []
    'Microsoft.MixedReality'            : []
    'Microsoft.Network'                 : []
    'Microsoft.NotificationHubs'        : []
    'Microsoft.OperationalInsights'     : []
    'Microsoft.OperationsManagement'    : []
    'Microsoft.PolicyInsights'          : []
    'Microsoft.PowerBIDedicated'        : []
    'Microsoft.Relay'                   : []
    'Microsoft.RecoveryServices'        : []
    'Microsoft.Resources'               : []
    'Microsoft.Search'                  : []
    'Microsoft.Security'                : []
    'Microsoft.SecurityInsights'        : []
    'Microsoft.ServiceBus'              : []
    'Microsoft.ServiceFabric'           : []
    'Microsoft.Sql'                     : []
    'Microsoft.Storage'                 : []
    'Microsoft.StreamAnalytics'         : []
    'Microsoft.TimeSeriesInsights'      : []
    'Microsoft.Web'                     : []
}

// VARIABLES

var existingSubscriptionIDEmptyCheck = empty(existingSubscriptionId) ? 'No Subscription ID Provided' : existingSubscriptionId

var cuaPid = '10d75183-0090-47b2-9c1b-48e3a4a36786'

// Deployment name variables
// LIMITS: Tenant = 64, Management Group = 64, Subscription = 64, Resource Group = 64
var deploymentNames = {
  createSubscription: take('lz-vend-sub-create-${subscriptionAliasName}-${uniqueString(subscriptionAliasName, subscriptionDisplayName, subscriptionBillingScope, subscriptionWorkload, deployment().name)}', 64)
  createSubscriptionResources: take('lz-vend-sub-res-create-${subscriptionAliasName}-${uniqueString(subscriptionAliasName, subscriptionDisplayName, subscriptionBillingScope, subscriptionWorkload, existingSubscriptionId, deployment().name)}', 64)
}

// RESOURCES & MODULES
resource moduleTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (!disableTelemetry) {
  name: 'pid-${cuaPid}-${uniqueString(deployment().name, virtualNetworkLocation)}'
  location: virtualNetworkLocation
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

module createSubscription 'src/self/Microsoft.Subscription/aliases/deploy.bicep' = if (subscriptionAliasEnabled && empty(existingSubscriptionId)) {
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

module createSubscriptionResources 'src/self/subResourceWrapper/deploy.bicep' = if (subscriptionAliasEnabled || !empty(existingSubscriptionId)) {
  name: deploymentNames.createSubscriptionResources
  params: {
    subscriptionId: (subscriptionAliasEnabled && empty(existingSubscriptionId)) ? createSubscription.outputs.subscriptionId : existingSubscriptionId
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
    virtualNetworkDdosPlanId: virtualNetworkDdosPlanId
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
    disableTelemetry: disableTelemetry
    deploymentScriptResourceGroupName: '${deploymentScriptResourceGroupName}-${deploymentScriptResourcesSubGuid}'
    deploymentScriptName: '${deploymentScriptName}-${deploymentScriptResourcesSubGuid}'
    deploymentScriptManagedIdentityName: '${deploymentScriptManagedIdentityName}-${deploymentScriptResourcesSubGuid}'
    resourceProviders: resourceProviders
    deploymentScriptVirtualNetworkName: deploymentScriptVirtualNetworkName
    deploymentScriptNetworkSecurityGroupName: deploymentScriptNetworkSecurityGroupName
    virtualNetworkDeploymentScriptAddressPrefix: virtualNetworkDeploymentScriptAddressPrefix
    deploymentScriptStorageAccountName: '${deploymentScriptStorageAccountName}${deploymentScriptResourcesSubGuid}'
  }
}

// OUTPUTS

@sys.description('The Subscription ID that has been created or provided.')
output subscriptionId string = (subscriptionAliasEnabled && empty(existingSubscriptionId)) ? createSubscription.outputs.subscriptionId : contains(existingSubscriptionIDEmptyCheck, 'No Subscription ID Provided') ? existingSubscriptionIDEmptyCheck : '${existingSubscriptionId}'

@sys.description('The Subscription Resource ID that has been created or provided.')
output subscriptionResourceId string = (subscriptionAliasEnabled && empty(existingSubscriptionId)) ? createSubscription.outputs.subscriptionResourceId : contains(existingSubscriptionIDEmptyCheck, 'No Subscription ID Provided') ? existingSubscriptionIDEmptyCheck : '/subscriptions/${existingSubscriptionId}'

@sys.description('The Subscription Owner State. Only used when creating MCA Subscriptions across tenants')
output subscriptionAcceptOwnershipState string = (subscriptionAliasEnabled && empty(existingSubscriptionId) && !empty(subscriptionTenantId) && !empty(subscriptionOwnerId)) ? createSubscription.outputs.subscriptionAcceptOwnershipState : 'N/A'

@sys.description('The Subscription Ownership URL. Only used when creating MCA Subscriptions across tenants')
output subscriptionAcceptOwnershipUrl string = (subscriptionAliasEnabled && empty(existingSubscriptionId) && !empty(subscriptionTenantId) && !empty(subscriptionOwnerId)) ? createSubscription.outputs.subscriptionAcceptOwnershipUrl : 'N/A'

@sys.description('The resource providers that failed to register')
output failedResourceProviders string = !empty(resourceProviders) ? createSubscriptionResources.outputs.failedProviders : ''

@sys.description('The resource providers features that failed to register')
output failedResourceProvidersFeatures string = !empty(resourceProviders) ? createSubscriptionResources.outputs.failedFeatures : ''


targetScope = 'managementGroup'

// METADATA - Used by PSDocs

metadata name = 'Bicep Landing Zone (Subscription) Vending Module'

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

- Default value: `true`
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

- Default value: `''` *(empty string)*
''')
param subscriptionAliasName string = ''

@metadata({
  example: '/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456'
})
@sys.description('''The Billing Scope for the new Subscription alias, that will be created by this module.

A valid Billing Scope starts with `/providers/Microsoft.Billing/billingAccounts/` and is case sensitive.

> See below [example in parameter file](#example-json-parameter-file) for an example

> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**

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

- Default value: `Production`
''')
param subscriptionWorkload string = 'Production'

@metadata({
  example: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
})
@maxLength(36)
@sys.description('''The Azure Active Directory Tenant ID (GUID) to which the Subscription should be attached to.

> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants).**

- Default value: `''` *(empty string)*
''')
param subscriptionTenantId string = ''

@metadata({
  example: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
})
@maxLength(36)
@sys.description('''The Azure Active Directory principals object ID (GUID) to whom should be the Subscription Owner.

> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants).**

- Default value: `''` *(empty string)*
''')
param subscriptionOwnerId string = ''

@metadata({
  example: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
})
@maxLength(36)
@sys.description('''An existing subscription ID. Use this when you do not want the module to create a new subscription. But do want to manage the management group membership. A subscription ID should be provided in the example format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.

- Default value: `''` *(empty string)*
''')
param existingSubscriptionId string = ''

// Subscription Resources Wrapper Parameters
@metadata({
  example: true
})
@sys.description('''Whether to move the Subscription to the specified Management Group supplied in the parameter `subscriptionManagementGroupId`.

- Default value: `true`
''')
param subscriptionManagementGroupAssociationEnabled bool = true

@metadata({
  example: 'alz-landingzones-corp'
})
@sys.description('''The destination Management Group ID for the new Subscription that will be created by this module (or the existing one provided in the parameter `existingSubscriptionId`).

**IMPORTANT:** Do not supply the display name of the Management Group. The Management Group ID forms part of the Azure Resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.

> See below [example in parameter file](#example-json-parameter-file) for an example

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

- Default value: `false`
''')
param virtualNetworkEnabled bool = false

@metadata({
  example: 'rg-networking-001'
})
@maxLength(90)
@sys.description('''The name of the Resource Group to create the Virtual Network in that is created by this module.

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

- Default value: `{}` *(empty object)*
''')
param virtualNetworkResourceGroupTags object = {}

@metadata({
  example: true
})
@sys.description('''Enables the deployment of a `CanNotDelete` resource locks to the Virtual Networks Resource Group that is created by this module.

- Default value: `true`
''')
param virtualNetworkResourceGroupLockEnabled bool = true

@metadata({
  example: 'uksouth'
})
@sys.description('''The location of the virtual network. Use region shortnames e.g. `uksouth`, `eastus`, etc. Defaults to the region where the ARM/Bicep deployment is targeted to unless overridden.

- Default value: `deployment().location`
''')
param virtualNetworkLocation string = deployment().location

@metadata({
  example: 'vnet-example-001'
})
@maxLength(64)
@sys.description('''The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.

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

- Default value: `{}` *(empty object)*
''')
param virtualNetworkTags object = {}

@metadata({
  example: [
    '10.0.0.0/16'
  ]
})
@sys.description('''The address space of the Virtual Network that will be created by this module, supplied as multiple CIDR blocks in an array, e.g. `["10.0.0.0/16","172.16.0.0/12"]`

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

- Default value: `''` *(empty string)*
''')
param virtualNetworkDdosPlanId string = ''

@metadata({
  example: true
})
@sys.description('''Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.

- Default value: `false`
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

- Default value: `''` *(empty string)*
''')
param hubNetworkResourceId string = ''

@metadata({
  example: true
})
@sys.description('''Enables the use of remote gateways in the specified hub virtual network.

> **IMPORTANT:** If no gateways exist in the hub virtual network, set this to `false`, otherwise peering will fail to create.

- Default value: `true`
''')
param virtualNetworkUseRemoteGateways bool = true

@metadata({
  example: true
})
@sys.description('''Enables the ability for the Virtual WAN Hub Connection to learn the default route 0.0.0.0/0 from the Hub.

''')
param virtualNetworkVwanEnableInternetSecurity bool = true

@metadata({
  example: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/xxxxxxxxx'
})
@sys.description('''The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty the `defaultRouteTable` will be associated.

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

> See below [example in parameter file](#example-json-parameter-file)

> **IMPORTANT:** If you provide any Route Tables in this array of objects you must ensure you include also the `defaultRouteTable` Resource ID as an object in the array as it is not added by default when a value is provided for this parameter.

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

- Default value: `[]` *(empty array)*
''')
param virtualNetworkVwanPropagatedLabels array = []

@metadata({
  example: true
})
@sys.description('''Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.

- Default value: `false`
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
- `definition` = The Name of built-In RBAC Roles or a Resource ID of a Built-in or custom RBAC Role Definition.
- `relativeScope` = 2 options can be provided for input value:
    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope
    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group

> See below [example in parameter file](#example-json-parameter-file) of various combinations

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
    roleAssignmentEnabled: roleAssignmentEnabled
    roleAssignments: roleAssignments
    disableTelemetry: disableTelemetry
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

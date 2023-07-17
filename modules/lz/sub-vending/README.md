# Bicep Landing Zone (Subscription) Vending Module

This module is designed to accelerate deployment of landing zones (aka Subscriptions) within an Azure AD Tenant.

## Description

> ℹ️ This module requires the usage of Bicep version `v0.11.1` or later. For details on installing/upgrading Bicep see: [Install Bicep tools](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install) ℹ️

The landing zone Bicep modules are designed to accelerate deployment of the individual landing zones (aka Subscriptions) within an Azure AD Tenant.

> See the different types of landing zones in the Azure Landing Zones documentation here: [What is an Azure landing zone? - Platform vs. application landing zones](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/#platform-vs-application-landing-zones)

The modules are designed to be instantiated many times, once for each desired landing zone.

This is currently split logically into the following capabilities:

- Subscription creation and management group placement
- Networking - deploy a Virtual Network with, optional:
  - Hub & spoke connectivity (peering to a hub Virtual Network)
  - Virtual WAN connectivity (peering to a Virtual Hub via a Virtual Hub Connection)
  - Link to existing DDoS Network Protection Plan
  - Specify Custom DNS Servers
- Role assignments
- Tags

> When creating Virtual Network peerings, be aware of the [limit of peerings per Virtual Network.](https://learn.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits?toc=%2Fazure%2Fvirtual-network%2Ftoc.json#azure-resource-manager-virtual-networking-limits)

We would like feedback on what's missing in the module. Please raise an [issue](https://github.com/Azure/bicep-lz-vending/issues) on this modules home GitHub repository if you have any suggestions.

## Parameters

| Name                                                 | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| :--------------------------------------------------- | :------: | :------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `subscriptionAliasEnabled`                           | `bool`   | No       | Whether to create a new Subscription using the Subscription Alias resource. If `false`, supply an existing Subscription's ID in the parameter named `existingSubscriptionId` instead to deploy resources to an existing Subscription.<br /><br />- Default value: `true`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| `subscriptionDisplayName`                            | `string` | No       | The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, - and _. The maximum length is 63 characters.<br /><br />The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.<br /><br />> The value for this parameter and the parameter named `subscriptionAliasName` are usually set to the same value for simplicity. But they can be different if required for a reason.<br /><br />> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**<br /><br />- Default value: `''` *(empty string)*                                                                                                                                                                           |
| `subscriptionAliasName`                              | `string` | No       | The name of the Subscription Alias, that will be created by this module.<br /><br />The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.<br /><br />> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**<br /><br />- Default value: `''` *(empty string)*                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `subscriptionBillingScope`                           | `string` | No       | The Billing Scope for the new Subscription alias, that will be created by this module.<br /><br />A valid Billing Scope starts with `/providers/Microsoft.Billing/billingAccounts/` and is case sensitive.<br /><br />> See below [example in parameter file](#example-json-parameter-file) for an example<br /><br />> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**<br /><br />- Default value: `''` *(empty string)*                                                                                                                                                                                                                                                                                                                                |
| `subscriptionWorkload`                               | `string` | No       | The workload type can be either `Production` or `DevTest` and is case sensitive.<br /><br />> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**<br /><br />- Default value: `Production`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `subscriptionTenantId`                               | `string` | No       | The Azure Active Directory Tenant ID (GUID) to which the Subscription should be attached to.<br /><br />> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants).**<br /><br />- Default value: `''` *(empty string)*                                                                                                                                                                                                                                                                                                                                                           |
| `subscriptionOwnerId`                                | `string` | No       | The Azure Active Directory principals object ID (GUID) to whom should be the Subscription Owner.<br /><br />> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants).**<br /><br />- Default value: `''` *(empty string)*                                                                                                                                                                                                                                                                                                                                                       |
| `existingSubscriptionId`                             | `string` | No       | An existing subscription ID. Use this when you do not want the module to create a new subscription. But do want to manage the management group membership. A subscription ID should be provided in the example format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.<br /><br />- Default value: `''` *(empty string)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `subscriptionManagementGroupAssociationEnabled`      | `bool`   | No       | Whether to move the Subscription to the specified Management Group supplied in the parameter `subscriptionManagementGroupId`.<br /><br />- Default value: `true`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `subscriptionManagementGroupId`                      | `string` | No       | The destination Management Group ID for the new Subscription that will be created by this module (or the existing one provided in the parameter `existingSubscriptionId`).<br /><br />**IMPORTANT:** Do not supply the display name of the Management Group. The Management Group ID forms part of the Azure Resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.<br /><br />> See below [example in parameter file](#example-json-parameter-file) for an example<br /><br />- Default value: `''` *(empty string)*                                                                                                                                                                                                                                                       |
| `subscriptionTags`                                   | `object` | No       | An object of Tag key & value pairs to be appended to a Subscription.<br /><br />> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.<br /><br />- Default value: `{}` *(empty object)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `virtualNetworkEnabled`                              | `bool`   | No       | Whether to create a Virtual Network or not.<br /><br />If set to `true` ensure you also provide values for the following parameters at a minimum:<br /><br />- `virtualNetworkResourceGroupName`<br />- `virtualNetworkResourceGroupLockEnabled`<br />- `virtualNetworkLocation`<br />- `virtualNetworkName`<br />- `virtualNetworkAddressSpace`<br /><br />> Other parameters may need to be set based on other parameters that you enable that are listed above. Check each parameters documentation for further information.<br /><br />- Default value: `false`                                                                                                                                                                                                                                             |
| `virtualNetworkResourceGroupName`                    | `string` | No       | The name of the Resource Group to create the Virtual Network in that is created by this module.<br /><br />- Default value: `''` *(empty string)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `virtualNetworkResourceGroupTags`                    | `object` | No       | An object of Tag key & value pairs to be appended to the Resource Group that the Virtual Network is created in.<br /><br />> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.<br /><br />- Default value: `{}` *(empty object)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `virtualNetworkResourceGroupLockEnabled`             | `bool`   | No       | Enables the deployment of a `CanNotDelete` resource locks to the Virtual Networks Resource Group that is created by this module.<br /><br />- Default value: `true`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `virtualNetworkLocation`                             | `string` | No       | The location of the virtual network. Use region shortnames e.g. `uksouth`, `eastus`, etc. Defaults to the region where the ARM/Bicep deployment is targeted to unless overridden.<br /><br />- Default value: `deployment().location`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| `virtualNetworkName`                                 | `string` | No       | The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.<br /><br />- Default value: `''` *(empty string)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `virtualNetworkTags`                                 | `object` | No       | An object of tag key/value pairs to be set on the Virtual Network that is created.<br /><br />> **NOTE:** Tags will be overwritten on resource if any exist already.<br /><br />- Default value: `{}` *(empty object)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `virtualNetworkAddressSpace`                         | `array`  | No       | The address space of the Virtual Network that will be created by this module, supplied as multiple CIDR blocks in an array, e.g. `["10.0.0.0/16","172.16.0.0/12"]`<br /><br />- Default value: `[]` *(empty array)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `virtualNetworkDnsServers`                           | `array`  | No       | The custom DNS servers to use on the Virtual Network, e.g. `["10.4.1.4", "10.2.1.5"]`. If left empty (default) then Azure DNS will be used for the Virtual Network.<br /><br />- Default value: `[]` *(empty array)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `virtualNetworkDdosPlanId`                           | `string` | No       | The resource ID of an existing DDoS Network Protection Plan that you wish to link to this Virtual Network.<br /><br />**Example Expected Values:**<br />- `''` (empty string)<br />- DDoS Netowrk Protection Plan Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/ddosProtectionPlans/xxxxxxxxxx`<br /><br />- Default value: `''` *(empty string)*                                                                                                                                                                                                                                                                                                                                                                                     |
| `virtualNetworkPeeringEnabled`                       | `bool`   | No       | Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.<br /><br />- Default value: `false`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| `hubNetworkResourceId`                               | `string` | No       | The resource ID of the Virtual Network or Virtual WAN Hub in the hub to which the created Virtual Network, by this module, will be peered/connected to via Virtual Network Peering or a Virtual WAN Virtual Hub Connection.<br /><br />**Example Expected Values:**<br />- `''` (empty string)<br />- Hub Virtual Network Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualNetworks/xxxxxxxxxx`<br />- Virtual WAN Virtual Hub Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxxx`<br /><br />- Default value: `''` *(empty string)*                                                                                                  |
| `virtualNetworkUseRemoteGateways`                    | `bool`   | No       | Enables the use of remote gateways in the specified hub virtual network.<br /><br />> **IMPORTANT:** If no gateways exist in the hub virtual network, set this to `false`, otherwise peering will fail to create.<br /><br />- Default value: `true`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `virtualNetworkVwanEnableInternetSecurity`           | `bool`   | No       | Enables the ability for the Virtual WAN Hub Connection to learn the default route 0.0.0.0/0 from the Hub.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `virtualNetworkVwanAssociatedRouteTableResourceId`   | `string` | No       | The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty the `defaultRouteTable` will be associated.<br /><br />- Default value: `''` *(empty string)* = Which means if the parameter `virtualNetworkPeeringEnabled` is `true` and also the parameter `hubNetworkResourceId` is not empty then the `defaultRouteTable` will be associated of the provided Virtual Hub in the parameter `hubNetworkResourceId`.<br />    - e.g. `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/defaultRouteTable`                                                                                                                                  |
| `virtualNetworkVwanPropagatedRouteTablesResourceIds` | `array`  | No       | An array of of objects of virtual hub route table resource IDs to propagate routes to. If left blank/empty the `defaultRouteTable` will be propagated to only.<br /><br />Each object must contain the following `key`:<br />- `id` = The Resource ID of the Virtual WAN Virtual Hub Route Table IDs you wish to propagate too<br /><br />> See below [example in parameter file](#example-json-parameter-file)<br /><br />> **IMPORTANT:** If you provide any Route Tables in this array of objects you must ensure you include also the `defaultRouteTable` Resource ID as an object in the array as it is not added by default when a value is provided for this parameter.<br /><br />- Default value: `[]` *(empty array)*                                                                                 |
| `virtualNetworkVwanPropagatedLabels`                 | `array`  | No       | An array of virtual hub route table labels to propagate routes to. If left blank/empty the default label will be propagated to only.<br /><br />- Default value: `[]` *(empty array)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| `roleAssignmentEnabled`                              | `bool`   | No       | Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.<br /><br />- Default value: `false`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `roleAssignments`                                    | `array`  | No       | Supply an array of objects containing the details of the role assignments to create.<br /><br />Each object must contain the following `keys`:<br />- `principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too.<br />- `definition` = The Name of built-In RBAC Roles or a Resource ID of a Built-in or custom RBAC Role Definition.<br />- `relativeScope` = 2 options can be provided for input value:<br />    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope<br />    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group<br /><br />> See below [example in parameter file](#example-json-parameter-file) of various combinations<br /><br />- Default value: `[]` *(empty array)* |
| `disableTelemetry`                                   | `bool`   | No       | Disable telemetry collection by this module.<br /><br />For more information on the telemetry collected by this module, that is controlled by this parameter, see this page in the wiki: [Telemetry Tracking Using Customer Usage Attribution (PID)](https://github.com/Azure/bicep-lz-vending/wiki/Telemetry)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |

## Outputs

| Name                               | Type     | Description                                                                              |
| :--------------------------------- | :------: | :--------------------------------------------------------------------------------------- |
| `subscriptionId`                   | `string` | The Subscription ID that has been created or provided.                                   |
| `subscriptionResourceId`           | `string` | The Subscription Resource ID that has been created or provided.                          |
| `subscriptionAcceptOwnershipState` | `string` | The Subscription Owner State. Only used when creating MCA Subscriptions across tenants   |
| `subscriptionAcceptOwnershipUrl`   | `string` | The Subscription Ownership URL. Only used when creating MCA Subscriptions across tenants |

## Examples

> More examples can be found in this modules home GitHub repository wiki here: [https://github.com/azure/bicep-lz-vending/wiki/examples](https://github.com/azure/bicep-lz-vending/wiki/examples)

### Example 1 - Subscription Creation & Management Group Placement, No Networking

```bicep
targetScope = 'managementGroup'

module sub001 'br/public:lz/sub-vending:1.4.1' = {
  name: 'sub001'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: '/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456'
    subscriptionAliasName: 'sub-test-001'
    subscriptionDisplayName: 'sub-test-001'
    subscriptionTags: {
      example: 'true'
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'corp'
  }
}
```

### Example 2 - Subscription Creation & Management Group Placement And Create Virtual Network, No Peering

```bicep
targetScope = 'managementGroup'

@description('Specifies the location for resources.')
param location string = 'uksouth'

module sub002 'br/public:lz/sub-vending:1.4.1' = {
  name: 'sub002'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: '/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456'
    subscriptionAliasName: 'sub-test-002'
    subscriptionDisplayName: 'sub-test-002'
    subscriptionTags: {
      example: 'true'
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'corp'
    virtualNetworkEnabled: true
    virtualNetworkLocation: location
    virtualNetworkResourceGroupName: 'rsg-${location}-net-001'
    virtualNetworkName: 'vnet-${location}-001'
    virtualNetworkAddressSpace: [
      '10.0.0.0/24'
    ]
    virtualNetworkResourceGroupLockEnabled: false
  }
}
```

### Example 3 - Subscription Creation & Management Group Placement And Create Virtual Network And Peering To Virtual Network

```bicep
targetScope = 'managementGroup'

@description('Specifies the location for resources.')
param location string = 'uksouth'

module sub003 'br/public:lz/sub-vending:1.4.1' = {
  name: 'sub003'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: '/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456'
    subscriptionAliasName: 'sub-test-003'
    subscriptionDisplayName: 'sub-test-003'
    subscriptionTags: {
      test: 'true'
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'corp'
    virtualNetworkEnabled: true
    virtualNetworkLocation: location
    virtualNetworkResourceGroupName: 'rsg-${location}-net-001'
    virtualNetworkName: 'vnet-${location}-001'
    virtualNetworkAddressSpace: [
      '10.3.0.0/24'
    ]
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkPeeringEnabled: true
    hubNetworkResourceId: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rsg-uks-net-hub-001/providers/Microsoft.Network/virtualNetworks/vnet-uks-hub-001'
  }
}
```

### Example 4 - Subscription Creation & Management Group Placement And Create Virtual Network And Peering To Virtual WAN Hub (Virtual Hub Connection)

```bicep
targetScope = 'managementGroup'

@description('Specifies the location for resources.')
param location string = 'uksouth'

module sub003 'br/public:lz/sub-vending:1.4.1' = {
  name: 'sub004'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: '/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456'
    subscriptionAliasName: 'sub-test-004'
    subscriptionDisplayName: 'sub-test-004'
    subscriptionTags: {
      test: 'true'
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'corp'
    virtualNetworkEnabled: true
    virtualNetworkLocation: location
    virtualNetworkResourceGroupName: 'rsg-${location}-net-001'
    virtualNetworkName: 'vnet-${location}-001'
    virtualNetworkAddressSpace: [
      '10.4.0.0/24'
    ]
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkPeeringEnabled: true
    hubNetworkResourceId: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rsg-uks-net-vwan-001/providers/Microsoft.Network/virtualHubs/vhub-uks-001'
  }
}
```

### Example JSON Parameter File

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "main.json"
    },
    "parameters": {
        "subscriptionAliasEnabled": {
            "value": true
        },
        "subscriptionDisplayName": {
            "value": "sub-bicep-lz-vending-example-001"
        },
        "subscriptionAliasName": {
            "value": "sub-bicep-lz-vending-example-001"
        },
        "subscriptionBillingScope": {
            "value": "/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456"
        },
        "subscriptionWorkload": {
            "value": "Production"
        },
        "existingSubscriptionId": {
            "value": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        },
        "subscriptionManagementGroupAssociationEnabled": {
            "value": true
        },
        "subscriptionManagementGroupId": {
            "value": "alz-landingzones-corp"
        },
        "subscriptionTags": {
            "value": {
                "tagKey1": "value",
                "tag-key-2": "value"
            }
        },
        "virtualNetworkEnabled": {
            "value": true
        },
        "virtualNetworkResourceGroupName": {
            "value": "rg-networking-001"
        },
        "virtualNetworkResourceGroupTags": {
            "value": {
                "tagKey1": "value",
                "tag-key-2": "value"
            }
        },
        "virtualNetworkResourceGroupLockEnabled": {
            "value": true
        },
        "virtualNetworkLocation": {
            "value": "uksouth"
        },
        "virtualNetworkName": {
            "value": "vnet-example-001"
        },
        "virtualNetworkTags": {
            "value": {
                "tagKey1": "value",
                "tag-key-2": "value"
            }
        },
        "virtualNetworkAddressSpace": {
            "value": [
                "10.0.0.0/16"
            ]
        },
        "virtualNetworkDnsServers": {
            "value": [
                "10.4.1.4",
                "10.2.1.5"
            ]
        },
        "virtualNetworkDdosPlanId": {
            "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/ddosProtectionPlans/xxxxxxxxxx"
        },
        "virtualNetworkPeeringEnabled": {
            "value": true
        },
        "hubNetworkResourceId": {
            "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualNetworks/xxxxxxxxxx"
        },
        "virtualNetworkUseRemoteGateways": {
            "value": true
        },
        "virtualNetworkVwanAssociatedRouteTableResourceId": {
            "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/xxxxxxxxx"
        },
        "virtualNetworkVwanPropagatedRouteTablesResourceIds": {
            "value": [
                {
                    "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/defaultRouteTable"
                },
                {
                    "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/xxxxxxxxx"
                }
            ]
        },
        "virtualNetworkVwanPropagatedLabels": {
            "value": [
                "default",
                "anotherLabel"
            ]
        },
        "roleAssignmentEnabled": {
            "value": true
        },
        "roleAssignments": {
            "value": [
                {
                    "principalId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                    "definition": "Contributor",
                    "relativeScope": ""
                },
                {
                    "principalId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                    "definition": "/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                    "relativeScope": ""
                },
                {
                    "principalId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                    "definition": "Reader",
                    "relativeScope": "/resourceGroups/rsg-networking-001"
                },
                {
                    "principalId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                    "definition": "/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                    "relativeScope": "/resourceGroups/rsg-networking-001"
                }
            ]
        },
        "disableTelemetry": {
            "value": false
        }
    }
}
```
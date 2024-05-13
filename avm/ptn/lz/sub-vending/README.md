# Key Vaults `[Microsoft.lz/subvending]`

This module deploys a subscription to accelerate deployment of landing zones.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities/federatedIdentityCredentials) |
| `Microsoft.Management/managementGroups/subscriptions` | [2021-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Management/2021-04-01/managementGroups/subscriptions) |
| `Microsoft.Network/networkSecurityGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkSecurityGroups) |
| `Microsoft.Network/networkSecurityGroups/securityRules` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkSecurityGroups/securityRules) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/virtualHubs/hubVirtualNetworkConnections` | [2021-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/virtualHubs/hubVirtualNetworkConnections) |
| `Microsoft.Network/virtualNetworks` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/virtualNetworkPeerings) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |
| `Microsoft.Resources/resourceGroups` | [2021-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2021-04-01/resourceGroups) |
| `Microsoft.Resources/tags` | [2019-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/tags) |
| `Microsoft.Storage/storageAccounts` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2022-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-05-01/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/tableServices/tables) |
| `Microsoft.Subscription/aliases` | [2021-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Subscription/2021-10-01/aliases) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/lz/sub-vending:<version>`.

- [Using only defaults.](#example-1-using-only-defaults)
- [Hub and spoke topology.](#example-2-hub-and-spoke-topology)
- [Vwan topology.](#example-3-vwan-topology)

### Example 1: _Using only defaults._

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    deploymentScriptLocation: '<deploymentScriptLocation>'
    deploymentScriptManagedIdentityName: '<deploymentScriptManagedIdentityName>'
    deploymentScriptName: 'ds-samin1'
    deploymentScriptNetworkSecurityGroupName: '<deploymentScriptNetworkSecurityGroupName>'
    deploymentScriptResourceGroupName: '<deploymentScriptResourceGroupName>'
    deploymentScriptStorageAccountName: '<deploymentScriptStorageAccountName>'
    deploymentScriptVirtualNetworkName: '<deploymentScriptVirtualNetworkName>'
    resourceProviders: {
      'Microsoft.AVS': [
        'AzureServicesVm'
      ]
      'Microsoft.HybridCompute': [
        'ArcServerPrivateLinkPreview'
      ]
    }
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        definition: 'Reader'
        principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
        relativeScope: ''
      }
    ]
    subscriptionAliasEnabled: true
    subscriptionAliasName: 'dep-sub-blzv-tests-samin1'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: 'dep-sub-blzv-tests-samin1'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
    virtualNetworkEnabled: false
    virtualNetworkLocation: '<virtualNetworkLocation>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "deploymentScriptLocation": {
      "value": "<deploymentScriptLocation>"
    },
    "deploymentScriptManagedIdentityName": {
      "value": "<deploymentScriptManagedIdentityName>"
    },
    "deploymentScriptName": {
      "value": "ds-samin1"
    },
    "deploymentScriptNetworkSecurityGroupName": {
      "value": "<deploymentScriptNetworkSecurityGroupName>"
    },
    "deploymentScriptResourceGroupName": {
      "value": "<deploymentScriptResourceGroupName>"
    },
    "deploymentScriptStorageAccountName": {
      "value": "<deploymentScriptStorageAccountName>"
    },
    "deploymentScriptVirtualNetworkName": {
      "value": "<deploymentScriptVirtualNetworkName>"
    },
    "resourceProviders": {
      "value": {
        "Microsoft.AVS": [
          "AzureServicesVm"
        ],
        "Microsoft.HybridCompute": [
          "ArcServerPrivateLinkPreview"
        ]
      }
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "definition": "Reader",
          "principalId": "896b1162-be44-4b28-888a-d01acc1b4271",
          "relativeScope": ""
        }
      ]
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "dep-sub-blzv-tests-samin1"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "dep-sub-blzv-tests-samin1"
    },
    "subscriptionManagementGroupAssociationEnabled": {
      "value": true
    },
    "subscriptionManagementGroupId": {
      "value": "bicep-lz-vending-automation-child"
    },
    "subscriptionTags": {
      "value": {
        "namePrefix": "<namePrefix>",
        "serviceShort": "<serviceShort>"
      }
    },
    "subscriptionWorkload": {
      "value": "Production"
    },
    "virtualNetworkEnabled": {
      "value": false
    },
    "virtualNetworkLocation": {
      "value": "<virtualNetworkLocation>"
    }
  }
}
```

</details>
<p>

### Example 2: _Hub and spoke topology._

This instance deploys a subscription with a hub-spoke network topology.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    deploymentScriptLocation: '<deploymentScriptLocation>'
    deploymentScriptManagedIdentityName: '<deploymentScriptManagedIdentityName>'
    deploymentScriptName: 'ds-sahs1'
    deploymentScriptNetworkSecurityGroupName: '<deploymentScriptNetworkSecurityGroupName>'
    deploymentScriptResourceGroupName: '<deploymentScriptResourceGroupName>'
    deploymentScriptStorageAccountName: '<deploymentScriptStorageAccountName>'
    deploymentScriptVirtualNetworkName: '<deploymentScriptVirtualNetworkName>'
    hubNetworkResourceId: '<hubNetworkResourceId>'
    resourceProviders: {
      'Microsoft.AVS': [
        'AzureServicesVm'
      ]
      'Microsoft.HybridCompute': [
        'ArcServerPrivateLinkPreview'
      ]
    }
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        definition: 'Network Contributor'
        principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
        relativeScope: '<relativeScope>'
      }
    ]
    subscriptionAliasEnabled: true
    subscriptionAliasName: 'dep-sub-blzv-tests-sahs1'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: 'dep-sub-blzv-tests-sahs1'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
    virtualNetworkAddressSpace: [
      '10.110.0.0/16'
    ]
    virtualNetworkEnabled: true
    virtualNetworkLocation: '<virtualNetworkLocation>'
    virtualNetworkName: '<virtualNetworkName>'
    virtualNetworkPeeringEnabled: true
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkResourceGroupName: '<virtualNetworkResourceGroupName>'
    virtualNetworkUseRemoteGateways: false
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "deploymentScriptLocation": {
      "value": "<deploymentScriptLocation>"
    },
    "deploymentScriptManagedIdentityName": {
      "value": "<deploymentScriptManagedIdentityName>"
    },
    "deploymentScriptName": {
      "value": "ds-sahs1"
    },
    "deploymentScriptNetworkSecurityGroupName": {
      "value": "<deploymentScriptNetworkSecurityGroupName>"
    },
    "deploymentScriptResourceGroupName": {
      "value": "<deploymentScriptResourceGroupName>"
    },
    "deploymentScriptStorageAccountName": {
      "value": "<deploymentScriptStorageAccountName>"
    },
    "deploymentScriptVirtualNetworkName": {
      "value": "<deploymentScriptVirtualNetworkName>"
    },
    "hubNetworkResourceId": {
      "value": "<hubNetworkResourceId>"
    },
    "resourceProviders": {
      "value": {
        "Microsoft.AVS": [
          "AzureServicesVm"
        ],
        "Microsoft.HybridCompute": [
          "ArcServerPrivateLinkPreview"
        ]
      }
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "definition": "Network Contributor",
          "principalId": "896b1162-be44-4b28-888a-d01acc1b4271",
          "relativeScope": "<relativeScope>"
        }
      ]
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "dep-sub-blzv-tests-sahs1"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "dep-sub-blzv-tests-sahs1"
    },
    "subscriptionManagementGroupAssociationEnabled": {
      "value": true
    },
    "subscriptionManagementGroupId": {
      "value": "bicep-lz-vending-automation-child"
    },
    "subscriptionTags": {
      "value": {
        "namePrefix": "<namePrefix>",
        "serviceShort": "<serviceShort>"
      }
    },
    "subscriptionWorkload": {
      "value": "Production"
    },
    "virtualNetworkAddressSpace": {
      "value": [
        "10.110.0.0/16"
      ]
    },
    "virtualNetworkEnabled": {
      "value": true
    },
    "virtualNetworkLocation": {
      "value": "<virtualNetworkLocation>"
    },
    "virtualNetworkName": {
      "value": "<virtualNetworkName>"
    },
    "virtualNetworkPeeringEnabled": {
      "value": true
    },
    "virtualNetworkResourceGroupLockEnabled": {
      "value": false
    },
    "virtualNetworkResourceGroupName": {
      "value": "<virtualNetworkResourceGroupName>"
    },
    "virtualNetworkUseRemoteGateways": {
      "value": false
    }
  }
}
```

</details>
<p>

### Example 3: _Vwan topology._

This instance deploys a subscription with a vwan network topology.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    deploymentScriptLocation: '<deploymentScriptLocation>'
    deploymentScriptManagedIdentityName: '<deploymentScriptManagedIdentityName>'
    deploymentScriptName: 'ds-sawan1'
    deploymentScriptNetworkSecurityGroupName: '<deploymentScriptNetworkSecurityGroupName>'
    deploymentScriptResourceGroupName: '<deploymentScriptResourceGroupName>'
    deploymentScriptStorageAccountName: '<deploymentScriptStorageAccountName>'
    deploymentScriptVirtualNetworkName: '<deploymentScriptVirtualNetworkName>'
    hubNetworkResourceId: '<hubNetworkResourceId>'
    resourceProviders: {}
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        definition: 'Network Contributor'
        principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
        relativeScope: '<relativeScope>'
      }
    ]
    subscriptionAliasEnabled: true
    subscriptionAliasName: 'dep-sub-blzv-tests-sawan1'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: 'dep-sub-blzv-tests-sawan1'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
    virtualNetworkAddressSpace: [
      '10.210.0.0/16'
    ]
    virtualNetworkEnabled: true
    virtualNetworkLocation: '<virtualNetworkLocation>'
    virtualNetworkName: '<virtualNetworkName>'
    virtualNetworkPeeringEnabled: true
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkResourceGroupName: '<virtualNetworkResourceGroupName>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "deploymentScriptLocation": {
      "value": "<deploymentScriptLocation>"
    },
    "deploymentScriptManagedIdentityName": {
      "value": "<deploymentScriptManagedIdentityName>"
    },
    "deploymentScriptName": {
      "value": "ds-sawan1"
    },
    "deploymentScriptNetworkSecurityGroupName": {
      "value": "<deploymentScriptNetworkSecurityGroupName>"
    },
    "deploymentScriptResourceGroupName": {
      "value": "<deploymentScriptResourceGroupName>"
    },
    "deploymentScriptStorageAccountName": {
      "value": "<deploymentScriptStorageAccountName>"
    },
    "deploymentScriptVirtualNetworkName": {
      "value": "<deploymentScriptVirtualNetworkName>"
    },
    "hubNetworkResourceId": {
      "value": "<hubNetworkResourceId>"
    },
    "resourceProviders": {
      "value": {}
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "definition": "Network Contributor",
          "principalId": "896b1162-be44-4b28-888a-d01acc1b4271",
          "relativeScope": "<relativeScope>"
        }
      ]
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "dep-sub-blzv-tests-sawan1"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "dep-sub-blzv-tests-sawan1"
    },
    "subscriptionManagementGroupAssociationEnabled": {
      "value": true
    },
    "subscriptionManagementGroupId": {
      "value": "bicep-lz-vending-automation-child"
    },
    "subscriptionTags": {
      "value": {
        "namePrefix": "<namePrefix>",
        "serviceShort": "<serviceShort>"
      }
    },
    "subscriptionWorkload": {
      "value": "Production"
    },
    "virtualNetworkAddressSpace": {
      "value": [
        "10.210.0.0/16"
      ]
    },
    "virtualNetworkEnabled": {
      "value": true
    },
    "virtualNetworkLocation": {
      "value": "<virtualNetworkLocation>"
    },
    "virtualNetworkName": {
      "value": "<virtualNetworkName>"
    },
    "virtualNetworkPeeringEnabled": {
      "value": true
    },
    "virtualNetworkResourceGroupLockEnabled": {
      "value": false
    },
    "virtualNetworkResourceGroupName": {
      "value": "<virtualNetworkResourceGroupName>"
    }
  }
}
```

</details>
<p>


## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deploymentScriptLocation`](#parameter-deploymentscriptlocation) | string | The location of the deployment script. Use region shortnames e.g. uksouth, eastus, etc. |
| [`deploymentScriptManagedIdentityName`](#parameter-deploymentscriptmanagedidentityname) | string | The name of the user managed identity for the resource providers registration deployment script. |
| [`deploymentScriptName`](#parameter-deploymentscriptname) | string | The name of the deployment script to register resource providers. |
| [`deploymentScriptNetworkSecurityGroupName`](#parameter-deploymentscriptnetworksecuritygroupname) | string | The name of the network security group for the deployment script private subnet. |
| [`deploymentScriptResourceGroupName`](#parameter-deploymentscriptresourcegroupname) | string | The name of the resource group to create the deployment script for resource providers registration. |
| [`deploymentScriptStorageAccountName`](#parameter-deploymentscriptstorageaccountname) | string | The name of the storage account for the deployment script. |
| [`deploymentScriptVirtualNetworkName`](#parameter-deploymentscriptvirtualnetworkname) | string | The name of the private virtual network for the deployment script. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`existingSubscriptionId`](#parameter-existingsubscriptionid) | string | An existing subscription ID. Use this when you do not want the module to create a new subscription. But do want to manage the management group membership. A subscription ID should be provided in the example format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.<p><li>Type: String<li>Default value: `''` *(empty string)*.<p> |
| [`hubNetworkResourceId`](#parameter-hubnetworkresourceid) | string | The resource ID of the Virtual Network or Virtual WAN Hub in the hub to which the created Virtual Network, by this module, will be peered/connected to via Virtual Network Peering or a Virtual WAN Virtual Hub Connection.<p><p>**Example Expected Values:**<li>`''` (empty string)<li>Hub Virtual Network Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualNetworks/xxxxxxxxxx`<li>Virtual WAN Virtual Hub Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxxx`<p><li>Type: String<li>Default value: `''` *(empty string)*.<p> |
| [`resourceProviders`](#parameter-resourceproviders) | object | An object of resource providers and resource providers features to register. If left blank/empty, no resource providers will be registered.<p><li>Type: `{}` Object<li>Default value: `{<p>  'Microsoft.ApiManagement'             : []<p>    'Microsoft.AppPlatform'             : []<p>    'Microsoft.Authorization'           : []<p>    'Microsoft.Automation'              : []<p>    'Microsoft.AVS'                     : []<p>    'Microsoft.Blueprint'               : []<p>    'Microsoft.BotService'              : []<p>    'Microsoft.Cache'                   : []<p>    'Microsoft.Cdn'                     : []<p>    'Microsoft.CognitiveServices'       : []<p>    'Microsoft.Compute'                 : []<p>    'Microsoft.ContainerInstance'       : []<p>    'Microsoft.ContainerRegistry'       : []<p>    'Microsoft.ContainerService'        : []<p>    'Microsoft.CostManagement'          : []<p>    'Microsoft.CustomProviders'         : []<p>    'Microsoft.Databricks'              : []<p>    'Microsoft.DataLakeAnalytics'       : []<p>    'Microsoft.DataLakeStore'           : []<p>    'Microsoft.DataMigration'           : []<p>    'Microsoft.DataProtection'          : []<p>    'Microsoft.DBforMariaDB'            : []<p>    'Microsoft.DBforMySQL'              : []<p>    'Microsoft.DBforPostgreSQL'         : []<p>    'Microsoft.DesktopVirtualization'   : []<p>    'Microsoft.Devices'                 : []<p>    'Microsoft.DevTestLab'              : []<p>    'Microsoft.DocumentDB'              : []<p>    'Microsoft.EventGrid'               : []<p>    'Microsoft.EventHub'                : []<p>    'Microsoft.HDInsight'               : []<p>    'Microsoft.HealthcareApis'          : []<p>    'Microsoft.GuestConfiguration'      : []<p>    'Microsoft.KeyVault'                : []<p>    'Microsoft.Kusto'                   : []<p>    'microsoft.insights'                : []<p>    'Microsoft.Logic'                   : []<p>    'Microsoft.MachineLearningServices' : []<p>    'Microsoft.Maintenance'             : []<p>    'Microsoft.ManagedIdentity'         : []<p>    'Microsoft.ManagedServices'         : []<p>    'Microsoft.Management'              : []<p>    'Microsoft.Maps'                    : []<p>    'Microsoft.MarketplaceOrdering'     : []<p>    'Microsoft.Media'                   : []<p>    'Microsoft.MixedReality'            : []<p>    'Microsoft.Network'                 : []<p>    'Microsoft.NotificationHubs'        : []<p>    'Microsoft.OperationalInsights'     : []<p>    'Microsoft.OperationsManagement'    : []<p>    'Microsoft.PolicyInsights'          : []<p>    'Microsoft.PowerBIDedicated'        : []<p>    'Microsoft.Relay'                   : []<p>    'Microsoft.RecoveryServices'        : []<p>    'Microsoft.Resources'               : []<p>    'Microsoft.Search'                  : []<p>    'Microsoft.Security'                : []<p>    'Microsoft.SecurityInsights'        : []<p>    'Microsoft.ServiceBus'              : []<p>    'Microsoft.ServiceFabric'           : []<p>    'Microsoft.Sql'                     : []<p>    'Microsoft.Storage'                 : []<p>    'Microsoft.StreamAnalytics'         : []<p>    'Microsoft.TimeSeriesInsights'      : []<p>    'Microsoft.Web'                     : []<p>}`.<p> |
| [`roleAssignmentEnabled`](#parameter-roleassignmentenabled) | bool | Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.<p><li>Type: Boolean.<p> |
| [`roleAssignments`](#parameter-roleassignments) | array | Supply an array of objects containing the details of the role assignments to create.<p><p>Each object must contain the following `keys`:<li>`principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too.<li>`definition` = The Name of one of the pre-defined built-In RBAC Roles or a Resource ID of a Built-in or custom RBAC Role Definition as follows:<p>  - You can only provide the RBAC role name of the pre-defined roles (Contributor, Owner, Reader, Network Contributor, Role Based Access Control Administrator (Preview), User Access Administrator, Security Admin). We only provide those roles as they are the most common ones to assign to a new subscription, also to reduce the template size and complexity in case we define each and every Built-in RBAC role.<p>  - You can provide the Resource ID of a Built-in or custom RBAC Role Definition<p>    - e.g. `/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`<p>  - You can provide the RBAC role Id of a Built-in RBAC Role Definition<p>    - e.g. `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`<li>`relativeScope` = 2 options can be provided for input value:<p>    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope<p>    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group<p><p>> See below [example in parameter file](#parameter-file) of various combinations<p><li>Type: `[]` Array<li>Default value: `[]` *(empty array)*.<p> |
| [`subscriptionAliasEnabled`](#parameter-subscriptionaliasenabled) | bool | Whether to create a new Subscription using the Subscription Alias resource. If `false`, supply an existing Subscription's ID in the parameter named `existingSubscriptionId` instead to deploy resources to an existing Subscription.<p><li>Type: Boolean.<p> |
| [`subscriptionAliasName`](#parameter-subscriptionaliasname) | string | The name of the Subscription Alias, that will be created by this module.<p><p>The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**<p><li>Type: String<li>Default value: `''` *(empty string)*.<p> |
| [`subscriptionBillingScope`](#parameter-subscriptionbillingscope) | string | The Billing Scope for the new Subscription alias, that will be created by this module.<p><p>A valid Billing Scope starts with `/providers/Microsoft.Billing/billingAccounts/` and is case sensitive.<p><p>> See below [example in parameter file](#parameter-file) for an example<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**<p><li>Type: String<li>Default value: `''` *(empty string)*.<p> |
| [`subscriptionDisplayName`](#parameter-subscriptiondisplayname) | string | The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, - and _. The maximum length is 63 characters.<p><p>The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.<p><p>> The value for this parameter and the parameter named `subscriptionAliasName` are usually set to the same value for simplicity. But they can be different if required for a reason.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**<p><li>Type: String<li>Default value: `''` *(empty string)*.<p> |
| [`subscriptionManagementGroupAssociationEnabled`](#parameter-subscriptionmanagementgroupassociationenabled) | bool | Whether to move the Subscription to the specified Management Group supplied in the parameter `subscriptionManagementGroupId`.<p><li>Type: Boolean.<p> |
| [`subscriptionManagementGroupId`](#parameter-subscriptionmanagementgroupid) | string | The destination Management Group ID for the new Subscription that will be created by this module (or the existing one provided in the parameter `existingSubscriptionId`).<p><p>**IMPORTANT:** Do not supply the display name of the Management Group. The Management Group ID forms part of the Azure Resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.<p><p>> See below [example in parameter file](#parameter-file) for an example<p><li>Type: String<li>Default value: `''` *(empty string)*.<p> |
| [`subscriptionOwnerId`](#parameter-subscriptionownerid) | string | The Azure Active Directory principals object ID (GUID) to whom should be the Subscription Owner.<p><p>> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants).**<p><li>Type: String<li>Default value: `''` *(empty string)*.<p> |
| [`subscriptionTags`](#parameter-subscriptiontags) | object | An object of Tag key & value pairs to be appended to a Subscription.<p><p>> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.<p><li>Type: `{}` Object<li>Default value: `{}` *(empty object)*.<p> |
| [`subscriptionTenantId`](#parameter-subscriptiontenantid) | string | The Azure Active Directory Tenant ID (GUID) to which the Subscription should be attached to.<p><p>> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants).**<p><li>Type: String<li>Default value: `''` *(empty string)*.<p> |
| [`subscriptionWorkload`](#parameter-subscriptionworkload) | string | The workload type can be either `Production` or `DevTest` and is case sensitive.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**<p><li>Type: String.<p> |
| [`vHubRoutingIntentEnabled`](#parameter-vhubroutingintentenabled) | bool | Indicates whether routing intent is enabled on the Virtual Hub within the Virtual WAN.<p><li>Type: Boolean.<p> |
| [`virtualNetworkAddressSpace`](#parameter-virtualnetworkaddressspace) | array | The address space of the Virtual Network that will be created by this module, supplied as multiple CIDR blocks in an array, e.g. `["10.0.0.0/16","172.16.0.0/12"]`<p><li>Type: `[]` Array<li>Default value: `[]` *(empty array)*.<p> |
| [`virtualNetworkDdosPlanId`](#parameter-virtualnetworkddosplanid) | string | The resource ID of an existing DDoS Network Protection Plan that you wish to link to this Virtual Network.<p><p>**Example Expected Values:**<li>`''` (empty string)<li>DDoS Netowrk Protection Plan Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/ddosProtectionPlans/xxxxxxxxxx`<p><li>Type: String<li>Default value: `''` *(empty string)*.<p> |
| [`virtualNetworkDeploymentScriptAddressPrefix`](#parameter-virtualnetworkdeploymentscriptaddressprefix) | string | The address prefix of the private virtual network for the deployment script. |
| [`virtualNetworkDnsServers`](#parameter-virtualnetworkdnsservers) | array | The custom DNS servers to use on the Virtual Network, e.g. `["10.4.1.4", "10.2.1.5"]`. If left empty (default) then Azure DNS will be used for the Virtual Network.<p><li>Type: `[]` Array<li>Default value: `[]` *(empty array)*.<p> |
| [`virtualNetworkEnabled`](#parameter-virtualnetworkenabled) | bool | Whether to create a Virtual Network or not.<p><p>If set to `true` ensure you also provide values for the following parameters at a minimum:<p><li>`virtualNetworkResourceGroupName`<li>`virtualNetworkResourceGroupLockEnabled`<li>`virtualNetworkLocation`<li>`virtualNetworkName`<li>`virtualNetworkAddressSpace`<p><p>> Other parameters may need to be set based on other parameters that you enable that are listed above. Check each parameters documentation for further information.<p><li>Type: Boolean.<p> |
| [`virtualNetworkLocation`](#parameter-virtualnetworklocation) | string | The location of the virtual network. Use region shortnames e.g. `uksouth`, `eastus`, etc. Defaults to the region where the ARM/Bicep deployment is targeted to unless overridden.<p><li>Type: String.<p> |
| [`virtualNetworkName`](#parameter-virtualnetworkname) | string | The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.<p><li>Type: String<li>Default value: `''` *(empty string)*.<p> |
| [`virtualNetworkPeeringEnabled`](#parameter-virtualnetworkpeeringenabled) | bool | Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.<p><li>Type: Boolean.<p> |
| [`virtualNetworkResourceGroupLockEnabled`](#parameter-virtualnetworkresourcegrouplockenabled) | bool | Enables the deployment of a `CanNotDelete` resource locks to the Virtual Networks Resource Group that is created by this module.<p><li>Type: Boolean.<p> |
| [`virtualNetworkResourceGroupName`](#parameter-virtualnetworkresourcegroupname) | string | The name of the Resource Group to create the Virtual Network in that is created by this module.<p><li>Type: String<li>Default value: `''` *(empty string)*.<p> |
| [`virtualNetworkResourceGroupTags`](#parameter-virtualnetworkresourcegrouptags) | object | An object of Tag key & value pairs to be appended to the Resource Group that the Virtual Network is created in.<p><p>> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.<p><li>Type: `{}` Object<li>Default value: `{}` *(empty object)*.<p> |
| [`virtualNetworkTags`](#parameter-virtualnetworktags) | object | An object of tag key/value pairs to be set on the Virtual Network that is created.<p><p>> **NOTE:** Tags will be overwritten on resource if any exist already.<p><li>Type: `{}` Object<li>Default value: `{}` *(empty object)*.<p> |
| [`virtualNetworkUseRemoteGateways`](#parameter-virtualnetworkuseremotegateways) | bool | Enables the use of remote gateways in the specified hub virtual network.<p><p>> **IMPORTANT:** If no gateways exist in the hub virtual network, set this to `false`, otherwise peering will fail to create.<p><li>Type: Boolean.<p> |
| [`virtualNetworkVwanAssociatedRouteTableResourceId`](#parameter-virtualnetworkvwanassociatedroutetableresourceid) | string | The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty the `defaultRouteTable` will be associated.<p><li>Type: String<li>Default value: `''` *(empty string)* = Which means if the parameter `virtualNetworkPeeringEnabled` is `true` and also the parameter `hubNetworkResourceId` is not empty then the `defaultRouteTable` will be associated of the provided Virtual Hub in the parameter `hubNetworkResourceId`.<p>    - e.g. `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/defaultRouteTable`.<p> |
| [`virtualNetworkVwanEnableInternetSecurity`](#parameter-virtualnetworkvwanenableinternetsecurity) | bool | Enables the ability for the Virtual WAN Hub Connection to learn the default route 0.0.0.0/0 from the Hub.<p><li>Type: Boolean.<p> |
| [`virtualNetworkVwanPropagatedLabels`](#parameter-virtualnetworkvwanpropagatedlabels) | array | An array of virtual hub route table labels to propagate routes to. If left blank/empty the default label will be propagated to only.<p><li>Type: `[]` Array<li>Default value: `[]` *(empty array)*.<p> |
| [`virtualNetworkVwanPropagatedRouteTablesResourceIds`](#parameter-virtualnetworkvwanpropagatedroutetablesresourceids) | array | An array of of objects of virtual hub route table resource IDs to propagate routes to. If left blank/empty the `defaultRouteTable` will be propagated to only.<p><p>Each object must contain the following `key`:<li>`id` = The Resource ID of the Virtual WAN Virtual Hub Route Table IDs you wish to propagate too<p><p>> See below [example in parameter file](#parameter-file)<p><p>> **IMPORTANT:** If you provide any Route Tables in this array of objects you must ensure you include also the `defaultRouteTable` Resource ID as an object in the array as it is not added by default when a value is provided for this parameter.<p><li>Type: `[]` Array<li>Default value: `[]` *(empty array)*.<p> |

### Parameter: `deploymentScriptLocation`

The location of the deployment script. Use region shortnames e.g. uksouth, eastus, etc.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `deploymentScriptManagedIdentityName`

The name of the user managed identity for the resource providers registration deployment script.

- Required: No
- Type: string
- Default: `[format('id-{0}', deployment().location)]`

### Parameter: `deploymentScriptName`

The name of the deployment script to register resource providers.

- Required: No
- Type: string
- Default: `[format('ds-{0}', deployment().location)]`

### Parameter: `deploymentScriptNetworkSecurityGroupName`

The name of the network security group for the deployment script private subnet.

- Required: No
- Type: string
- Default: `[format('nsg-{0}', deployment().location)]`

### Parameter: `deploymentScriptResourceGroupName`

The name of the resource group to create the deployment script for resource providers registration.

- Required: No
- Type: string
- Default: `[format('rsg-{0}-ds', deployment().location)]`

### Parameter: `deploymentScriptStorageAccountName`

The name of the storage account for the deployment script.

- Required: No
- Type: string
- Default: `[format('stgds{0}', substring(uniqueString(deployment().name, parameters('virtualNetworkLocation')), 0, 4))]`

### Parameter: `deploymentScriptVirtualNetworkName`

The name of the private virtual network for the deployment script. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.

- Required: No
- Type: string
- Default: `[format('vnet-{0}', deployment().location)]`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `existingSubscriptionId`

An existing subscription ID. Use this when you do not want the module to create a new subscription. But do want to manage the management group membership. A subscription ID should be provided in the example format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.<p><li>Type: String<li>Default value: `''` *(empty string)*.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `hubNetworkResourceId`

The resource ID of the Virtual Network or Virtual WAN Hub in the hub to which the created Virtual Network, by this module, will be peered/connected to via Virtual Network Peering or a Virtual WAN Virtual Hub Connection.<p><p>**Example Expected Values:**<li>`''` (empty string)<li>Hub Virtual Network Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualNetworks/xxxxxxxxxx`<li>Virtual WAN Virtual Hub Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxxx`<p><li>Type: String<li>Default value: `''` *(empty string)*.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `resourceProviders`

An object of resource providers and resource providers features to register. If left blank/empty, no resource providers will be registered.<p><li>Type: `{}` Object<li>Default value: `{<p>  'Microsoft.ApiManagement'             : []<p>    'Microsoft.AppPlatform'             : []<p>    'Microsoft.Authorization'           : []<p>    'Microsoft.Automation'              : []<p>    'Microsoft.AVS'                     : []<p>    'Microsoft.Blueprint'               : []<p>    'Microsoft.BotService'              : []<p>    'Microsoft.Cache'                   : []<p>    'Microsoft.Cdn'                     : []<p>    'Microsoft.CognitiveServices'       : []<p>    'Microsoft.Compute'                 : []<p>    'Microsoft.ContainerInstance'       : []<p>    'Microsoft.ContainerRegistry'       : []<p>    'Microsoft.ContainerService'        : []<p>    'Microsoft.CostManagement'          : []<p>    'Microsoft.CustomProviders'         : []<p>    'Microsoft.Databricks'              : []<p>    'Microsoft.DataLakeAnalytics'       : []<p>    'Microsoft.DataLakeStore'           : []<p>    'Microsoft.DataMigration'           : []<p>    'Microsoft.DataProtection'          : []<p>    'Microsoft.DBforMariaDB'            : []<p>    'Microsoft.DBforMySQL'              : []<p>    'Microsoft.DBforPostgreSQL'         : []<p>    'Microsoft.DesktopVirtualization'   : []<p>    'Microsoft.Devices'                 : []<p>    'Microsoft.DevTestLab'              : []<p>    'Microsoft.DocumentDB'              : []<p>    'Microsoft.EventGrid'               : []<p>    'Microsoft.EventHub'                : []<p>    'Microsoft.HDInsight'               : []<p>    'Microsoft.HealthcareApis'          : []<p>    'Microsoft.GuestConfiguration'      : []<p>    'Microsoft.KeyVault'                : []<p>    'Microsoft.Kusto'                   : []<p>    'microsoft.insights'                : []<p>    'Microsoft.Logic'                   : []<p>    'Microsoft.MachineLearningServices' : []<p>    'Microsoft.Maintenance'             : []<p>    'Microsoft.ManagedIdentity'         : []<p>    'Microsoft.ManagedServices'         : []<p>    'Microsoft.Management'              : []<p>    'Microsoft.Maps'                    : []<p>    'Microsoft.MarketplaceOrdering'     : []<p>    'Microsoft.Media'                   : []<p>    'Microsoft.MixedReality'            : []<p>    'Microsoft.Network'                 : []<p>    'Microsoft.NotificationHubs'        : []<p>    'Microsoft.OperationalInsights'     : []<p>    'Microsoft.OperationsManagement'    : []<p>    'Microsoft.PolicyInsights'          : []<p>    'Microsoft.PowerBIDedicated'        : []<p>    'Microsoft.Relay'                   : []<p>    'Microsoft.RecoveryServices'        : []<p>    'Microsoft.Resources'               : []<p>    'Microsoft.Search'                  : []<p>    'Microsoft.Security'                : []<p>    'Microsoft.SecurityInsights'        : []<p>    'Microsoft.ServiceBus'              : []<p>    'Microsoft.ServiceFabric'           : []<p>    'Microsoft.Sql'                     : []<p>    'Microsoft.Storage'                 : []<p>    'Microsoft.StreamAnalytics'         : []<p>    'Microsoft.TimeSeriesInsights'      : []<p>    'Microsoft.Web'                     : []<p>}`.<p>

- Required: No
- Type: object
- Default:
  ```Bicep
  {
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
      'Microsoft.GuestConfiguration': []
      'Microsoft.HDInsight': []
      'Microsoft.HealthcareApis': []
      'microsoft.insights': []
      'Microsoft.KeyVault': []
      'Microsoft.Kusto': []
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
      'Microsoft.RecoveryServices': []
      'Microsoft.Relay': []
      'Microsoft.Resources': []
      'Microsoft.Search': []
      'Microsoft.Security': []
      'Microsoft.SecurityInsights': []
      'Microsoft.ServiceBus': []
      'Microsoft.ServiceFabric': []
      'Microsoft.Sql': []
      'Microsoft.Storage': []
      'Microsoft.StreamAnalytics': []
      'Microsoft.TimeSeriesInsights': []
      'Microsoft.Web': []
  }
  ```

### Parameter: `roleAssignmentEnabled`

Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.<p><li>Type: Boolean.<p>

- Required: No
- Type: bool
- Default: `False`

### Parameter: `roleAssignments`

Supply an array of objects containing the details of the role assignments to create.<p><p>Each object must contain the following `keys`:<li>`principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too.<li>`definition` = The Name of one of the pre-defined built-In RBAC Roles or a Resource ID of a Built-in or custom RBAC Role Definition as follows:<p>  - You can only provide the RBAC role name of the pre-defined roles (Contributor, Owner, Reader, Network Contributor, Role Based Access Control Administrator (Preview), User Access Administrator, Security Admin). We only provide those roles as they are the most common ones to assign to a new subscription, also to reduce the template size and complexity in case we define each and every Built-in RBAC role.<p>  - You can provide the Resource ID of a Built-in or custom RBAC Role Definition<p>    - e.g. `/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`<p>  - You can provide the RBAC role Id of a Built-in RBAC Role Definition<p>    - e.g. `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`<li>`relativeScope` = 2 options can be provided for input value:<p>    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope<p>    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group<p><p>> See below [example in parameter file](#parameter-file) of various combinations<p><li>Type: `[]` Array<li>Default value: `[]` *(empty array)*.<p>

- Required: No
- Type: array
- Default: `[]`

### Parameter: `subscriptionAliasEnabled`

Whether to create a new Subscription using the Subscription Alias resource. If `false`, supply an existing Subscription's ID in the parameter named `existingSubscriptionId` instead to deploy resources to an existing Subscription.<p><li>Type: Boolean.<p>

- Required: No
- Type: bool
- Default: `True`

### Parameter: `subscriptionAliasName`

The name of the Subscription Alias, that will be created by this module.<p><p>The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**<p><li>Type: String<li>Default value: `''` *(empty string)*.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionBillingScope`

The Billing Scope for the new Subscription alias, that will be created by this module.<p><p>A valid Billing Scope starts with `/providers/Microsoft.Billing/billingAccounts/` and is case sensitive.<p><p>> See below [example in parameter file](#parameter-file) for an example<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**<p><li>Type: String<li>Default value: `''` *(empty string)*.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionDisplayName`

The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, - and _. The maximum length is 63 characters.<p><p>The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.<p><p>> The value for this parameter and the parameter named `subscriptionAliasName` are usually set to the same value for simplicity. But they can be different if required for a reason.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**<p><li>Type: String<li>Default value: `''` *(empty string)*.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionManagementGroupAssociationEnabled`

Whether to move the Subscription to the specified Management Group supplied in the parameter `subscriptionManagementGroupId`.<p><li>Type: Boolean.<p>

- Required: No
- Type: bool
- Default: `True`

### Parameter: `subscriptionManagementGroupId`

The destination Management Group ID for the new Subscription that will be created by this module (or the existing one provided in the parameter `existingSubscriptionId`).<p><p>**IMPORTANT:** Do not supply the display name of the Management Group. The Management Group ID forms part of the Azure Resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.<p><p>> See below [example in parameter file](#parameter-file) for an example<p><li>Type: String<li>Default value: `''` *(empty string)*.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionOwnerId`

The Azure Active Directory principals object ID (GUID) to whom should be the Subscription Owner.<p><p>> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants).**<p><li>Type: String<li>Default value: `''` *(empty string)*.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionTags`

An object of Tag key & value pairs to be appended to a Subscription.<p><p>> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.<p><li>Type: `{}` Object<li>Default value: `{}` *(empty object)*.<p>

- Required: No
- Type: object
- Default: `{}`

### Parameter: `subscriptionTenantId`

The Azure Active Directory Tenant ID (GUID) to which the Subscription should be attached to.<p><p>> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants).**<p><li>Type: String<li>Default value: `''` *(empty string)*.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionWorkload`

The workload type can be either `Production` or `DevTest` and is case sensitive.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**<p><li>Type: String.<p>

- Required: No
- Type: string
- Default: `'Production'`
- Allowed:
  ```Bicep
  [
    'DevTest'
    'Production'
  ]
  ```

### Parameter: `vHubRoutingIntentEnabled`

Indicates whether routing intent is enabled on the Virtual Hub within the Virtual WAN.<p><li>Type: Boolean.<p>

- Required: No
- Type: bool
- Default: `False`

### Parameter: `virtualNetworkAddressSpace`

The address space of the Virtual Network that will be created by this module, supplied as multiple CIDR blocks in an array, e.g. `["10.0.0.0/16","172.16.0.0/12"]`<p><li>Type: `[]` Array<li>Default value: `[]` *(empty array)*.<p>

- Required: No
- Type: array
- Default: `[]`

### Parameter: `virtualNetworkDdosPlanId`

The resource ID of an existing DDoS Network Protection Plan that you wish to link to this Virtual Network.<p><p>**Example Expected Values:**<li>`''` (empty string)<li>DDoS Netowrk Protection Plan Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/ddosProtectionPlans/xxxxxxxxxx`<p><li>Type: String<li>Default value: `''` *(empty string)*.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `virtualNetworkDeploymentScriptAddressPrefix`

The address prefix of the private virtual network for the deployment script.

- Required: No
- Type: string
- Default: `'192.168.0.0/24'`

### Parameter: `virtualNetworkDnsServers`

The custom DNS servers to use on the Virtual Network, e.g. `["10.4.1.4", "10.2.1.5"]`. If left empty (default) then Azure DNS will be used for the Virtual Network.<p><li>Type: `[]` Array<li>Default value: `[]` *(empty array)*.<p>

- Required: No
- Type: array
- Default: `[]`

### Parameter: `virtualNetworkEnabled`

Whether to create a Virtual Network or not.<p><p>If set to `true` ensure you also provide values for the following parameters at a minimum:<p><li>`virtualNetworkResourceGroupName`<li>`virtualNetworkResourceGroupLockEnabled`<li>`virtualNetworkLocation`<li>`virtualNetworkName`<li>`virtualNetworkAddressSpace`<p><p>> Other parameters may need to be set based on other parameters that you enable that are listed above. Check each parameters documentation for further information.<p><li>Type: Boolean.<p>

- Required: No
- Type: bool
- Default: `False`

### Parameter: `virtualNetworkLocation`

The location of the virtual network. Use region shortnames e.g. `uksouth`, `eastus`, etc. Defaults to the region where the ARM/Bicep deployment is targeted to unless overridden.<p><li>Type: String.<p>

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `virtualNetworkName`

The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.<p><li>Type: String<li>Default value: `''` *(empty string)*.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `virtualNetworkPeeringEnabled`

Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.<p><li>Type: Boolean.<p>

- Required: No
- Type: bool
- Default: `False`

### Parameter: `virtualNetworkResourceGroupLockEnabled`

Enables the deployment of a `CanNotDelete` resource locks to the Virtual Networks Resource Group that is created by this module.<p><li>Type: Boolean.<p>

- Required: No
- Type: bool
- Default: `True`

### Parameter: `virtualNetworkResourceGroupName`

The name of the Resource Group to create the Virtual Network in that is created by this module.<p><li>Type: String<li>Default value: `''` *(empty string)*.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `virtualNetworkResourceGroupTags`

An object of Tag key & value pairs to be appended to the Resource Group that the Virtual Network is created in.<p><p>> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.<p><li>Type: `{}` Object<li>Default value: `{}` *(empty object)*.<p>

- Required: No
- Type: object
- Default: `{}`

### Parameter: `virtualNetworkTags`

An object of tag key/value pairs to be set on the Virtual Network that is created.<p><p>> **NOTE:** Tags will be overwritten on resource if any exist already.<p><li>Type: `{}` Object<li>Default value: `{}` *(empty object)*.<p>

- Required: No
- Type: object
- Default: `{}`

### Parameter: `virtualNetworkUseRemoteGateways`

Enables the use of remote gateways in the specified hub virtual network.<p><p>> **IMPORTANT:** If no gateways exist in the hub virtual network, set this to `false`, otherwise peering will fail to create.<p><li>Type: Boolean.<p>

- Required: No
- Type: bool
- Default: `True`

### Parameter: `virtualNetworkVwanAssociatedRouteTableResourceId`

The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty the `defaultRouteTable` will be associated.<p><li>Type: String<li>Default value: `''` *(empty string)* = Which means if the parameter `virtualNetworkPeeringEnabled` is `true` and also the parameter `hubNetworkResourceId` is not empty then the `defaultRouteTable` will be associated of the provided Virtual Hub in the parameter `hubNetworkResourceId`.<p>    - e.g. `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/defaultRouteTable`.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `virtualNetworkVwanEnableInternetSecurity`

Enables the ability for the Virtual WAN Hub Connection to learn the default route 0.0.0.0/0 from the Hub.<p><li>Type: Boolean.<p>

- Required: No
- Type: bool
- Default: `True`

### Parameter: `virtualNetworkVwanPropagatedLabels`

An array of virtual hub route table labels to propagate routes to. If left blank/empty the default label will be propagated to only.<p><li>Type: `[]` Array<li>Default value: `[]` *(empty array)*.<p>

- Required: No
- Type: array
- Default: `[]`

### Parameter: `virtualNetworkVwanPropagatedRouteTablesResourceIds`

An array of of objects of virtual hub route table resource IDs to propagate routes to. If left blank/empty the `defaultRouteTable` will be propagated to only.<p><p>Each object must contain the following `key`:<li>`id` = The Resource ID of the Virtual WAN Virtual Hub Route Table IDs you wish to propagate too<p><p>> See below [example in parameter file](#parameter-file)<p><p>> **IMPORTANT:** If you provide any Route Tables in this array of objects you must ensure you include also the `defaultRouteTable` Resource ID as an object in the array as it is not added by default when a value is provided for this parameter.<p><li>Type: `[]` Array<li>Default value: `[]` *(empty array)*.<p>

- Required: No
- Type: array
- Default: `[]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `failedResourceProviders` | string | The resource providers that failed to register. |
| `failedResourceProvidersFeatures` | string | The resource providers features that failed to register. |
| `subscriptionAcceptOwnershipState` | string | The Subscription Owner State. Only used when creating MCA Subscriptions across tenants. |
| `subscriptionAcceptOwnershipUrl` | string | The Subscription Ownership URL. Only used when creating MCA Subscriptions across tenants. |
| `subscriptionId` | string | The Subscription ID that has been created or provided. |
| `subscriptionResourceId` | string | The Subscription Resource ID that has been created or provided. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.1.0` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.1.0` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.1.0` | Remote reference |
| `br/public:avm/res/resources/deployment-script:0.1.0` | Remote reference |
| `br/public:avm/res/resources/resource-group:0.2.0` | Remote reference |
| `br/public:avm/res/resources/resource-group:0.2.3` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.5.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

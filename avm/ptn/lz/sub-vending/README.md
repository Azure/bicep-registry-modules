# Sub-vending `[Lz/SubVending]`

This module deploys a subscription to accelerate deployment of landing zones. For more information on how to use it, please visit this [Wiki](https://github.com/Azure/bicep-lz-vending/wiki).

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Authorization/roleAssignmentScheduleRequests` | [2022-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01-preview/roleAssignmentScheduleRequests) |
| `Microsoft.Authorization/roleEligibilityScheduleRequests` | [2022-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01-preview/roleEligibilityScheduleRequests) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults/secrets` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities/federatedIdentityCredentials) |
| `Microsoft.Management/managementGroups/subscriptions` | [2021-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Management/2021-04-01/managementGroups/subscriptions) |
| `Microsoft.Network/bastionHosts` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/bastionHosts) |
| `Microsoft.Network/natGateways` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/natGateways) |
| `Microsoft.Network/networkSecurityGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups) |
| `Microsoft.Network/privateDnsZones` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones) |
| `Microsoft.Network/privateDnsZones/A` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/A) |
| `Microsoft.Network/privateDnsZones/AAAA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/AAAA) |
| `Microsoft.Network/privateDnsZones/CNAME` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/CNAME) |
| `Microsoft.Network/privateDnsZones/MX` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/MX) |
| `Microsoft.Network/privateDnsZones/PTR` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/PTR) |
| `Microsoft.Network/privateDnsZones/SOA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SOA) |
| `Microsoft.Network/privateDnsZones/SRV` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SRV) |
| `Microsoft.Network/privateDnsZones/TXT` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/TXT) |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2024-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones/virtualNetworkLinks) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/publicIPAddresses` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-09-01/publicIPAddresses) |
| `Microsoft.Network/publicIPPrefixes` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-09-01/publicIPPrefixes) |
| `Microsoft.Network/virtualHubs/hubVirtualNetworkConnections` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualHubs/hubVirtualNetworkConnections) |
| `Microsoft.Network/virtualNetworks` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/virtualNetworkPeerings) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |
| `Microsoft.Resources/resourceGroups` | [2021-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2021-04-01/resourceGroups) |
| `Microsoft.Resources/tags` | [2019-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2019-10-01/tags) |
| `Microsoft.Storage/storageAccounts` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-05-01/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/tableServices/tables) |
| `Microsoft.Subscription/aliases` | [2021-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Subscription/2021-10-01/aliases) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/lz/sub-vending:<version>`.

- [Deploy subscription with Bastion.](#example-1-deploy-subscription-with-bastion)
- [Using only defaults.](#example-2-using-only-defaults)
- [Hub and spoke topology.](#example-3-hub-and-spoke-topology)
- [Hub and spoke topology with NAT gateway.](#example-4-hub-and-spoke-topology-with-nat-gateway)
- [Using PIM Active Role assignments.](#example-5-using-pim-active-role-assignments)
- [Using PIM Eligible Role assignments.](#example-6-using-pim-eligible-role-assignments)
- [Using RBAC conditions.](#example-7-using-rbac-conditions)
- [Vwan topology.](#example-8-vwan-topology)

### Example 1: _Deploy subscription with Bastion._

This instance deploys a subscription with a bastion host.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    resourceProviders: {}
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
    virtualNetworkAddressSpace: [
      '10.130.0.0/16'
    ]
    virtualNetworkBastionConfiguration: {
      bastionSku: 'Standard'
      name: '<name>'
    }
    virtualNetworkDeployBastion: true
    virtualNetworkEnabled: true
    virtualNetworkLocation: '<virtualNetworkLocation>'
    virtualNetworkName: '<virtualNetworkName>'
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkResourceGroupName: '<virtualNetworkResourceGroupName>'
    virtualNetworkSubnets: [
      {
        addressPrefix: '10.130.1.0/24'
        name: 'Subnet1'
      }
      {
        addressPrefix: '10.130.0.0/26'
        name: 'AzureBastionSubnet'
      }
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "resourceProviders": {
      "value": {}
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
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
        "10.130.0.0/16"
      ]
    },
    "virtualNetworkBastionConfiguration": {
      "value": {
        "bastionSku": "Standard",
        "name": "<name>"
      }
    },
    "virtualNetworkDeployBastion": {
      "value": true
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
    "virtualNetworkResourceGroupLockEnabled": {
      "value": false
    },
    "virtualNetworkResourceGroupName": {
      "value": "<virtualNetworkResourceGroupName>"
    },
    "virtualNetworkSubnets": {
      "value": [
        {
          "addressPrefix": "10.130.1.0/24",
          "name": "Subnet1"
        },
        {
          "addressPrefix": "10.130.0.0/26",
          "name": "AzureBastionSubnet"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param resourceProviders = {}
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
param virtualNetworkAddressSpace = [
  '10.130.0.0/16'
]
param virtualNetworkBastionConfiguration = {
  bastionSku: 'Standard'
  name: '<name>'
}
param virtualNetworkDeployBastion = true
param virtualNetworkEnabled = true
param virtualNetworkLocation = '<virtualNetworkLocation>'
param virtualNetworkName = '<virtualNetworkName>'
param virtualNetworkResourceGroupLockEnabled = false
param virtualNetworkResourceGroupName = '<virtualNetworkResourceGroupName>'
param virtualNetworkSubnets = [
  {
    addressPrefix: '10.130.1.0/24'
    name: 'Subnet1'
  }
  {
    addressPrefix: '10.130.0.0/26'
    name: 'AzureBastionSubnet'
  }
]
```

</details>
<p>

### Example 2: _Using only defaults._

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    resourceProviders: {}
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "resourceProviders": {
      "value": {}
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
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
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param resourceProviders = {}
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
```

</details>
<p>

### Example 3: _Hub and spoke topology._

This instance deploys a subscription with a hub-spoke network topology.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    deploymentScriptLocation: '<deploymentScriptLocation>'
    deploymentScriptManagedIdentityName: '<deploymentScriptManagedIdentityName>'
    deploymentScriptName: 'ds-ssahs'
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
      'Microsoft.Network': []
    }
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        definition: '/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
        principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
        relativeScope: '<relativeScope>'
      }
    ]
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
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
    virtualNetworkSubnets: [
      {
        addressPrefix: '10.110.1.0/24'
        name: 'Subnet1'
      }
    ]
    virtualNetworkUseRemoteGateways: false
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

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
      "value": "ds-ssahs"
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
        ],
        "Microsoft.Network": []
      }
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "definition": "/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7",
          "principalId": "896b1162-be44-4b28-888a-d01acc1b4271",
          "relativeScope": "<relativeScope>"
        }
      ]
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
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
    "virtualNetworkSubnets": {
      "value": [
        {
          "addressPrefix": "10.110.1.0/24",
          "name": "Subnet1"
        }
      ]
    },
    "virtualNetworkUseRemoteGateways": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param deploymentScriptLocation = '<deploymentScriptLocation>'
param deploymentScriptManagedIdentityName = '<deploymentScriptManagedIdentityName>'
param deploymentScriptName = 'ds-ssahs'
param deploymentScriptNetworkSecurityGroupName = '<deploymentScriptNetworkSecurityGroupName>'
param deploymentScriptResourceGroupName = '<deploymentScriptResourceGroupName>'
param deploymentScriptStorageAccountName = '<deploymentScriptStorageAccountName>'
param deploymentScriptVirtualNetworkName = '<deploymentScriptVirtualNetworkName>'
param hubNetworkResourceId = '<hubNetworkResourceId>'
param resourceProviders = {
  'Microsoft.AVS': [
    'AzureServicesVm'
  ]
  'Microsoft.HybridCompute': [
    'ArcServerPrivateLinkPreview'
  ]
  'Microsoft.Network': []
}
param roleAssignmentEnabled = true
param roleAssignments = [
  {
    definition: '/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
    principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
    relativeScope: '<relativeScope>'
  }
]
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
param virtualNetworkAddressSpace = [
  '10.110.0.0/16'
]
param virtualNetworkEnabled = true
param virtualNetworkLocation = '<virtualNetworkLocation>'
param virtualNetworkName = '<virtualNetworkName>'
param virtualNetworkPeeringEnabled = true
param virtualNetworkResourceGroupLockEnabled = false
param virtualNetworkResourceGroupName = '<virtualNetworkResourceGroupName>'
param virtualNetworkSubnets = [
  {
    addressPrefix: '10.110.1.0/24'
    name: 'Subnet1'
  }
]
param virtualNetworkUseRemoteGateways = false
```

</details>
<p>

### Example 4: _Hub and spoke topology with NAT gateway._

This instance deploys a subscription with a hub-spoke network topology with NAT gateway.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    resourceProviders: {
      'Microsoft.Network': []
    }
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        definition: '/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
        principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
        relativeScope: '<relativeScope>'
      }
    ]
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
    virtualNetworkAddressSpace: [
      '10.120.0.0/16'
    ]
    virtualNetworkDeployNatGateway: true
    virtualNetworkEnabled: true
    virtualNetworkLocation: '<virtualNetworkLocation>'
    virtualNetworkName: '<virtualNetworkName>'
    virtualNetworkNatGatewayConfiguration: {
      name: '<name>'
      publicIPAddressProperties: [
        {
          name: '<name>'
          zones: [
            1
            2
            3
          ]
        }
      ]
    }
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkResourceGroupName: '<virtualNetworkResourceGroupName>'
    virtualNetworkSubnets: [
      {
        addressPrefix: '10.120.1.0/24'
        associateWithNatGateway: true
        name: 'Subnet1'
      }
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "resourceProviders": {
      "value": {
        "Microsoft.Network": []
      }
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "definition": "/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7",
          "principalId": "896b1162-be44-4b28-888a-d01acc1b4271",
          "relativeScope": "<relativeScope>"
        }
      ]
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
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
        "10.120.0.0/16"
      ]
    },
    "virtualNetworkDeployNatGateway": {
      "value": true
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
    "virtualNetworkNatGatewayConfiguration": {
      "value": {
        "name": "<name>",
        "publicIPAddressProperties": [
          {
            "name": "<name>",
            "zones": [
              1,
              2,
              3
            ]
          }
        ]
      }
    },
    "virtualNetworkResourceGroupLockEnabled": {
      "value": false
    },
    "virtualNetworkResourceGroupName": {
      "value": "<virtualNetworkResourceGroupName>"
    },
    "virtualNetworkSubnets": {
      "value": [
        {
          "addressPrefix": "10.120.1.0/24",
          "associateWithNatGateway": true,
          "name": "Subnet1"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param resourceProviders = {
  'Microsoft.Network': []
}
param roleAssignmentEnabled = true
param roleAssignments = [
  {
    definition: '/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
    principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
    relativeScope: '<relativeScope>'
  }
]
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
param virtualNetworkAddressSpace = [
  '10.120.0.0/16'
]
param virtualNetworkDeployNatGateway = true
param virtualNetworkEnabled = true
param virtualNetworkLocation = '<virtualNetworkLocation>'
param virtualNetworkName = '<virtualNetworkName>'
param virtualNetworkNatGatewayConfiguration = {
  name: '<name>'
  publicIPAddressProperties: [
    {
      name: '<name>'
      zones: [
        1
        2
        3
      ]
    }
  ]
}
param virtualNetworkResourceGroupLockEnabled = false
param virtualNetworkResourceGroupName = '<virtualNetworkResourceGroupName>'
param virtualNetworkSubnets = [
  {
    addressPrefix: '10.120.1.0/24'
    associateWithNatGateway: true
    name: 'Subnet1'
  }
]
```

</details>
<p>

### Example 5: _Using PIM Active Role assignments._

This instance deploys the module with PIM Active Role assignments.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    pimRoleAssignments: [
      {
        definition: '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
        principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
        relativeScope: '<relativeScope>'
        roleAssignmentType: 'Eligible'
        scheduleInfo: {
          duration: 'PT4H'
          durationType: 'AfterDuration'
          startTime: '<startTime>'
        }
      }
    ]
    resourceProviders: {}
    roleAssignmentEnabled: true
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
    virtualNetworkAddressSpace: [
      '10.140.0.0/16'
    ]
    virtualNetworkEnabled: true
    virtualNetworkLocation: '<virtualNetworkLocation>'
    virtualNetworkName: '<virtualNetworkName>'
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkResourceGroupName: '<virtualNetworkResourceGroupName>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "pimRoleAssignments": {
      "value": [
        {
          "definition": "/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168",
          "principalId": "896b1162-be44-4b28-888a-d01acc1b4271",
          "relativeScope": "<relativeScope>",
          "roleAssignmentType": "Eligible",
          "scheduleInfo": {
            "duration": "PT4H",
            "durationType": "AfterDuration",
            "startTime": "<startTime>"
          }
        }
      ]
    },
    "resourceProviders": {
      "value": {}
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
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
        "10.140.0.0/16"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param pimRoleAssignments = [
  {
    definition: '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
    principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
    relativeScope: '<relativeScope>'
    roleAssignmentType: 'Eligible'
    scheduleInfo: {
      duration: 'PT4H'
      durationType: 'AfterDuration'
      startTime: '<startTime>'
    }
  }
]
param resourceProviders = {}
param roleAssignmentEnabled = true
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
param virtualNetworkAddressSpace = [
  '10.140.0.0/16'
]
param virtualNetworkEnabled = true
param virtualNetworkLocation = '<virtualNetworkLocation>'
param virtualNetworkName = '<virtualNetworkName>'
param virtualNetworkResourceGroupLockEnabled = false
param virtualNetworkResourceGroupName = '<virtualNetworkResourceGroupName>'
```

</details>
<p>

### Example 6: _Using PIM Eligible Role assignments._

This instance deploys the module with PIM Eligible Role assignments.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    pimRoleAssignments: [
      {
        definition: '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
        principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
        relativeScope: ''
        roleAssignmentType: 'Eligible'
        scheduleInfo: {
          duration: 'PT4H'
          durationType: 'AfterDuration'
          startTime: '<startTime>'
        }
      }
    ]
    resourceProviders: {}
    roleAssignmentEnabled: true
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
    virtualNetworkEnabled: true
    virtualNetworkLocation: '<virtualNetworkLocation>'
    virtualNetworkName: '<virtualNetworkName>'
    virtualNetworkResourceGroupName: '<virtualNetworkResourceGroupName>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "pimRoleAssignments": {
      "value": [
        {
          "definition": "/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168",
          "principalId": "896b1162-be44-4b28-888a-d01acc1b4271",
          "relativeScope": "",
          "roleAssignmentType": "Eligible",
          "scheduleInfo": {
            "duration": "PT4H",
            "durationType": "AfterDuration",
            "startTime": "<startTime>"
          }
        }
      ]
    },
    "resourceProviders": {
      "value": {}
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
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
      "value": true
    },
    "virtualNetworkLocation": {
      "value": "<virtualNetworkLocation>"
    },
    "virtualNetworkName": {
      "value": "<virtualNetworkName>"
    },
    "virtualNetworkResourceGroupName": {
      "value": "<virtualNetworkResourceGroupName>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param pimRoleAssignments = [
  {
    definition: '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
    principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
    relativeScope: ''
    roleAssignmentType: 'Eligible'
    scheduleInfo: {
      duration: 'PT4H'
      durationType: 'AfterDuration'
      startTime: '<startTime>'
    }
  }
]
param resourceProviders = {}
param roleAssignmentEnabled = true
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
param virtualNetworkEnabled = true
param virtualNetworkLocation = '<virtualNetworkLocation>'
param virtualNetworkName = '<virtualNetworkName>'
param virtualNetworkResourceGroupName = '<virtualNetworkResourceGroupName>'
```

</details>
<p>

### Example 7: _Using RBAC conditions._

This instance deploys the module with RBAC conditions for the role assignments.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    resourceProviders: {}
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        definition: '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
        principalId: '<principalId>'
        relativeScope: ''
        roleAssignmentCondition: {
          roleConditionType: {
            principleTypesToAssign: [
              'Group'
              'ServicePrincipal'
            ]
            rolesToAssign: [
              'b24988ac-6180-42a0-ab88-20f7382dd24c'
            ]
            templateName: 'constrainRolesAndPrincipalTypes'
          }
        }
      }
    ]
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "resourceProviders": {
      "value": {}
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "definition": "/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168",
          "principalId": "<principalId>",
          "relativeScope": "",
          "roleAssignmentCondition": {
            "roleConditionType": {
              "principleTypesToAssign": [
                "Group",
                "ServicePrincipal"
              ],
              "rolesToAssign": [
                "b24988ac-6180-42a0-ab88-20f7382dd24c"
              ],
              "templateName": "constrainRolesAndPrincipalTypes"
            }
          }
        }
      ]
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
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
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param resourceProviders = {}
param roleAssignmentEnabled = true
param roleAssignments = [
  {
    definition: '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
    principalId: '<principalId>'
    relativeScope: ''
    roleAssignmentCondition: {
      roleConditionType: {
        principleTypesToAssign: [
          'Group'
          'ServicePrincipal'
        ]
        rolesToAssign: [
          'b24988ac-6180-42a0-ab88-20f7382dd24c'
        ]
        templateName: 'constrainRolesAndPrincipalTypes'
      }
    }
  }
]
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
```

</details>
<p>

### Example 8: _Vwan topology._

This instance deploys a subscription with a vwan network topology.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    deploymentScriptLocation: '<deploymentScriptLocation>'
    deploymentScriptManagedIdentityName: '<deploymentScriptManagedIdentityName>'
    deploymentScriptName: 'ds-ssawan'
    deploymentScriptNetworkSecurityGroupName: '<deploymentScriptNetworkSecurityGroupName>'
    deploymentScriptResourceGroupName: '<deploymentScriptResourceGroupName>'
    deploymentScriptStorageAccountName: '<deploymentScriptStorageAccountName>'
    deploymentScriptVirtualNetworkName: '<deploymentScriptVirtualNetworkName>'
    hubNetworkResourceId: '<hubNetworkResourceId>'
    resourceProviders: {}
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        definition: '/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
        principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
        relativeScope: '<relativeScope>'
      }
    ]
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
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

<summary>via JSON parameters file</summary>

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
      "value": "ds-ssawan"
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
          "definition": "/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7",
          "principalId": "896b1162-be44-4b28-888a-d01acc1b4271",
          "relativeScope": "<relativeScope>"
        }
      ]
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param deploymentScriptLocation = '<deploymentScriptLocation>'
param deploymentScriptManagedIdentityName = '<deploymentScriptManagedIdentityName>'
param deploymentScriptName = 'ds-ssawan'
param deploymentScriptNetworkSecurityGroupName = '<deploymentScriptNetworkSecurityGroupName>'
param deploymentScriptResourceGroupName = '<deploymentScriptResourceGroupName>'
param deploymentScriptStorageAccountName = '<deploymentScriptStorageAccountName>'
param deploymentScriptVirtualNetworkName = '<deploymentScriptVirtualNetworkName>'
param hubNetworkResourceId = '<hubNetworkResourceId>'
param resourceProviders = {}
param roleAssignmentEnabled = true
param roleAssignments = [
  {
    definition: '/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
    principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
    relativeScope: '<relativeScope>'
  }
]
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
param virtualNetworkAddressSpace = [
  '10.210.0.0/16'
]
param virtualNetworkEnabled = true
param virtualNetworkLocation = '<virtualNetworkLocation>'
param virtualNetworkName = '<virtualNetworkName>'
param virtualNetworkPeeringEnabled = true
param virtualNetworkResourceGroupLockEnabled = false
param virtualNetworkResourceGroupName = '<virtualNetworkResourceGroupName>'
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
| [`existingSubscriptionId`](#parameter-existingsubscriptionid) | string | An existing subscription ID. Use this when you do not want the module to create a new subscription. But do want to manage the management group membership. A subscription ID should be provided in the example format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`. |
| [`hubNetworkResourceId`](#parameter-hubnetworkresourceid) | string | The resource ID of the Virtual Network or Virtual WAN Hub in the hub to which the created Virtual Network, by this module, will be peered/connected to via Virtual Network Peering or a Virtual WAN Virtual Hub Connection.<p> |
| [`managementGroupAssociationDelayCount`](#parameter-managementgroupassociationdelaycount) | int | The number of blank ARM deployments to create sequentially to introduce a delay to the Subscription being moved to the target Management Group being, if set, to allow for background platform RBAC inheritance to occur. |
| [`pimRoleAssignments`](#parameter-pimroleassignments) | array | Supply an array of objects containing the details of the PIM role assignments to create.<p><p>Each object must contain the following `keys`:<li>`principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too.<li>`definition` = The Resource ID of a Built-in or custom RBAC Role Definition as follows:<p>  - You can provide the Resource ID of a Built-in or custom RBAC Role Definition<p>    - e.g. `/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`<li>`relativeScope` = 2 options can be provided for input value:<p>    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope<p>    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group.<p> |
| [`resourceProviders`](#parameter-resourceproviders) | object | An object of resource providers and resource providers features to register. If left blank/empty, no resource providers will be registered.<p> |
| [`roleAssignmentEnabled`](#parameter-roleassignmentenabled) | bool | Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.<p> |
| [`roleAssignments`](#parameter-roleassignments) | array | Supply an array of objects containing the details of the role assignments to create.<p><p>Each object must contain the following `keys`:<li>`principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too.<li>`definition` = The Name of one of the pre-defined built-In RBAC Roles or a Resource ID of a Built-in or custom RBAC Role Definition as follows:<p>  - You can only provide the RBAC role name of the pre-defined roles (Contributor, Owner, Reader, Role Based Access Control Administrator (Preview), and User Access Administrator). We only provide those roles as they are the most common ones to assign to a new subscription, also to reduce the template size and complexity in case we define each and every Built-in RBAC role.<p>  - You can provide the Resource ID of a Built-in or custom RBAC Role Definition<p>    - e.g. `/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`<li>`relativeScope` = 2 options can be provided for input value:<p>    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope<p>    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group.<p> |
| [`subscriptionAliasEnabled`](#parameter-subscriptionaliasenabled) | bool | Whether to create a new Subscription using the Subscription Alias resource. If `false`, supply an existing Subscription''s ID in the parameter named `existingSubscriptionId` instead to deploy resources to an existing Subscription. |
| [`subscriptionAliasName`](#parameter-subscriptionaliasname) | string | The name of the Subscription Alias, that will be created by this module.<p><p>The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p> |
| [`subscriptionBillingScope`](#parameter-subscriptionbillingscope) | string | The Billing Scope for the new Subscription alias, that will be created by this module.<p><p>A valid Billing Scope looks like `/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts/{enrollmentAccountName}` and is case sensitive.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p> |
| [`subscriptionDisplayName`](#parameter-subscriptiondisplayname) | string | The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, - and _. The maximum length is 63 characters.<p><p>The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.<p><p>> The value for this parameter and the parameter named `subscriptionAliasName` are usually set to the same value for simplicity. But they can be different if required for a reason.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p> |
| [`subscriptionManagementGroupAssociationEnabled`](#parameter-subscriptionmanagementgroupassociationenabled) | bool | Whether to move the Subscription to the specified Management Group supplied in the parameter `subscriptionManagementGroupId`.<p> |
| [`subscriptionManagementGroupId`](#parameter-subscriptionmanagementgroupid) | string | The destination Management Group ID for the new Subscription that will be created by this module (or the existing one provided in the parameter `existingSubscriptionId`).<p><p>**IMPORTANT:** Do not supply the display name of the Management Group. The Management Group ID forms part of the Azure Resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.<p> |
| [`subscriptionOwnerId`](#parameter-subscriptionownerid) | string | The Azure Active Directory principals object ID (GUID) to whom should be the Subscription Owner.<p><p>> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants)**. |
| [`subscriptionTags`](#parameter-subscriptiontags) | object | An object of Tag key & value pairs to be appended to a Subscription.<p><p>> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.<p> |
| [`subscriptionTenantId`](#parameter-subscriptiontenantid) | string | The Azure Active Directory Tenant ID (GUID) to which the Subscription should be attached to.<p><p>> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants)**. |
| [`subscriptionWorkload`](#parameter-subscriptionworkload) | string | The workload type can be either `Production` or `DevTest` and is case sensitive.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p> |
| [`vHubRoutingIntentEnabled`](#parameter-vhubroutingintentenabled) | bool | Indicates whether routing intent is enabled on the Virtual Hub within the Virtual WAN.<p> |
| [`virtualNetworkAddressSpace`](#parameter-virtualnetworkaddressspace) | array | The address space of the Virtual Network that will be created by this module, supplied as multiple CIDR blocks in an array, e.g. `["10.0.0.0/16","172.16.0.0/12"]`. |
| [`virtualNetworkBastionConfiguration`](#parameter-virtualnetworkbastionconfiguration) | object | The configuration object for the Bastion host. Do not provide this object or keep it empty if you do not want to deploy a Bastion host. |
| [`virtualNetworkDdosPlanResourceId`](#parameter-virtualnetworkddosplanresourceid) | string | The resource ID of an existing DDoS Network Protection Plan that you wish to link to this Virtual Network.<p> |
| [`virtualNetworkDeployBastion`](#parameter-virtualnetworkdeploybastion) | bool | Whether to deploy a Bastion host to the created virtual network. |
| [`virtualNetworkDeploymentScriptAddressPrefix`](#parameter-virtualnetworkdeploymentscriptaddressprefix) | string | The address prefix of the private virtual network for the deployment script. |
| [`virtualNetworkDeployNatGateway`](#parameter-virtualnetworkdeploynatgateway) | bool | Whether to deploy a NAT gateway to the created virtual network. |
| [`virtualNetworkDnsServers`](#parameter-virtualnetworkdnsservers) | array | The custom DNS servers to use on the Virtual Network, e.g. `["10.4.1.4", "10.2.1.5"]`. If left empty (default) then Azure DNS will be used for the Virtual Network.<p> |
| [`virtualNetworkEnabled`](#parameter-virtualnetworkenabled) | bool | Whether to create a Virtual Network or not.<p><p>If set to `true` ensure you also provide values for the following parameters at a minimum:<p><li>`virtualNetworkResourceGroupName`<li>`virtualNetworkResourceGroupLockEnabled`<li>`virtualNetworkLocation`<li>`virtualNetworkName`<li>`virtualNetworkAddressSpace`<p><p>> Other parameters may need to be set based on other parameters that you enable that are listed above. Check each parameters documentation for further information.<p> |
| [`virtualNetworkLocation`](#parameter-virtualnetworklocation) | string | The location of the virtual network. Use region shortnames e.g. `uksouth`, `eastus`, etc. Defaults to the region where the ARM/Bicep deployment is targeted to unless overridden.<p> |
| [`virtualNetworkName`](#parameter-virtualnetworkname) | string | The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.<p> |
| [`virtualNetworkNatGatewayConfiguration`](#parameter-virtualnetworknatgatewayconfiguration) | object | The NAT Gateway configuration object. Do not provide this object or keep it empty if you do not want to deploy a NAT Gateway. |
| [`virtualNetworkPeeringEnabled`](#parameter-virtualnetworkpeeringenabled) | bool | Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.<p> |
| [`virtualNetworkResourceGroupLockEnabled`](#parameter-virtualnetworkresourcegrouplockenabled) | bool | Enables the deployment of a `CanNotDelete` resource locks to the Virtual Networks Resource Group that is created by this module.<p> |
| [`virtualNetworkResourceGroupName`](#parameter-virtualnetworkresourcegroupname) | string | The name of the Resource Group to create the Virtual Network in that is created by this module.<p> |
| [`virtualNetworkResourceGroupTags`](#parameter-virtualnetworkresourcegrouptags) | object | An object of Tag key & value pairs to be appended to the Resource Group that the Virtual Network is created in.<p><p>> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.<p> |
| [`virtualNetworkSubnets`](#parameter-virtualnetworksubnets) | array | The subnets of the Virtual Network that will be created by this module. |
| [`virtualNetworkTags`](#parameter-virtualnetworktags) | object | An object of tag key/value pairs to be set on the Virtual Network that is created.<p><p>> **NOTE:** Tags will be overwritten on resource if any exist already.<p> |
| [`virtualNetworkUseRemoteGateways`](#parameter-virtualnetworkuseremotegateways) | bool | Enables the use of remote gateways in the specified hub virtual network.<p><p>> **IMPORTANT:** If no gateways exist in the hub virtual network, set this to `false`, otherwise peering will fail to create.<p> |
| [`virtualNetworkVwanAssociatedRouteTableResourceId`](#parameter-virtualnetworkvwanassociatedroutetableresourceid) | string | The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty the `defaultRouteTable` will be associated.<p> |
| [`virtualNetworkVwanEnableInternetSecurity`](#parameter-virtualnetworkvwanenableinternetsecurity) | bool | Enables the ability for the Virtual WAN Hub Connection to learn the default route 0.0.0.0/0 from the Hub.<p> |
| [`virtualNetworkVwanPropagatedLabels`](#parameter-virtualnetworkvwanpropagatedlabels) | array | An array of virtual hub route table labels to propagate routes to. If left blank/empty the default label will be propagated to only.<p> |
| [`virtualNetworkVwanPropagatedRouteTablesResourceIds`](#parameter-virtualnetworkvwanpropagatedroutetablesresourceids) | array | An array of of objects of virtual hub route table resource IDs to propagate routes to. If left blank/empty the `defaultRouteTable` will be propagated to only.<p><p>Each object must contain the following `key`:<li>`id` = The Resource ID of the Virtual WAN Virtual Hub Route Table IDs you wish to propagate too<p><p>> **IMPORTANT:** If you provide any Route Tables in this array of objects you must ensure you include also the `defaultRouteTable` Resource ID as an object in the array as it is not added by default when a value is provided for this parameter.<p> |

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
- Default: `[format('nsg-ds-{0}', deployment().location)]`

### Parameter: `deploymentScriptResourceGroupName`

The name of the resource group to create the deployment script for resource providers registration.

- Required: No
- Type: string
- Default: `[format('rsg-{0}-ds', deployment().location)]`

### Parameter: `deploymentScriptStorageAccountName`

The name of the storage account for the deployment script.

- Required: No
- Type: string
- Default: `[format('stgds{0}', substring(uniqueString(deployment().name, parameters('existingSubscriptionId'), parameters('subscriptionAliasName'), parameters('subscriptionDisplayName'), parameters('virtualNetworkLocation')), 0, 10))]`

### Parameter: `deploymentScriptVirtualNetworkName`

The name of the private virtual network for the deployment script. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.

- Required: No
- Type: string
- Default: `[format('vnet-ds-{0}', deployment().location)]`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `existingSubscriptionId`

An existing subscription ID. Use this when you do not want the module to create a new subscription. But do want to manage the management group membership. A subscription ID should be provided in the example format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.

- Required: No
- Type: string
- Default: `''`

### Parameter: `hubNetworkResourceId`

The resource ID of the Virtual Network or Virtual WAN Hub in the hub to which the created Virtual Network, by this module, will be peered/connected to via Virtual Network Peering or a Virtual WAN Virtual Hub Connection.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `managementGroupAssociationDelayCount`

The number of blank ARM deployments to create sequentially to introduce a delay to the Subscription being moved to the target Management Group being, if set, to allow for background platform RBAC inheritance to occur.

- Required: No
- Type: int
- Default: `15`

### Parameter: `pimRoleAssignments`

Supply an array of objects containing the details of the PIM role assignments to create.<p><p>Each object must contain the following `keys`:<li>`principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too.<li>`definition` = The Resource ID of a Built-in or custom RBAC Role Definition as follows:<p>  - You can provide the Resource ID of a Built-in or custom RBAC Role Definition<p>    - e.g. `/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`<li>`relativeScope` = 2 options can be provided for input value:<p>    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope<p>    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group.<p>

- Required: No
- Type: array
- Default: `[]`
- Example:
  ```Bicep
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
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`definition`](#parameter-pimroleassignmentsdefinition) | string | The role definition ID or name. |
| [`principalId`](#parameter-pimroleassignmentsprincipalid) | string | The principal ID of the user, group, or service principal. |
| [`relativeScope`](#parameter-pimroleassignmentsrelativescope) | string | The relative scope of the role assignment. |
| [`roleAssignmentType`](#parameter-pimroleassignmentsroleassignmenttype) | string | The type of the role assignment. |
| [`scheduleInfo`](#parameter-pimroleassignmentsscheduleinfo) | object | The schedule information for the role assignment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ticketInfo`](#parameter-pimroleassignmentsticketinfo) | object | The ticket information for the role assignment. |

### Parameter: `pimRoleAssignments.definition`

The role definition ID or name.

- Required: Yes
- Type: string

### Parameter: `pimRoleAssignments.principalId`

The principal ID of the user, group, or service principal.

- Required: Yes
- Type: string

### Parameter: `pimRoleAssignments.relativeScope`

The relative scope of the role assignment.

- Required: Yes
- Type: string

### Parameter: `pimRoleAssignments.roleAssignmentType`

The type of the role assignment.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Active'
    'Eligible'
  ]
  ```

### Parameter: `pimRoleAssignments.scheduleInfo`

The schedule information for the role assignment.

- Required: Yes
- Type: object

### Parameter: `pimRoleAssignments.ticketInfo`

The ticket information for the role assignment.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ticketNumber`](#parameter-pimroleassignmentsticketinfoticketnumber) | string | The ticket number for the role eligibility assignment. |
| [`ticketSystem`](#parameter-pimroleassignmentsticketinfoticketsystem) | string | The ticket system name for the role eligibility assignment. |

### Parameter: `pimRoleAssignments.ticketInfo.ticketNumber`

The ticket number for the role eligibility assignment.

- Required: No
- Type: string

### Parameter: `pimRoleAssignments.ticketInfo.ticketSystem`

The ticket system name for the role eligibility assignment.

- Required: No
- Type: string

### Parameter: `resourceProviders`

An object of resource providers and resource providers features to register. If left blank/empty, no resource providers will be registered.<p>

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
      'Microsoft.Web': []
  }
  ```

### Parameter: `roleAssignmentEnabled`

Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.<p>

- Required: No
- Type: bool
- Default: `False`

### Parameter: `roleAssignments`

Supply an array of objects containing the details of the role assignments to create.<p><p>Each object must contain the following `keys`:<li>`principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too.<li>`definition` = The Name of one of the pre-defined built-In RBAC Roles or a Resource ID of a Built-in or custom RBAC Role Definition as follows:<p>  - You can only provide the RBAC role name of the pre-defined roles (Contributor, Owner, Reader, Role Based Access Control Administrator (Preview), and User Access Administrator). We only provide those roles as they are the most common ones to assign to a new subscription, also to reduce the template size and complexity in case we define each and every Built-in RBAC role.<p>  - You can provide the Resource ID of a Built-in or custom RBAC Role Definition<p>    - e.g. `/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`<li>`relativeScope` = 2 options can be provided for input value:<p>    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope<p>    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group.<p>

- Required: No
- Type: array
- Default: `[]`
- Example:
  ```Bicep
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
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`definition`](#parameter-roleassignmentsdefinition) | string | The role definition ID or name. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the user, group, or service principal. |
| [`relativeScope`](#parameter-roleassignmentsrelativescope) | string | The relative scope of the role assignment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the user, group, or service principal. |
| [`roleAssignmentCondition`](#parameter-roleassignmentsroleassignmentcondition) | object | The condition for the role assignment. |

### Parameter: `roleAssignments.definition`

The role definition ID or name.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalId`

The principal ID of the user, group, or service principal.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.relativeScope`

The relative scope of the role assignment.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the user, group, or service principal.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `roleAssignments.roleAssignmentCondition`

The condition for the role assignment.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`conditionVersion`](#parameter-roleassignmentsroleassignmentconditionconditionversion) | string | The version of the condition template. |
| [`delegationCode`](#parameter-roleassignmentsroleassignmentconditiondelegationcode) | string | The code for a custom condition if no template is used. The user should supply their own custom code if the available templates are not matching their requirements. If a value is provided, this will overwrite any added template. All single quotes needs to be skipped using '. |
| [`roleConditionType`](#parameter-roleassignmentsroleassignmentconditionroleconditiontype) | object | The type of template for the role assignment condition. |

### Parameter: `roleAssignments.roleAssignmentCondition.conditionVersion`

The version of the condition template.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.roleAssignmentCondition.delegationCode`

The code for a custom condition if no template is used. The user should supply their own custom code if the available templates are not matching their requirements. If a value is provided, this will overwrite any added template. All single quotes needs to be skipped using '.

- Required: No
- Type: string

### Parameter: `roleAssignments.roleAssignmentCondition.roleConditionType`

The type of template for the role assignment condition.

- Required: No
- Type: object

### Parameter: `subscriptionAliasEnabled`

Whether to create a new Subscription using the Subscription Alias resource. If `false`, supply an existing Subscription''s ID in the parameter named `existingSubscriptionId` instead to deploy resources to an existing Subscription.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `subscriptionAliasName`

The name of the Subscription Alias, that will be created by this module.<p><p>The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionBillingScope`

The Billing Scope for the new Subscription alias, that will be created by this module.<p><p>A valid Billing Scope looks like `/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts/{enrollmentAccountName}` and is case sensitive.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionDisplayName`

The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, - and _. The maximum length is 63 characters.<p><p>The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.<p><p>> The value for this parameter and the parameter named `subscriptionAliasName` are usually set to the same value for simplicity. But they can be different if required for a reason.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionManagementGroupAssociationEnabled`

Whether to move the Subscription to the specified Management Group supplied in the parameter `subscriptionManagementGroupId`.<p>

- Required: No
- Type: bool
- Default: `True`

### Parameter: `subscriptionManagementGroupId`

The destination Management Group ID for the new Subscription that will be created by this module (or the existing one provided in the parameter `existingSubscriptionId`).<p><p>**IMPORTANT:** Do not supply the display name of the Management Group. The Management Group ID forms part of the Azure Resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionOwnerId`

The Azure Active Directory principals object ID (GUID) to whom should be the Subscription Owner.<p><p>> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants)**.

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionTags`

An object of Tag key & value pairs to be appended to a Subscription.<p><p>> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.<p>

- Required: No
- Type: object
- Default: `{}`

### Parameter: `subscriptionTenantId`

The Azure Active Directory Tenant ID (GUID) to which the Subscription should be attached to.<p><p>> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants)**.

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionWorkload`

The workload type can be either `Production` or `DevTest` and is case sensitive.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p>

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

Indicates whether routing intent is enabled on the Virtual Hub within the Virtual WAN.<p>

- Required: No
- Type: bool
- Default: `False`

### Parameter: `virtualNetworkAddressSpace`

The address space of the Virtual Network that will be created by this module, supplied as multiple CIDR blocks in an array, e.g. `["10.0.0.0/16","172.16.0.0/12"]`.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `virtualNetworkBastionConfiguration`

The configuration object for the Bastion host. Do not provide this object or keep it empty if you do not want to deploy a Bastion host.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bastionSku`](#parameter-virtualnetworkbastionconfigurationbastionsku) | string | The SKU of the bastion host. |
| [`disableCopyPaste`](#parameter-virtualnetworkbastionconfigurationdisablecopypaste) | bool | The option to allow copy and paste. |
| [`enableFileCopy`](#parameter-virtualnetworkbastionconfigurationenablefilecopy) | bool | The option to allow file copy. |
| [`enableIpConnect`](#parameter-virtualnetworkbastionconfigurationenableipconnect) | bool | The option to allow IP connect. |
| [`enableShareableLink`](#parameter-virtualnetworkbastionconfigurationenableshareablelink) | bool | The option to allow shareable link. |
| [`name`](#parameter-virtualnetworkbastionconfigurationname) | string | The name of the bastion host. |
| [`scaleUnits`](#parameter-virtualnetworkbastionconfigurationscaleunits) | int | The number of scale units. The Basic SKU only supports 2 scale units. |

### Parameter: `virtualNetworkBastionConfiguration.bastionSku`

The SKU of the bastion host.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `virtualNetworkBastionConfiguration.disableCopyPaste`

The option to allow copy and paste.

- Required: No
- Type: bool

### Parameter: `virtualNetworkBastionConfiguration.enableFileCopy`

The option to allow file copy.

- Required: No
- Type: bool

### Parameter: `virtualNetworkBastionConfiguration.enableIpConnect`

The option to allow IP connect.

- Required: No
- Type: bool

### Parameter: `virtualNetworkBastionConfiguration.enableShareableLink`

The option to allow shareable link.

- Required: No
- Type: bool

### Parameter: `virtualNetworkBastionConfiguration.name`

The name of the bastion host.

- Required: No
- Type: string

### Parameter: `virtualNetworkBastionConfiguration.scaleUnits`

The number of scale units. The Basic SKU only supports 2 scale units.

- Required: No
- Type: int

### Parameter: `virtualNetworkDdosPlanResourceId`

The resource ID of an existing DDoS Network Protection Plan that you wish to link to this Virtual Network.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `virtualNetworkDeployBastion`

Whether to deploy a Bastion host to the created virtual network.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `virtualNetworkDeploymentScriptAddressPrefix`

The address prefix of the private virtual network for the deployment script.

- Required: No
- Type: string
- Default: `'192.168.0.0/24'`

### Parameter: `virtualNetworkDeployNatGateway`

Whether to deploy a NAT gateway to the created virtual network.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `virtualNetworkDnsServers`

The custom DNS servers to use on the Virtual Network, e.g. `["10.4.1.4", "10.2.1.5"]`. If left empty (default) then Azure DNS will be used for the Virtual Network.<p>

- Required: No
- Type: array
- Default: `[]`

### Parameter: `virtualNetworkEnabled`

Whether to create a Virtual Network or not.<p><p>If set to `true` ensure you also provide values for the following parameters at a minimum:<p><li>`virtualNetworkResourceGroupName`<li>`virtualNetworkResourceGroupLockEnabled`<li>`virtualNetworkLocation`<li>`virtualNetworkName`<li>`virtualNetworkAddressSpace`<p><p>> Other parameters may need to be set based on other parameters that you enable that are listed above. Check each parameters documentation for further information.<p>

- Required: No
- Type: bool
- Default: `False`

### Parameter: `virtualNetworkLocation`

The location of the virtual network. Use region shortnames e.g. `uksouth`, `eastus`, etc. Defaults to the region where the ARM/Bicep deployment is targeted to unless overridden.<p>

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `virtualNetworkName`

The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.<p>

- Required: No
- Type: string

### Parameter: `virtualNetworkNatGatewayConfiguration`

The NAT Gateway configuration object. Do not provide this object or keep it empty if you do not want to deploy a NAT Gateway.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-virtualnetworknatgatewayconfigurationname) | string | The name of the NAT gateway. |
| [`publicIPAddressPrefixesProperties`](#parameter-virtualnetworknatgatewayconfigurationpublicipaddressprefixesproperties) | array | The Public IP address(es) prefixes properties to be attached to the NAT gateway. |
| [`publicIPAddressProperties`](#parameter-virtualnetworknatgatewayconfigurationpublicipaddressproperties) | array | The Public IP address(es) properties to be attached to the NAT gateway. |
| [`zones`](#parameter-virtualnetworknatgatewayconfigurationzones) | int | The availability zones of the NAT gateway. Check the availability zone guidance for NAT gateway to understand how to map NAT gateway zone to the associated Public IP address zones (https://learn.microsoft.com/azure/nat-gateway/nat-availability-zones). |

### Parameter: `virtualNetworkNatGatewayConfiguration.name`

The name of the NAT gateway.

- Required: No
- Type: string

### Parameter: `virtualNetworkNatGatewayConfiguration.publicIPAddressPrefixesProperties`

The Public IP address(es) prefixes properties to be attached to the NAT gateway.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customIPPrefix`](#parameter-virtualnetworknatgatewayconfigurationpublicipaddressprefixespropertiescustomipprefix) | string | The custom IP prefix of the public IP address prefix. |
| [`name`](#parameter-virtualnetworknatgatewayconfigurationpublicipaddressprefixespropertiesname) | string | The name of the Public IP address prefix. |
| [`prefixLength`](#parameter-virtualnetworknatgatewayconfigurationpublicipaddressprefixespropertiesprefixlength) | int | The prefix length of the public IP address prefix.. |

### Parameter: `virtualNetworkNatGatewayConfiguration.publicIPAddressPrefixesProperties.customIPPrefix`

The custom IP prefix of the public IP address prefix.

- Required: No
- Type: string

### Parameter: `virtualNetworkNatGatewayConfiguration.publicIPAddressPrefixesProperties.name`

The name of the Public IP address prefix.

- Required: No
- Type: string

### Parameter: `virtualNetworkNatGatewayConfiguration.publicIPAddressPrefixesProperties.prefixLength`

The prefix length of the public IP address prefix..

- Required: No
- Type: int

### Parameter: `virtualNetworkNatGatewayConfiguration.publicIPAddressProperties`

The Public IP address(es) properties to be attached to the NAT gateway.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-virtualnetworknatgatewayconfigurationpublicipaddresspropertiesname) | string | The name of the Public IP address. |
| [`zones`](#parameter-virtualnetworknatgatewayconfigurationpublicipaddresspropertieszones) | array | The SKU of the Public IP address. |

### Parameter: `virtualNetworkNatGatewayConfiguration.publicIPAddressProperties.name`

The name of the Public IP address.

- Required: No
- Type: string

### Parameter: `virtualNetworkNatGatewayConfiguration.publicIPAddressProperties.zones`

The SKU of the Public IP address.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `virtualNetworkNatGatewayConfiguration.zones`

The availability zones of the NAT gateway. Check the availability zone guidance for NAT gateway to understand how to map NAT gateway zone to the associated Public IP address zones (https://learn.microsoft.com/azure/nat-gateway/nat-availability-zones).

- Required: No
- Type: int

### Parameter: `virtualNetworkPeeringEnabled`

Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.<p>

- Required: No
- Type: bool
- Default: `False`

### Parameter: `virtualNetworkResourceGroupLockEnabled`

Enables the deployment of a `CanNotDelete` resource locks to the Virtual Networks Resource Group that is created by this module.<p>

- Required: No
- Type: bool
- Default: `True`

### Parameter: `virtualNetworkResourceGroupName`

The name of the Resource Group to create the Virtual Network in that is created by this module.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `virtualNetworkResourceGroupTags`

An object of Tag key & value pairs to be appended to the Resource Group that the Virtual Network is created in.<p><p>> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.<p>

- Required: No
- Type: object
- Default: `{}`

### Parameter: `virtualNetworkSubnets`

The subnets of the Virtual Network that will be created by this module.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-virtualnetworksubnetsname) | string | The Name of the subnet resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-virtualnetworksubnetsaddressprefix) | string | The address prefix for the subnet. Required if `addressPrefixes` is empty. |
| [`addressPrefixes`](#parameter-virtualnetworksubnetsaddressprefixes) | array | List of address prefixes for the subnet. Required if `addressPrefix` is empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationGatewayIPConfigurations`](#parameter-virtualnetworksubnetsapplicationgatewayipconfigurations) | array | Application gateway IP configurations of virtual network resource. |
| [`associateWithNatGateway`](#parameter-virtualnetworksubnetsassociatewithnatgateway) | bool | Option to associate the subnet with the NAT gatway deployed by this module. |
| [`defaultOutboundAccess`](#parameter-virtualnetworksubnetsdefaultoutboundaccess) | bool | Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet. |
| [`delegation`](#parameter-virtualnetworksubnetsdelegation) | string | The delegation to enable on the subnet. |
| [`natGatewayResourceId`](#parameter-virtualnetworksubnetsnatgatewayresourceid) | string | The resource ID of the NAT Gateway to use for the subnet. |
| [`networkSecurityGroupResourceId`](#parameter-virtualnetworksubnetsnetworksecuritygroupresourceid) | string | The resource ID of the network security group to assign to the subnet. |
| [`privateEndpointNetworkPolicies`](#parameter-virtualnetworksubnetsprivateendpointnetworkpolicies) | string | enable or disable apply network policies on private endpoint in the subnet. |
| [`privateLinkServiceNetworkPolicies`](#parameter-virtualnetworksubnetsprivatelinkservicenetworkpolicies) | string | enable or disable apply network policies on private link service in the subnet. |
| [`routeTableResourceId`](#parameter-virtualnetworksubnetsroutetableresourceid) | string | The resource ID of the route table to assign to the subnet. |
| [`serviceEndpointPolicies`](#parameter-virtualnetworksubnetsserviceendpointpolicies) | array | An array of service endpoint policies. |
| [`serviceEndpoints`](#parameter-virtualnetworksubnetsserviceendpoints) | array | The service endpoints to enable on the subnet. |
| [`sharingScope`](#parameter-virtualnetworksubnetssharingscope) | string | Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. This property can only be set if defaultOutboundAccess is set to false, both properties can only be set if subnet is empty. |

### Parameter: `virtualNetworkSubnets.name`

The Name of the subnet resource.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkSubnets.addressPrefix`

The address prefix for the subnet. Required if `addressPrefixes` is empty.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.addressPrefixes`

List of address prefixes for the subnet. Required if `addressPrefix` is empty.

- Required: No
- Type: array

### Parameter: `virtualNetworkSubnets.applicationGatewayIPConfigurations`

Application gateway IP configurations of virtual network resource.

- Required: No
- Type: array

### Parameter: `virtualNetworkSubnets.associateWithNatGateway`

Option to associate the subnet with the NAT gatway deployed by this module.

- Required: No
- Type: bool

### Parameter: `virtualNetworkSubnets.defaultOutboundAccess`

Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet.

- Required: No
- Type: bool

### Parameter: `virtualNetworkSubnets.delegation`

The delegation to enable on the subnet.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.natGatewayResourceId`

The resource ID of the NAT Gateway to use for the subnet.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.networkSecurityGroupResourceId`

The resource ID of the network security group to assign to the subnet.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.privateEndpointNetworkPolicies`

enable or disable apply network policies on private endpoint in the subnet.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
    'NetworkSecurityGroupEnabled'
    'RouteTableEnabled'
  ]
  ```

### Parameter: `virtualNetworkSubnets.privateLinkServiceNetworkPolicies`

enable or disable apply network policies on private link service in the subnet.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `virtualNetworkSubnets.routeTableResourceId`

The resource ID of the route table to assign to the subnet.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.serviceEndpointPolicies`

An array of service endpoint policies.

- Required: No
- Type: array

### Parameter: `virtualNetworkSubnets.serviceEndpoints`

The service endpoints to enable on the subnet.

- Required: No
- Type: array

### Parameter: `virtualNetworkSubnets.sharingScope`

Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. This property can only be set if defaultOutboundAccess is set to false, both properties can only be set if subnet is empty.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'DelegatedServices'
    'Tenant'
  ]
  ```

### Parameter: `virtualNetworkTags`

An object of tag key/value pairs to be set on the Virtual Network that is created.<p><p>> **NOTE:** Tags will be overwritten on resource if any exist already.<p>

- Required: No
- Type: object
- Default: `{}`

### Parameter: `virtualNetworkUseRemoteGateways`

Enables the use of remote gateways in the specified hub virtual network.<p><p>> **IMPORTANT:** If no gateways exist in the hub virtual network, set this to `false`, otherwise peering will fail to create.<p>

- Required: No
- Type: bool
- Default: `True`

### Parameter: `virtualNetworkVwanAssociatedRouteTableResourceId`

The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty the `defaultRouteTable` will be associated.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `virtualNetworkVwanEnableInternetSecurity`

Enables the ability for the Virtual WAN Hub Connection to learn the default route 0.0.0.0/0 from the Hub.<p>

- Required: No
- Type: bool
- Default: `True`

### Parameter: `virtualNetworkVwanPropagatedLabels`

An array of virtual hub route table labels to propagate routes to. If left blank/empty the default label will be propagated to only.<p>

- Required: No
- Type: array
- Default: `[]`

### Parameter: `virtualNetworkVwanPropagatedRouteTablesResourceIds`

An array of of objects of virtual hub route table resource IDs to propagate routes to. If left blank/empty the `defaultRouteTable` will be propagated to only.<p><p>Each object must contain the following `key`:<li>`id` = The Resource ID of the Virtual WAN Virtual Hub Route Table IDs you wish to propagate too<p><p>> **IMPORTANT:** If you provide any Route Tables in this array of objects you must ensure you include also the `defaultRouteTable` Resource ID as an object in the array as it is not added by default when a value is provided for this parameter.<p>

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

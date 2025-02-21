# Kusto Cluster `[Microsoft.Kusto/clusters]`

This module deploys a Kusto Cluster.

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
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Kusto/clusters` | [2024-04-13](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2024-04-13/clusters) |
| `Microsoft.Kusto/clusters/databases` | [2024-04-13](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2024-04-13/clusters/databases) |
| `Microsoft.Kusto/clusters/principalAssignments` | [2023-08-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2023-08-15/clusters/principalAssignments) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/kusto/cluster:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [Private endpoint-enabled deployment](#example-3-private-endpoint-enabled-deployment)
- [Using Customer-Managed-Keys with System-Assigned identity](#example-4-using-customer-managed-keys-with-system-assigned-identity)
- [Using Customer-Managed-Keys with User-Assigned identity](#example-5-using-customer-managed-keys-with-user-assigned-identity)
- [WAF-aligned](#example-6-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/kusto/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    name: 'kcmin0001'
    sku: 'Standard_E2ads_v5'
    // Non-required parameters
    enableDiskEncryption: true
    location: '<location>'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
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
    // Required parameters
    "name": {
      "value": "kcmin0001"
    },
    "sku": {
      "value": "Standard_E2ads_v5"
    },
    // Non-required parameters
    "enableDiskEncryption": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/kusto/cluster:<version>'

// Required parameters
param name = 'kcmin0001'
param sku = 'Standard_E2ads_v5'
// Non-required parameters
param enableDiskEncryption = true
param location = '<location>'
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/kusto/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    name: 'kcmax0001'
    sku: 'Standard_E2ads_v5'
    // Non-required parameters
    acceptedAudiences: [
      {
        value: 'https://contoso.com'
      }
    ]
    allowedFqdnList: [
      'contoso.com'
    ]
    allowedIpRangeList: [
      '192.168.1.1'
    ]
    autoScaleMax: 6
    autoScaleMin: 3
    capacity: 3
    databases: [
      {
        kind: 'ReadWrite'
        name: 'myReadWriteDatabase'
        readWriteProperties: {
          hotCachePeriod: 'P1D'
          softDeletePeriod: 'P7D'
        }
      }
    ]
    enableAutoScale: true
    enableAutoStop: true
    enableDiskEncryption: true
    enableDoubleEncryption: true
    enablePublicNetworkAccess: true
    enablePurge: true
    enableRestrictOutboundNetworkAccess: true
    enableStreamingIngest: true
    enableZoneRedundant: true
    engineType: 'V3'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    principalAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'App'
        role: 'AllDatabasesViewer'
      }
    ]
    publicIPType: 'DualStack'
    roleAssignments: [
      {
        name: 'c2a4b728-c3d0-47f5-afbb-ea45c45859de'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
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
    // Required parameters
    "name": {
      "value": "kcmax0001"
    },
    "sku": {
      "value": "Standard_E2ads_v5"
    },
    // Non-required parameters
    "acceptedAudiences": {
      "value": [
        {
          "value": "https://contoso.com"
        }
      ]
    },
    "allowedFqdnList": {
      "value": [
        "contoso.com"
      ]
    },
    "allowedIpRangeList": {
      "value": [
        "192.168.1.1"
      ]
    },
    "autoScaleMax": {
      "value": 6
    },
    "autoScaleMin": {
      "value": 3
    },
    "capacity": {
      "value": 3
    },
    "databases": {
      "value": [
        {
          "kind": "ReadWrite",
          "name": "myReadWriteDatabase",
          "readWriteProperties": {
            "hotCachePeriod": "P1D",
            "softDeletePeriod": "P7D"
          }
        }
      ]
    },
    "enableAutoScale": {
      "value": true
    },
    "enableAutoStop": {
      "value": true
    },
    "enableDiskEncryption": {
      "value": true
    },
    "enableDoubleEncryption": {
      "value": true
    },
    "enablePublicNetworkAccess": {
      "value": true
    },
    "enablePurge": {
      "value": true
    },
    "enableRestrictOutboundNetworkAccess": {
      "value": true
    },
    "enableStreamingIngest": {
      "value": true
    },
    "enableZoneRedundant": {
      "value": true
    },
    "engineType": {
      "value": "V3"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "principalAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "App",
          "role": "AllDatabasesViewer"
        }
      ]
    },
    "publicIPType": {
      "value": "DualStack"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "c2a4b728-c3d0-47f5-afbb-ea45c45859de",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
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
using 'br/public:avm/res/kusto/cluster:<version>'

// Required parameters
param name = 'kcmax0001'
param sku = 'Standard_E2ads_v5'
// Non-required parameters
param acceptedAudiences = [
  {
    value: 'https://contoso.com'
  }
]
param allowedFqdnList = [
  'contoso.com'
]
param allowedIpRangeList = [
  '192.168.1.1'
]
param autoScaleMax = 6
param autoScaleMin = 3
param capacity = 3
param databases = [
  {
    kind: 'ReadWrite'
    name: 'myReadWriteDatabase'
    readWriteProperties: {
      hotCachePeriod: 'P1D'
      softDeletePeriod: 'P7D'
    }
  }
]
param enableAutoScale = true
param enableAutoStop = true
param enableDiskEncryption = true
param enableDoubleEncryption = true
param enablePublicNetworkAccess = true
param enablePurge = true
param enableRestrictOutboundNetworkAccess = true
param enableStreamingIngest = true
param enableZoneRedundant = true
param engineType = 'V3'
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param principalAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'App'
    role: 'AllDatabasesViewer'
  }
]
param publicIPType = 'DualStack'
param roleAssignments = [
  {
    name: 'c2a4b728-c3d0-47f5-afbb-ea45c45859de'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
  }
  {
    name: '<name>'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
]
```

</details>
<p>

### Example 3: _Private endpoint-enabled deployment_

This instance deploys the module with private endpoints.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/kusto/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    name: 'kcpe0001'
    sku: 'Standard_E2ads_v5'
    // Non-required parameters
    enablePublicNetworkAccess: false
    location: '<location>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'cluster'
        subnetResourceId: '<subnetResourceId>'
      }
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'cluster'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    publicIPType: 'IPv4'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
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
    // Required parameters
    "name": {
      "value": "kcpe0001"
    },
    "sku": {
      "value": "Standard_E2ads_v5"
    },
    // Non-required parameters
    "enablePublicNetworkAccess": {
      "value": false
    },
    "location": {
      "value": "<location>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "cluster",
          "subnetResourceId": "<subnetResourceId>"
        },
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "cluster",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "publicIPType": {
      "value": "IPv4"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/kusto/cluster:<version>'

// Required parameters
param name = 'kcpe0001'
param sku = 'Standard_E2ads_v5'
// Non-required parameters
param enablePublicNetworkAccess = false
param location = '<location>'
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'cluster'
    subnetResourceId: '<subnetResourceId>'
  }
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'cluster'
    subnetResourceId: '<subnetResourceId>'
  }
]
param publicIPType = 'IPv4'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 4: _Using Customer-Managed-Keys with System-Assigned identity_

This instance deploys the module using Customer-Managed-Keys using a System-Assigned Identity. This required the service to be deployed twice, once as a pre-requisite to create the System-Assigned Identity, and once to use it for accessing the Customer-Managed-Key secret.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/kusto/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    name: '<name>'
    sku: 'Standard_E2ads_v5'
    // Non-required parameters
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
    }
    managedIdentities: {
      systemAssigned: true
    }
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
    // Required parameters
    "name": {
      "value": "<name>"
    },
    "sku": {
      "value": "Standard_E2ads_v5"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/kusto/cluster:<version>'

// Required parameters
param name = '<name>'
param sku = 'Standard_E2ads_v5'
// Non-required parameters
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
}
param managedIdentities = {
  systemAssigned: true
}
```

</details>
<p>

### Example 5: _Using Customer-Managed-Keys with User-Assigned identity_

This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/kusto/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    name: 'kcuencr0001'
    sku: 'Standard_E2ads_v5'
    // Non-required parameters
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
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
    // Required parameters
    "name": {
      "value": "kcuencr0001"
    },
    "sku": {
      "value": "Standard_E2ads_v5"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/kusto/cluster:<version>'

// Required parameters
param name = 'kcuencr0001'
param sku = 'Standard_E2ads_v5'
// Non-required parameters
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
```

</details>
<p>

### Example 6: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/kusto/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    name: 'kcwaf0001'
    sku: 'Standard_E2ads_v5'
    // Non-required parameters
    autoScaleMax: 10
    autoScaleMin: 3
    capacity: 3
    enableAutoScale: true
    enableAutoStop: true
    enableDiskEncryption: true
    enableDoubleEncryption: true
    enablePublicNetworkAccess: false
    enableZoneRedundant: true
    location: '<location>'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    tier: 'Standard'
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
    // Required parameters
    "name": {
      "value": "kcwaf0001"
    },
    "sku": {
      "value": "Standard_E2ads_v5"
    },
    // Non-required parameters
    "autoScaleMax": {
      "value": 10
    },
    "autoScaleMin": {
      "value": 3
    },
    "capacity": {
      "value": 3
    },
    "enableAutoScale": {
      "value": true
    },
    "enableAutoStop": {
      "value": true
    },
    "enableDiskEncryption": {
      "value": true
    },
    "enableDoubleEncryption": {
      "value": true
    },
    "enablePublicNetworkAccess": {
      "value": false
    },
    "enableZoneRedundant": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "tier": {
      "value": "Standard"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/kusto/cluster:<version>'

// Required parameters
param name = 'kcwaf0001'
param sku = 'Standard_E2ads_v5'
// Non-required parameters
param autoScaleMax = 10
param autoScaleMin = 3
param capacity = 3
param enableAutoScale = true
param enableAutoStop = true
param enableDiskEncryption = true
param enableDoubleEncryption = true
param enablePublicNetworkAccess = false
param enableZoneRedundant = true
param location = '<location>'
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param tags = {
  Env: 'test'
  'hidden-title': 'This is visible in the resource name'
}
param tier = 'Standard'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Kusto cluster which must be unique within Azure. |
| [`sku`](#parameter-sku) | string | The SKU of the Kusto Cluster. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`acceptedAudiences`](#parameter-acceptedaudiences) | array | The Kusto Cluster's accepted audiences. |
| [`allowedFqdnList`](#parameter-allowedfqdnlist) | array | List of allowed fully-qulified domain names (FQDNs) for egress from the Kusto Cluster. |
| [`allowedIpRangeList`](#parameter-allowediprangelist) | array | List of IP addresses in CIDR format allowed to connect to the Kusto Cluster. |
| [`autoScaleMax`](#parameter-autoscalemax) | int | When auto-scale is enabled, the maximum number of instances in the Kusto Cluster. |
| [`autoScaleMin`](#parameter-autoscalemin) | int | When auto-scale is enabled, the minimum number of instances in the Kusto Cluster. |
| [`capacity`](#parameter-capacity) | int | The number of instances of the Kusto Cluster. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`databases`](#parameter-databases) | array | The Kusto Cluster databases. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableAutoScale`](#parameter-enableautoscale) | bool | Enable/disable auto-scale. |
| [`enableAutoStop`](#parameter-enableautostop) | bool | Enable/disable auto-stop. |
| [`enableDiskEncryption`](#parameter-enablediskencryption) | bool | Enable/disable disk encryption. |
| [`enableDoubleEncryption`](#parameter-enabledoubleencryption) | bool | Enable/disable double encryption. |
| [`enablePublicNetworkAccess`](#parameter-enablepublicnetworkaccess) | bool | Enable/disable public network access. If disabled, only private endpoint connection is allowed to the Kusto Cluster. |
| [`enablePurge`](#parameter-enablepurge) | bool | Enable/disable purge. |
| [`enableRestrictOutboundNetworkAccess`](#parameter-enablerestrictoutboundnetworkaccess) | bool | Enable/disable restricting outbound network access. |
| [`enableStreamingIngest`](#parameter-enablestreamingingest) | bool | Enable/disable streaming ingest. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/disable usage telemetry for module. |
| [`enableZoneRedundant`](#parameter-enablezoneredundant) | bool | Enable/disable zone redundancy. |
| [`engineType`](#parameter-enginetype) | string | The engine type of the Kusto Cluster. |
| [`languageExtensions`](#parameter-languageextensions) | array | List of the language extensions of the Kusto Cluster. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`principalAssignments`](#parameter-principalassignments) | array | The Principal Assignments for the Kusto Cluster. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicIPType`](#parameter-publiciptype) | string | Indicates what public IP type to create - IPv4 (default), or DualStack (both IPv4 and IPv6). |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`tier`](#parameter-tier) | string | The tier of the Kusto Cluster. |
| [`trustedExternalTenants`](#parameter-trustedexternaltenants) | array | The external tenants trusted by the Kusto Cluster. |
| [`virtualClusterGraduationProperties`](#parameter-virtualclustergraduationproperties) | securestring | The virtual cluster graduation properties of the Kusto Cluster. |
| [`virtualNetworkConfiguration`](#parameter-virtualnetworkconfiguration) | object | The virtual network configuration of the Kusto Cluster. |

### Parameter: `name`

The name of the Kusto cluster which must be unique within Azure.

- Required: Yes
- Type: string

### Parameter: `sku`

The SKU of the Kusto Cluster.

- Required: Yes
- Type: string

### Parameter: `acceptedAudiences`

The Kusto Cluster's accepted audiences.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`value`](#parameter-acceptedaudiencesvalue) | string | GUID or valid URL representing an accepted audience. |

### Parameter: `acceptedAudiences.value`

GUID or valid URL representing an accepted audience.

- Required: Yes
- Type: string

### Parameter: `allowedFqdnList`

List of allowed fully-qulified domain names (FQDNs) for egress from the Kusto Cluster.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `allowedIpRangeList`

List of IP addresses in CIDR format allowed to connect to the Kusto Cluster.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `autoScaleMax`

When auto-scale is enabled, the maximum number of instances in the Kusto Cluster.

- Required: No
- Type: int
- Default: `3`
- MinValue: 3
- MaxValue: 1000

### Parameter: `autoScaleMin`

When auto-scale is enabled, the minimum number of instances in the Kusto Cluster.

- Required: No
- Type: int
- Default: `2`
- MinValue: 2
- MaxValue: 999

### Parameter: `capacity`

The number of instances of the Kusto Cluster.

- Required: No
- Type: int
- Default: `2`
- MinValue: 2
- MaxValue: 999

### Parameter: `customerManagedKey`

The customer managed key definition.

- Required: No
- Type: object
- MinValue: 2
- MaxValue: 999

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-customermanagedkeykeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-customermanagedkeykeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, the deployment will use the latest version available at deployment time. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, the deployment will use the latest version available at deployment time.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `databases`

The Kusto Cluster databases.

- Required: No
- Type: array
- MinValue: 2
- MaxValue: 999

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-databaseskind) | string | The object type of the databse. |
| [`name`](#parameter-databasesname) | string | The name of the Kusto Cluster database. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`readWriteProperties`](#parameter-databasesreadwriteproperties) | object | Required if the database kind is ReadWrite. Contains the properties of the database. |

### Parameter: `databases.kind`

The object type of the databse.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ReadOnlyFollowing'
    'ReadWrite'
  ]
  ```
- MinValue: 2
- MaxValue: 999

### Parameter: `databases.name`

The name of the Kusto Cluster database.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `databases.readWriteProperties`

Required if the database kind is ReadWrite. Contains the properties of the database.

- Required: No
- Type: object
- MinValue: 2
- MaxValue: 999

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hotCachePeriod`](#parameter-databasesreadwritepropertieshotcacheperiod) | string | Te time the data should be kept in cache for fast queries in TimeSpan. |
| [`keyVaultProperties`](#parameter-databasesreadwritepropertieskeyvaultproperties) | object | The properties of the key vault. |
| [`softDeletePeriod`](#parameter-databasesreadwritepropertiessoftdeleteperiod) | string | The time the data should be kept before it stops being accessible to queries in TimeSpan. |

### Parameter: `databases.readWriteProperties.hotCachePeriod`

Te time the data should be kept in cache for fast queries in TimeSpan.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `databases.readWriteProperties.keyVaultProperties`

The properties of the key vault.

- Required: No
- Type: object
- MinValue: 2
- MaxValue: 999

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-databasesreadwritepropertieskeyvaultpropertieskeyname) | string | The name of the key. |
| [`keyVaultUri`](#parameter-databasesreadwritepropertieskeyvaultpropertieskeyvaulturi) | string | The Uri of the key vault. |
| [`keyVersion`](#parameter-databasesreadwritepropertieskeyvaultpropertieskeyversion) | string | The version of the key. |
| [`userIdentity`](#parameter-databasesreadwritepropertieskeyvaultpropertiesuseridentity) | string | The user identity. |

### Parameter: `databases.readWriteProperties.keyVaultProperties.keyName`

The name of the key.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `databases.readWriteProperties.keyVaultProperties.keyVaultUri`

The Uri of the key vault.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `databases.readWriteProperties.keyVaultProperties.keyVersion`

The version of the key.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `databases.readWriteProperties.keyVaultProperties.userIdentity`

The user identity.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `databases.readWriteProperties.softDeletePeriod`

The time the data should be kept before it stops being accessible to queries in TimeSpan.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array
- MinValue: 2
- MaxValue: 999

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```
- MinValue: 2
- MaxValue: 999

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array
- MinValue: 2
- MaxValue: 999

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool
- MinValue: 2
- MaxValue: 999

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array
- MinValue: 2
- MaxValue: 999

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool
- MinValue: 2
- MaxValue: 999

### Parameter: `diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `enableAutoScale`

Enable/disable auto-scale.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 2
- MaxValue: 999

### Parameter: `enableAutoStop`

Enable/disable auto-stop.

- Required: No
- Type: bool
- Default: `True`
- MinValue: 2
- MaxValue: 999

### Parameter: `enableDiskEncryption`

Enable/disable disk encryption.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 2
- MaxValue: 999

### Parameter: `enableDoubleEncryption`

Enable/disable double encryption.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 2
- MaxValue: 999

### Parameter: `enablePublicNetworkAccess`

Enable/disable public network access. If disabled, only private endpoint connection is allowed to the Kusto Cluster.

- Required: No
- Type: bool
- Default: `True`
- MinValue: 2
- MaxValue: 999

### Parameter: `enablePurge`

Enable/disable purge.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 2
- MaxValue: 999

### Parameter: `enableRestrictOutboundNetworkAccess`

Enable/disable restricting outbound network access.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 2
- MaxValue: 999

### Parameter: `enableStreamingIngest`

Enable/disable streaming ingest.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 2
- MaxValue: 999

### Parameter: `enableTelemetry`

Enable/disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`
- MinValue: 2
- MaxValue: 999

### Parameter: `enableZoneRedundant`

Enable/disable zone redundancy.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 2
- MaxValue: 999

### Parameter: `engineType`

The engine type of the Kusto Cluster.

- Required: No
- Type: string
- Default: `'V3'`
- Allowed:
  ```Bicep
  [
    'V2'
    'V3'
  ]
  ```
- MinValue: 2
- MaxValue: 999

### Parameter: `languageExtensions`

List of the language extensions of the Kusto Cluster.

- Required: No
- Type: array
- Default: `[]`
- MinValue: 2
- MaxValue: 999

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`languageExtensionCustomImageName`](#parameter-languageextensionslanguageextensioncustomimagename) | string | The name of the language extension custom image. |
| [`languageExtensionImageName`](#parameter-languageextensionslanguageextensionimagename) | string | The name of the language extension image. |
| [`languageExtensionName`](#parameter-languageextensionslanguageextensionname) | string | The name of the language extension. |

### Parameter: `languageExtensions.languageExtensionCustomImageName`

The name of the language extension custom image.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `languageExtensions.languageExtensionImageName`

The name of the language extension image.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Python3_10_8'
    'Python3_10_8_DL'
    'Python3_6_5'
    'PythonCustomImage'
    'R'
  ]
  ```
- MinValue: 2
- MaxValue: 999

### Parameter: `languageExtensions.languageExtensionName`

The name of the language extension.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'PYTHON'
    'R'
  ]
  ```
- MinValue: 2
- MaxValue: 999

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`
- MinValue: 2
- MaxValue: 999

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object
- MinValue: 2
- MaxValue: 999

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```
- MinValue: 2
- MaxValue: 999

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object
- MinValue: 2
- MaxValue: 999

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool
- MinValue: 2
- MaxValue: 999

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array
- MinValue: 2
- MaxValue: 999

### Parameter: `principalAssignments`

The Principal Assignments for the Kusto Cluster.

- Required: No
- Type: array
- MinValue: 2
- MaxValue: 999

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-principalassignmentsprincipalid) | string | The principal id assigned to the Kusto Cluster principal. It can be a user email, application id, or security group name. |
| [`principalType`](#parameter-principalassignmentsprincipaltype) | string | The principal type of the principal id. |
| [`role`](#parameter-principalassignmentsrole) | string | The Kusto Cluster role to be assigned to the principal id. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tenantId`](#parameter-principalassignmentstenantid) | string | The tenant id of the principal. |

### Parameter: `principalAssignments.principalId`

The principal id assigned to the Kusto Cluster principal. It can be a user email, application id, or security group name.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `principalAssignments.principalType`

The principal type of the principal id.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'App'
    'Group'
    'User'
  ]
  ```
- MinValue: 2
- MaxValue: 999

### Parameter: `principalAssignments.role`

The Kusto Cluster role to be assigned to the principal id.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AllDatabasesAdmin'
    'AllDatabasesViewer'
  ]
  ```
- MinValue: 2
- MaxValue: 999

### Parameter: `principalAssignments.tenantId`

The tenant id of the principal.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.

- Required: No
- Type: array
- MinValue: 2
- MaxValue: 999

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`service`](#parameter-privateendpointsservice) | string | The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file" for a Storage Account's Private Endpoints. |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | array | A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`isManualConnection`](#parameter-privateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-privateendpointslocation) | string | The location to deploy the private endpoint to. |
| [`lock`](#parameter-privateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-privateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-privateendpointsname) | string | The name of the private endpoint. |
| [`privateDnsZoneGroup`](#parameter-privateendpointsprivatednszonegroup) | object | The private DNS zone group to configure for the private endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-privateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupName`](#parameter-privateendpointsresourcegroupname) | string | Specify if you want to deploy the Private Endpoint into a different resource group than the main resource. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `privateEndpoints.service`

The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file" for a Storage Account's Private Endpoints.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array
- MinValue: 2
- MaxValue: 999

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | string | FQDN that resolves to private endpoint IP address. |

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

FQDN that resolves to private endpoint IP address.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.ipConfigurations`

A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array
- MinValue: 2
- MaxValue: 999

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-privateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `privateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object
- MinValue: 2
- MaxValue: 999

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-privateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-privateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-privateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `privateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.location`

The location to deploy the private endpoint to.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object
- MinValue: 2
- MaxValue: 999

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-privateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-privateendpointslockname) | string | Specify the name of lock. |

### Parameter: `privateEndpoints.lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.name`

The name of the private endpoint.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.privateDnsZoneGroup`

The private DNS zone group to configure for the private endpoint.

- Required: No
- Type: object
- MinValue: 2
- MaxValue: 999

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones.

- Required: Yes
- Type: array
- MinValue: 2
- MaxValue: 999

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS Zone Group config. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS Zone Group config.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.resourceGroupName`

Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- MinValue: 2
- MaxValue: 999
- Roles configurable by name:
  - `'Contributor'`
  - `'DNS Resolver Contributor'`
  - `'DNS Zone Contributor'`
  - `'Domain Services Contributor'`
  - `'Domain Services Reader'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Private DNS Zone Contributor'`
  - `'Reader'`
  - `'Role Based Access Control Administrator (Preview)'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-privateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-privateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-privateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-privateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-privateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-privateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-privateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-privateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `privateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```
- MinValue: 2
- MaxValue: 999

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object
- MinValue: 2
- MaxValue: 999

### Parameter: `publicIPType`

Indicates what public IP type to create - IPv4 (default), or DualStack (both IPv4 and IPv6).

- Required: No
- Type: string
- Default: `'DualStack'`
- Allowed:
  ```Bicep
  [
    'DualStack'
    'IPv4'
    'IPv6'
  ]
  ```
- MinValue: 2
- MaxValue: 999

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- MinValue: 2
- MaxValue: 999
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```
- MinValue: 2
- MaxValue: 999

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```
- MinValue: 2
- MaxValue: 999

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object
- MinValue: 2
- MaxValue: 999

### Parameter: `tier`

The tier of the Kusto Cluster.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Standard'
  ]
  ```
- MinValue: 2
- MaxValue: 999

### Parameter: `trustedExternalTenants`

The external tenants trusted by the Kusto Cluster.

- Required: No
- Type: array
- Default: `[]`
- MinValue: 2
- MaxValue: 999

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`value`](#parameter-trustedexternaltenantsvalue) | string | GUID representing an external tenant. |

### Parameter: `trustedExternalTenants.value`

GUID representing an external tenant.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `virtualClusterGraduationProperties`

The virtual cluster graduation properties of the Kusto Cluster.

- Required: No
- Type: securestring
- MinValue: 2
- MaxValue: 999

### Parameter: `virtualNetworkConfiguration`

The virtual network configuration of the Kusto Cluster.

- Required: No
- Type: object
- MinValue: 2
- MaxValue: 999

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataManagementPublicIpResourceId`](#parameter-virtualnetworkconfigurationdatamanagementpublicipresourceid) | string | The public IP address resource id of the data management service.. |
| [`enginePublicIpResourceId`](#parameter-virtualnetworkconfigurationenginepublicipresourceid) | string | The public IP address resource id of the engine service. |
| [`subnetResourceId`](#parameter-virtualnetworkconfigurationsubnetresourceid) | string | The resource ID of the subnet to which to deploy the Kusto Cluster. |

### Parameter: `virtualNetworkConfiguration.dataManagementPublicIpResourceId`

The public IP address resource id of the data management service..

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `virtualNetworkConfiguration.enginePublicIpResourceId`

The public IP address resource id of the engine service.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

### Parameter: `virtualNetworkConfiguration.subnetResourceId`

The resource ID of the subnet to which to deploy the Kusto Cluster.

- Required: Yes
- Type: string
- MinValue: 2
- MaxValue: 999

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `databases` | array | The databases of the kusto cluster. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the kusto cluster. |
| `privateEndpoints` | array | The private endpoints of the kusto cluster. |
| `resourceGroupName` | string | The resource group the kusto cluster was deployed into. |
| `resourceId` | string | The resource id of the kusto cluster. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.7.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.4.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

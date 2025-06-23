# Synapse Workspaces `[Microsoft.Synapse/workspaces]`

This module deploys a Synapse Workspace.

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
| `Microsoft.KeyVault/vaults/accessPolicies` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/accessPolicies) |
| `Microsoft.Network/privateEndpoints` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Synapse/workspaces` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces) |
| `Microsoft.Synapse/workspaces/administrators` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/administrators) |
| `Microsoft.Synapse/workspaces/bigDataPools` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/bigDataPools) |
| `Microsoft.Synapse/workspaces/firewallRules` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/firewallRules) |
| `Microsoft.Synapse/workspaces/integrationRuntimes` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/integrationRuntimes) |
| `Microsoft.Synapse/workspaces/keys` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/keys) |
| `Microsoft.Synapse/workspaces/sqlPools` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/sqlPools) |
| `Microsoft.Synapse/workspaces/sqlPools/transparentDataEncryption` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/sqlPools/transparentDataEncryption) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/synapse/workspace:<version>`.

- [Using Big Data Pool](#example-1-using-big-data-pool)
- [Using only defaults](#example-2-using-only-defaults)
- [Using encryption with Customer-Managed-Key](#example-3-using-encryption-with-customer-managed-key)
- [Using encryption with Customer-Managed-Key](#example-4-using-encryption-with-customer-managed-key)
- [Using firewall rules](#example-5-using-firewall-rules)
- [Using managed Vnet](#example-6-using-managed-vnet)
- [Using large parameter set](#example-7-using-large-parameter-set)
- [Using SQL Pool](#example-8-using-sql-pool)
- [WAF-aligned](#example-9-waf-aligned)

### Example 1: _Using Big Data Pool_

This instance deploys the module with the configuration of Big Data Pool.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/synapse/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountResourceId: '<defaultDataLakeStorageAccountResourceId>'
    defaultDataLakeStorageFilesystem: '<defaultDataLakeStorageFilesystem>'
    name: 'swbdp001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    bigDataPools: [
      {
        autoPauseDelayInMinutes: 10
        autoScale: {
          maxNodeCount: 5
          minNodeCount: 3
        }
        autotuneEnabled: true
        cacheSize: 50
        dynamicExecutorAllocation: {
          maxExecutors: 4
          minExecutors: 1
        }
        name: 'depbdp01'
        nodeSize: 'Small'
        nodeSizeFamily: 'MemoryOptimized'
        sessionLevelPackagesEnabled: true
      }
      {
        name: 'depbdp02'
        nodeSize: 'Small'
        nodeSizeFamily: 'MemoryOptimized'
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
    "defaultDataLakeStorageAccountResourceId": {
      "value": "<defaultDataLakeStorageAccountResourceId>"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "<defaultDataLakeStorageFilesystem>"
    },
    "name": {
      "value": "swbdp001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "bigDataPools": {
      "value": [
        {
          "autoPauseDelayInMinutes": 10,
          "autoScale": {
            "maxNodeCount": 5,
            "minNodeCount": 3
          },
          "autotuneEnabled": true,
          "cacheSize": 50,
          "dynamicExecutorAllocation": {
            "maxExecutors": 4,
            "minExecutors": 1
          },
          "name": "depbdp01",
          "nodeSize": "Small",
          "nodeSizeFamily": "MemoryOptimized",
          "sessionLevelPackagesEnabled": true
        },
        {
          "name": "depbdp02",
          "nodeSize": "Small",
          "nodeSizeFamily": "MemoryOptimized"
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
using 'br/public:avm/res/synapse/workspace:<version>'

// Required parameters
param defaultDataLakeStorageAccountResourceId = '<defaultDataLakeStorageAccountResourceId>'
param defaultDataLakeStorageFilesystem = '<defaultDataLakeStorageFilesystem>'
param name = 'swbdp001'
param sqlAdministratorLogin = 'synwsadmin'
// Non-required parameters
param bigDataPools = [
  {
    autoPauseDelayInMinutes: 10
    autoScale: {
      maxNodeCount: 5
      minNodeCount: 3
    }
    autotuneEnabled: true
    cacheSize: 50
    dynamicExecutorAllocation: {
      maxExecutors: 4
      minExecutors: 1
    }
    name: 'depbdp01'
    nodeSize: 'Small'
    nodeSizeFamily: 'MemoryOptimized'
    sessionLevelPackagesEnabled: true
  }
  {
    name: 'depbdp02'
    nodeSize: 'Small'
    nodeSizeFamily: 'MemoryOptimized'
  }
]
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/synapse/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountResourceId: '<defaultDataLakeStorageAccountResourceId>'
    defaultDataLakeStorageFilesystem: '<defaultDataLakeStorageFilesystem>'
    name: 'swmin001'
    sqlAdministratorLogin: 'synwsadmin'
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
    "defaultDataLakeStorageAccountResourceId": {
      "value": "<defaultDataLakeStorageAccountResourceId>"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "<defaultDataLakeStorageFilesystem>"
    },
    "name": {
      "value": "swmin001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/synapse/workspace:<version>'

// Required parameters
param defaultDataLakeStorageAccountResourceId = '<defaultDataLakeStorageAccountResourceId>'
param defaultDataLakeStorageFilesystem = '<defaultDataLakeStorageFilesystem>'
param name = 'swmin001'
param sqlAdministratorLogin = 'synwsadmin'
```

</details>
<p>

### Example 3: _Using encryption with Customer-Managed-Key_

This instance deploys the module using Customer-Managed-Keys using a System-Assigned Identity to access the Customer-Managed-Key secret.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/synapse/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountResourceId: '<defaultDataLakeStorageAccountResourceId>'
    defaultDataLakeStorageFilesystem: '<defaultDataLakeStorageFilesystem>'
    name: 'swensa001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
    }
    encryptionActivateWorkspace: true
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
    "defaultDataLakeStorageAccountResourceId": {
      "value": "<defaultDataLakeStorageAccountResourceId>"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "<defaultDataLakeStorageFilesystem>"
    },
    "name": {
      "value": "swensa001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>"
      }
    },
    "encryptionActivateWorkspace": {
      "value": true
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/synapse/workspace:<version>'

// Required parameters
param defaultDataLakeStorageAccountResourceId = '<defaultDataLakeStorageAccountResourceId>'
param defaultDataLakeStorageFilesystem = '<defaultDataLakeStorageFilesystem>'
param name = 'swensa001'
param sqlAdministratorLogin = 'synwsadmin'
// Non-required parameters
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
}
param encryptionActivateWorkspace = true
```

</details>
<p>

### Example 4: _Using encryption with Customer-Managed-Key_

This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/synapse/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountResourceId: '<defaultDataLakeStorageAccountResourceId>'
    defaultDataLakeStorageFilesystem: '<defaultDataLakeStorageFilesystem>'
    name: 'swenua001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
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
    "defaultDataLakeStorageAccountResourceId": {
      "value": "<defaultDataLakeStorageAccountResourceId>"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "<defaultDataLakeStorageFilesystem>"
    },
    "name": {
      "value": "swenua001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
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
using 'br/public:avm/res/synapse/workspace:<version>'

// Required parameters
param defaultDataLakeStorageAccountResourceId = '<defaultDataLakeStorageAccountResourceId>'
param defaultDataLakeStorageFilesystem = '<defaultDataLakeStorageFilesystem>'
param name = 'swenua001'
param sqlAdministratorLogin = 'synwsadmin'
// Non-required parameters
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
```

</details>
<p>

### Example 5: _Using firewall rules_

This instance deploys the module with the configuration of firewall rules.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/synapse/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountResourceId: '<defaultDataLakeStorageAccountResourceId>'
    defaultDataLakeStorageFilesystem: '<defaultDataLakeStorageFilesystem>'
    name: 'swfwr001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    firewallRules: [
      {
        endIpAddress: '87.14.134.20'
        name: 'fwrule01'
        startIpAddress: '87.14.134.20'
      }
      {
        endIpAddress: '87.14.134.22'
        name: 'fwrule02'
        startIpAddress: '87.14.134.21'
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
    "defaultDataLakeStorageAccountResourceId": {
      "value": "<defaultDataLakeStorageAccountResourceId>"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "<defaultDataLakeStorageFilesystem>"
    },
    "name": {
      "value": "swfwr001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "firewallRules": {
      "value": [
        {
          "endIpAddress": "87.14.134.20",
          "name": "fwrule01",
          "startIpAddress": "87.14.134.20"
        },
        {
          "endIpAddress": "87.14.134.22",
          "name": "fwrule02",
          "startIpAddress": "87.14.134.21"
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
using 'br/public:avm/res/synapse/workspace:<version>'

// Required parameters
param defaultDataLakeStorageAccountResourceId = '<defaultDataLakeStorageAccountResourceId>'
param defaultDataLakeStorageFilesystem = '<defaultDataLakeStorageFilesystem>'
param name = 'swfwr001'
param sqlAdministratorLogin = 'synwsadmin'
// Non-required parameters
param firewallRules = [
  {
    endIpAddress: '87.14.134.20'
    name: 'fwrule01'
    startIpAddress: '87.14.134.20'
  }
  {
    endIpAddress: '87.14.134.22'
    name: 'fwrule02'
    startIpAddress: '87.14.134.21'
  }
]
```

</details>
<p>

### Example 6: _Using managed Vnet_

This instance deploys the module using a managed Vnet.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/synapse/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountResourceId: '<defaultDataLakeStorageAccountResourceId>'
    defaultDataLakeStorageFilesystem: '<defaultDataLakeStorageFilesystem>'
    name: 'swmanv001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    allowedAadTenantIdsForLinking: [
      '<tenantId>'
    ]
    managedVirtualNetwork: true
    preventDataExfiltration: true
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
    "defaultDataLakeStorageAccountResourceId": {
      "value": "<defaultDataLakeStorageAccountResourceId>"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "<defaultDataLakeStorageFilesystem>"
    },
    "name": {
      "value": "swmanv001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "allowedAadTenantIdsForLinking": {
      "value": [
        "<tenantId>"
      ]
    },
    "managedVirtualNetwork": {
      "value": true
    },
    "preventDataExfiltration": {
      "value": true
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/synapse/workspace:<version>'

// Required parameters
param defaultDataLakeStorageAccountResourceId = '<defaultDataLakeStorageAccountResourceId>'
param defaultDataLakeStorageFilesystem = '<defaultDataLakeStorageFilesystem>'
param name = 'swmanv001'
param sqlAdministratorLogin = 'synwsadmin'
// Non-required parameters
param allowedAadTenantIdsForLinking = [
  '<tenantId>'
]
param managedVirtualNetwork = true
param preventDataExfiltration = true
```

</details>
<p>

### Example 7: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/synapse/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountResourceId: '<defaultDataLakeStorageAccountResourceId>'
    defaultDataLakeStorageFilesystem: '<defaultDataLakeStorageFilesystem>'
    name: 'swmax001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    administrator: {
      administratorType: 'ServicePrincipal'
      login: 'dep-msi-swmax'
      sid: '<sid>'
    }
    bigDataPools: [
      {
        autoPauseDelayInMinutes: 5
        autoScale: {
          maxNodeCount: 10
          minNodeCount: 3
        }
        autotuneEnabled: true
        cacheSize: 50
        defaultSparkLogFolder: '/logs'
        diagnosticSettings: [
          {
            eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
            eventHubName: '<eventHubName>'
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
            name: 'customSetting'
            storageAccountResourceId: '<storageAccountResourceId>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
        dynamicExecutorAllocation: {
          maxExecutors: 9
          minExecutors: 1
        }
        lock: {
          kind: 'CanNotDelete'
          name: 'myCustomLockName'
        }
        name: 'depbdp01'
        nodeSize: 'Large'
        nodeSizeFamily: 'MemoryOptimized'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        sessionLevelPackagesEnabled: true
        sparkConfigProperties: {
          configurationType: 'File'
          content: '<content>'
          filename: 'spark-defaults.conf'
        }
        sparkEventsFolder: '/events'
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            category: 'SynapseRbacOperations'
          }
          {
            category: 'SynapseLinkEvent'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    initialWorkspaceAdminObjectID: '<initialWorkspaceAdminObjectID>'
    integrationRuntimes: [
      {
        name: 'shir01'
        type: 'SelfHosted'
      }
    ]
    location: '<location>'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    managedVirtualNetwork: true
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'SQL'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'SQL'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'SqlOnDemand'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'Dev'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    roleAssignments: [
      {
        name: '499f9243-2170-4204-807d-ee6d0f94a0d0'
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
    sqlPools: [
      {
        collation: 'SQL_Latin1_General_CP1_CS_AS'
        diagnosticSettings: [
          {
            eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
            eventHubName: '<eventHubName>'
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
            name: 'customSetting'
            storageAccountResourceId: '<storageAccountResourceId>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
        lock: {
          kind: 'CanNotDelete'
          name: 'myCustomLockName'
        }
        maxSizeBytes: 1099511627776
        name: 'depsqlp01'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        sku: 'DW100c'
        storageAccountType: 'GRS'
        transparentDataEncryption: 'Enabled'
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
    "defaultDataLakeStorageAccountResourceId": {
      "value": "<defaultDataLakeStorageAccountResourceId>"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "<defaultDataLakeStorageFilesystem>"
    },
    "name": {
      "value": "swmax001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "administrator": {
      "value": {
        "administratorType": "ServicePrincipal",
        "login": "dep-msi-swmax",
        "sid": "<sid>"
      }
    },
    "bigDataPools": {
      "value": [
        {
          "autoPauseDelayInMinutes": 5,
          "autoScale": {
            "maxNodeCount": 10,
            "minNodeCount": 3
          },
          "autotuneEnabled": true,
          "cacheSize": 50,
          "defaultSparkLogFolder": "/logs",
          "diagnosticSettings": [
            {
              "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
              "eventHubName": "<eventHubName>",
              "metricCategories": [
                {
                  "category": "AllMetrics"
                }
              ],
              "name": "customSetting",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ],
          "dynamicExecutorAllocation": {
            "maxExecutors": 9,
            "minExecutors": 1
          },
          "lock": {
            "kind": "CanNotDelete",
            "name": "myCustomLockName"
          },
          "name": "depbdp01",
          "nodeSize": "Large",
          "nodeSizeFamily": "MemoryOptimized",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "sessionLevelPackagesEnabled": true,
          "sparkConfigProperties": {
            "configurationType": "File",
            "content": "<content>",
            "filename": "spark-defaults.conf"
          },
          "sparkEventsFolder": "/events"
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "category": "SynapseRbacOperations"
            },
            {
              "category": "SynapseLinkEvent"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "initialWorkspaceAdminObjectID": {
      "value": "<initialWorkspaceAdminObjectID>"
    },
    "integrationRuntimes": {
      "value": [
        {
          "name": "shir01",
          "type": "SelfHosted"
        }
      ]
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
    "managedVirtualNetwork": {
      "value": true
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
          "service": "SQL",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        },
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "SQL",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        },
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "SqlOnDemand",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        },
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "Dev",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "499f9243-2170-4204-807d-ee6d0f94a0d0",
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
    },
    "sqlPools": {
      "value": [
        {
          "collation": "SQL_Latin1_General_CP1_CS_AS",
          "diagnosticSettings": [
            {
              "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
              "eventHubName": "<eventHubName>",
              "metricCategories": [
                {
                  "category": "AllMetrics"
                }
              ],
              "name": "customSetting",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ],
          "lock": {
            "kind": "CanNotDelete",
            "name": "myCustomLockName"
          },
          "maxSizeBytes": 1099511627776,
          "name": "depsqlp01",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "sku": "DW100c",
          "storageAccountType": "GRS",
          "transparentDataEncryption": "Enabled"
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
using 'br/public:avm/res/synapse/workspace:<version>'

// Required parameters
param defaultDataLakeStorageAccountResourceId = '<defaultDataLakeStorageAccountResourceId>'
param defaultDataLakeStorageFilesystem = '<defaultDataLakeStorageFilesystem>'
param name = 'swmax001'
param sqlAdministratorLogin = 'synwsadmin'
// Non-required parameters
param administrator = {
  administratorType: 'ServicePrincipal'
  login: 'dep-msi-swmax'
  sid: '<sid>'
}
param bigDataPools = [
  {
    autoPauseDelayInMinutes: 5
    autoScale: {
      maxNodeCount: 10
      minNodeCount: 3
    }
    autotuneEnabled: true
    cacheSize: 50
    defaultSparkLogFolder: '/logs'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    dynamicExecutorAllocation: {
      maxExecutors: 9
      minExecutors: 1
    }
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    name: 'depbdp01'
    nodeSize: 'Large'
    nodeSizeFamily: 'MemoryOptimized'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    sessionLevelPackagesEnabled: true
    sparkConfigProperties: {
      configurationType: 'File'
      content: '<content>'
      filename: 'spark-defaults.conf'
    }
    sparkEventsFolder: '/events'
  }
]
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        category: 'SynapseRbacOperations'
      }
      {
        category: 'SynapseLinkEvent'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param initialWorkspaceAdminObjectID = '<initialWorkspaceAdminObjectID>'
param integrationRuntimes = [
  {
    name: 'shir01'
    type: 'SelfHosted'
  }
]
param location = '<location>'
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param managedVirtualNetwork = true
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'SQL'
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'SQL'
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'SqlOnDemand'
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'Dev'
    subnetResourceId: '<subnetResourceId>'
  }
]
param roleAssignments = [
  {
    name: '499f9243-2170-4204-807d-ee6d0f94a0d0'
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
param sqlPools = [
  {
    collation: 'SQL_Latin1_General_CP1_CS_AS'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    maxSizeBytes: 1099511627776
    name: 'depsqlp01'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    sku: 'DW100c'
    storageAccountType: 'GRS'
    transparentDataEncryption: 'Enabled'
  }
]
```

</details>
<p>

### Example 8: _Using SQL Pool_

This instance deploys the module with the configuration of SQL Pool.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/synapse/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountResourceId: '<defaultDataLakeStorageAccountResourceId>'
    defaultDataLakeStorageFilesystem: '<defaultDataLakeStorageFilesystem>'
    name: 'swsqlp001'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    sqlPools: [
      {
        name: 'depsqlp01'
      }
      {
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        maxSizeBytes: 1099511627776
        name: 'depsqlp02'
        sku: 'DW200c'
        storageAccountType: 'LRS'
        transparentDataEncryption: 'Enabled'
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
    "defaultDataLakeStorageAccountResourceId": {
      "value": "<defaultDataLakeStorageAccountResourceId>"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "<defaultDataLakeStorageFilesystem>"
    },
    "name": {
      "value": "swsqlp001"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "sqlPools": {
      "value": [
        {
          "name": "depsqlp01"
        },
        {
          "collation": "SQL_Latin1_General_CP1_CI_AS",
          "maxSizeBytes": 1099511627776,
          "name": "depsqlp02",
          "sku": "DW200c",
          "storageAccountType": "LRS",
          "transparentDataEncryption": "Enabled"
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
using 'br/public:avm/res/synapse/workspace:<version>'

// Required parameters
param defaultDataLakeStorageAccountResourceId = '<defaultDataLakeStorageAccountResourceId>'
param defaultDataLakeStorageFilesystem = '<defaultDataLakeStorageFilesystem>'
param name = 'swsqlp001'
param sqlAdministratorLogin = 'synwsadmin'
// Non-required parameters
param sqlPools = [
  {
    name: 'depsqlp01'
  }
  {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1099511627776
    name: 'depsqlp02'
    sku: 'DW200c'
    storageAccountType: 'LRS'
    transparentDataEncryption: 'Enabled'
  }
]
```

</details>
<p>

### Example 9: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/synapse/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    defaultDataLakeStorageAccountResourceId: '<defaultDataLakeStorageAccountResourceId>'
    defaultDataLakeStorageFilesystem: '<defaultDataLakeStorageFilesystem>'
    name: 'swwaf002'
    sqlAdministratorLogin: 'synwsadmin'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            category: 'SynapseRbacOperations'
          }
          {
            category: 'SynapseLinkEvent'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    integrationRuntimes: [
      {
        name: 'shir01'
        type: 'SelfHosted'
      }
    ]
    managedVirtualNetwork: true
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'SQL'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
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
    "defaultDataLakeStorageAccountResourceId": {
      "value": "<defaultDataLakeStorageAccountResourceId>"
    },
    "defaultDataLakeStorageFilesystem": {
      "value": "<defaultDataLakeStorageFilesystem>"
    },
    "name": {
      "value": "swwaf002"
    },
    "sqlAdministratorLogin": {
      "value": "synwsadmin"
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "category": "SynapseRbacOperations"
            },
            {
              "category": "SynapseLinkEvent"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "integrationRuntimes": {
      "value": [
        {
          "name": "shir01",
          "type": "SelfHosted"
        }
      ]
    },
    "managedVirtualNetwork": {
      "value": true
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
          "service": "SQL",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
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
using 'br/public:avm/res/synapse/workspace:<version>'

// Required parameters
param defaultDataLakeStorageAccountResourceId = '<defaultDataLakeStorageAccountResourceId>'
param defaultDataLakeStorageFilesystem = '<defaultDataLakeStorageFilesystem>'
param name = 'swwaf002'
param sqlAdministratorLogin = 'synwsadmin'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        category: 'SynapseRbacOperations'
      }
      {
        category: 'SynapseLinkEvent'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param integrationRuntimes = [
  {
    name: 'shir01'
    type: 'SelfHosted'
  }
]
param managedVirtualNetwork = true
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'SQL'
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`defaultDataLakeStorageAccountResourceId`](#parameter-defaultdatalakestorageaccountresourceid) | string | Resource ID of the default ADLS Gen2 storage account. |
| [`defaultDataLakeStorageFilesystem`](#parameter-defaultdatalakestoragefilesystem) | string | The default ADLS Gen2 file system. |
| [`name`](#parameter-name) | string | The name of the Synapse Workspace. |
| [`sqlAdministratorLogin`](#parameter-sqladministratorlogin) | string | Login for administrator access to the workspace's SQL pools. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accountUrl`](#parameter-accounturl) | string | The account URL of the data lake storage account. |
| [`administrator`](#parameter-administrator) | object | The Entra ID administrator for the synapse workspace. |
| [`allowedAadTenantIdsForLinking`](#parameter-allowedaadtenantidsforlinking) | array | Allowed AAD Tenant IDs For Linking. |
| [`azureADOnlyAuthentication`](#parameter-azureadonlyauthentication) | bool | Enable or Disable AzureADOnlyAuthentication on All Workspace sub-resource. |
| [`bigDataPools`](#parameter-bigdatapools) | array | List of Big Data Pools to be created in the workspace. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`defaultDataLakeStorageCreateManagedPrivateEndpoint`](#parameter-defaultdatalakestoragecreatemanagedprivateendpoint) | bool | Create managed private endpoint to the default storage account or not. If Yes is selected, a managed private endpoint connection request is sent to the workspace's primary Data Lake Storage Gen2 account for Spark pools to access data. This must be approved by an owner of the storage account. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`encryptionActivateWorkspace`](#parameter-encryptionactivateworkspace) | bool | Activate workspace by adding the system managed identity in the KeyVault containing the customer managed key and activating the workspace. |
| [`firewallRules`](#parameter-firewallrules) | array | List of firewall rules to be created in the workspace. |
| [`initialWorkspaceAdminObjectID`](#parameter-initialworkspaceadminobjectid) | string | AAD object ID of initial workspace admin. |
| [`integrationRuntimes`](#parameter-integrationruntimes) | array | The Integration Runtimes to create. |
| [`linkedAccessCheckOnTargetResource`](#parameter-linkedaccesscheckontargetresource) | bool | Linked Access Check On Target Resource. |
| [`location`](#parameter-location) | string | The geo-location where the resource lives. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`managedResourceGroupName`](#parameter-managedresourcegroupname) | string | Workspace managed resource group. The resource group name uniquely identifies the resource group within the user subscriptionId. The resource group name must be no longer than 90 characters long, and must be alphanumeric characters (Char.IsLetterOrDigit()) and '-', '_', '(', ')' and'.'. Note that the name cannot end with '.'. |
| [`managedVirtualNetwork`](#parameter-managedvirtualnetwork) | bool | Enable this to ensure that connection from your workspace to your data sources use Azure Private Links. You can create managed private endpoints to your data sources. |
| [`preventDataExfiltration`](#parameter-preventdataexfiltration) | bool | Prevent Data Exfiltration. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Enable or Disable public network access to workspace. |
| [`purviewResourceID`](#parameter-purviewresourceid) | string | Purview Resource ID. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sqlAdministratorLoginPassword`](#parameter-sqladministratorloginpassword) | securestring | Password for administrator access to the workspace's SQL pools. If you don't provide a password, one will be automatically generated. You can change the password later. |
| [`sqlPools`](#parameter-sqlpools) | array | List of SQL Pools to be created in the workspace. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`workspaceRepositoryConfiguration`](#parameter-workspacerepositoryconfiguration) | object | Git integration settings. |

### Parameter: `defaultDataLakeStorageAccountResourceId`

Resource ID of the default ADLS Gen2 storage account.

- Required: Yes
- Type: string

### Parameter: `defaultDataLakeStorageFilesystem`

The default ADLS Gen2 file system.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the Synapse Workspace.

- Required: Yes
- Type: string

### Parameter: `sqlAdministratorLogin`

Login for administrator access to the workspace's SQL pools.

- Required: Yes
- Type: string

### Parameter: `accountUrl`

The account URL of the data lake storage account.

- Required: No
- Type: string
- Default: `[format('https://{0}.dfs.{1}', last(split(parameters('defaultDataLakeStorageAccountResourceId'), '/')), environment().suffixes.storage)]`

### Parameter: `administrator`

The Entra ID administrator for the synapse workspace.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`administratorType`](#parameter-administratoradministratortype) | string | Workspace active directory administrator type. |
| [`login`](#parameter-administratorlogin) | securestring | Login of the workspace active directory administrator. |
| [`sid`](#parameter-administratorsid) | securestring | Object ID of the workspace active directory administrator. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tenantId`](#parameter-administratortenantid) | securestring | Tenant ID of the workspace active directory administrator. |

### Parameter: `administrator.administratorType`

Workspace active directory administrator type.

- Required: Yes
- Type: string

### Parameter: `administrator.login`

Login of the workspace active directory administrator.

- Required: Yes
- Type: securestring

### Parameter: `administrator.sid`

Object ID of the workspace active directory administrator.

- Required: Yes
- Type: securestring

### Parameter: `administrator.tenantId`

Tenant ID of the workspace active directory administrator.

- Required: No
- Type: securestring

### Parameter: `allowedAadTenantIdsForLinking`

Allowed AAD Tenant IDs For Linking.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `azureADOnlyAuthentication`

Enable or Disable AzureADOnlyAuthentication on All Workspace sub-resource.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `bigDataPools`

List of Big Data Pools to be created in the workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-bigdatapoolsname) | string | The name of the Big Data Pool. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoPauseDelayInMinutes`](#parameter-bigdatapoolsautopausedelayinminutes) | int | Synapse workspace Big Data Pools Auto-pausing delay in minutes (5-10080). Disabled if value not provided. |
| [`autoScale`](#parameter-bigdatapoolsautoscale) | object | The auto scale configuration. |
| [`autotuneEnabled`](#parameter-bigdatapoolsautotuneenabled) | bool | Enable or disable autotune. |
| [`cacheSize`](#parameter-bigdatapoolscachesize) | int | The cache size of the pool. |
| [`computeIsolationEnabled`](#parameter-bigdatapoolscomputeisolationenabled) | bool | Enable or disable compute isolation. |
| [`defaultSparkLogFolder`](#parameter-bigdatapoolsdefaultsparklogfolder) | string | The default Spark log folder. |
| [`diagnosticSettings`](#parameter-bigdatapoolsdiagnosticsettings) | array | The diagnostic settings of the service. |
| [`dynamicExecutorAllocation`](#parameter-bigdatapoolsdynamicexecutorallocation) | object | The dynamic executor allocation configuration. |
| [`lock`](#parameter-bigdatapoolslock) | object | The lock settings of the service. |
| [`nodeCount`](#parameter-bigdatapoolsnodecount) | int | The number of nodes in the Big Data pool if Auto-scaling is disabled. |
| [`nodeSize`](#parameter-bigdatapoolsnodesize) | string | The node size of the pool. |
| [`nodeSizeFamily`](#parameter-bigdatapoolsnodesizefamily) | string | The node size family of the pool. |
| [`roleAssignments`](#parameter-bigdatapoolsroleassignments) | array | Array of role assignments to create. |
| [`sessionLevelPackagesEnabled`](#parameter-bigdatapoolssessionlevelpackagesenabled) | bool | Enable or disable session level packages. |
| [`sparkConfigProperties`](#parameter-bigdatapoolssparkconfigproperties) | object | The Spark configuration properties. |
| [`sparkEventsFolder`](#parameter-bigdatapoolssparkeventsfolder) | string | The Spark events folder. |
| [`sparkVersion`](#parameter-bigdatapoolssparkversion) | string | The Spark version. |
| [`tags`](#parameter-bigdatapoolstags) | object | Tags of the resource. |

### Parameter: `bigDataPools.name`

The name of the Big Data Pool.

- Required: Yes
- Type: string

### Parameter: `bigDataPools.autoPauseDelayInMinutes`

Synapse workspace Big Data Pools Auto-pausing delay in minutes (5-10080). Disabled if value not provided.

- Required: No
- Type: int

### Parameter: `bigDataPools.autoScale`

The auto scale configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`maxNodeCount`](#parameter-bigdatapoolsautoscalemaxnodecount) | int | Synapse workspace Big Data Pools Auto-scaling maximum node count. |
| [`minNodeCount`](#parameter-bigdatapoolsautoscaleminnodecount) | int | Synapse workspace Big Data Pools Auto-scaling minimum node count. |

### Parameter: `bigDataPools.autoScale.maxNodeCount`

Synapse workspace Big Data Pools Auto-scaling maximum node count.

- Required: Yes
- Type: int
- MinValue: 3
- MaxValue: 200

### Parameter: `bigDataPools.autoScale.minNodeCount`

Synapse workspace Big Data Pools Auto-scaling minimum node count.

- Required: Yes
- Type: int
- MinValue: 3
- MaxValue: 200

### Parameter: `bigDataPools.autotuneEnabled`

Enable or disable autotune.

- Required: No
- Type: bool

### Parameter: `bigDataPools.cacheSize`

The cache size of the pool.

- Required: No
- Type: int

### Parameter: `bigDataPools.computeIsolationEnabled`

Enable or disable compute isolation.

- Required: No
- Type: bool

### Parameter: `bigDataPools.defaultSparkLogFolder`

The default Spark log folder.

- Required: No
- Type: string

### Parameter: `bigDataPools.diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-bigdatapoolsdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-bigdatapoolsdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-bigdatapoolsdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-bigdatapoolsdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-bigdatapoolsdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-bigdatapoolsdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-bigdatapoolsdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-bigdatapoolsdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-bigdatapoolsdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `bigDataPools.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `bigDataPools.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `bigDataPools.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `bigDataPools.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-bigdatapoolsdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-bigdatapoolsdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-bigdatapoolsdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `bigDataPools.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `bigDataPools.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `bigDataPools.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `bigDataPools.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `bigDataPools.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-bigdatapoolsdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-bigdatapoolsdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `bigDataPools.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `bigDataPools.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `bigDataPools.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `bigDataPools.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `bigDataPools.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `bigDataPools.dynamicExecutorAllocation`

The dynamic executor allocation configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`maxExecutors`](#parameter-bigdatapoolsdynamicexecutorallocationmaxexecutors) | int | Synapse workspace Big Data Pools Dynamic Executor Allocation maximum executors (maxNodeCount-1). |
| [`minExecutors`](#parameter-bigdatapoolsdynamicexecutorallocationminexecutors) | int | Synapse workspace Big Data Pools Dynamic Executor Allocation minimum executors. |

### Parameter: `bigDataPools.dynamicExecutorAllocation.maxExecutors`

Synapse workspace Big Data Pools Dynamic Executor Allocation maximum executors (maxNodeCount-1).

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 10

### Parameter: `bigDataPools.dynamicExecutorAllocation.minExecutors`

Synapse workspace Big Data Pools Dynamic Executor Allocation minimum executors.

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 10

### Parameter: `bigDataPools.lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-bigdatapoolslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-bigdatapoolslockname) | string | Specify the name of lock. |

### Parameter: `bigDataPools.lock.kind`

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

### Parameter: `bigDataPools.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `bigDataPools.nodeCount`

The number of nodes in the Big Data pool if Auto-scaling is disabled.

- Required: No
- Type: int

### Parameter: `bigDataPools.nodeSize`

The node size of the pool.

- Required: No
- Type: string

### Parameter: `bigDataPools.nodeSizeFamily`

The node size family of the pool.

- Required: No
- Type: string

### Parameter: `bigDataPools.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-bigdatapoolsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-bigdatapoolsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-bigdatapoolsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-bigdatapoolsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-bigdatapoolsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-bigdatapoolsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-bigdatapoolsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-bigdatapoolsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `bigDataPools.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `bigDataPools.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `bigDataPools.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `bigDataPools.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `bigDataPools.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `bigDataPools.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `bigDataPools.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `bigDataPools.roleAssignments.principalType`

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

### Parameter: `bigDataPools.sessionLevelPackagesEnabled`

Enable or disable session level packages.

- Required: No
- Type: bool

### Parameter: `bigDataPools.sparkConfigProperties`

The Spark configuration properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`configurationType`](#parameter-bigdatapoolssparkconfigpropertiesconfigurationtype) | string | The configuration type. |
| [`content`](#parameter-bigdatapoolssparkconfigpropertiescontent) | string | The configuration content. |
| [`filename`](#parameter-bigdatapoolssparkconfigpropertiesfilename) | string | The configuration filename. |

### Parameter: `bigDataPools.sparkConfigProperties.configurationType`

The configuration type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Artifact'
    'File'
  ]
  ```

### Parameter: `bigDataPools.sparkConfigProperties.content`

The configuration content.

- Required: Yes
- Type: string

### Parameter: `bigDataPools.sparkConfigProperties.filename`

The configuration filename.

- Required: Yes
- Type: string

### Parameter: `bigDataPools.sparkEventsFolder`

The Spark events folder.

- Required: No
- Type: string

### Parameter: `bigDataPools.sparkVersion`

The Spark version.

- Required: No
- Type: string

### Parameter: `bigDataPools.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `customerManagedKey`

The customer managed key definition.

- Required: No
- Type: object

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

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, the deployment will use the latest version available at deployment time.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `defaultDataLakeStorageCreateManagedPrivateEndpoint`

Create managed private endpoint to the default storage account or not. If Yes is selected, a managed private endpoint connection request is sent to the workspace's primary Data Lake Storage Gen2 account for Spark pools to access data. This must be approved by an owner of the storage account.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

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

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

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

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `encryptionActivateWorkspace`

Activate workspace by adding the system managed identity in the KeyVault containing the customer managed key and activating the workspace.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `firewallRules`

List of firewall rules to be created in the workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endIpAddress`](#parameter-firewallrulesendipaddress) | string | The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. |
| [`name`](#parameter-firewallrulesname) | string | The name of the firewall rule. |
| [`startIpAddress`](#parameter-firewallrulesstartipaddress) | string | The start IP address of the firewall rule. Must be IPv4 format. |

### Parameter: `firewallRules.endIpAddress`

The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress.

- Required: Yes
- Type: string

### Parameter: `firewallRules.name`

The name of the firewall rule.

- Required: Yes
- Type: string

### Parameter: `firewallRules.startIpAddress`

The start IP address of the firewall rule. Must be IPv4 format.

- Required: Yes
- Type: string

### Parameter: `initialWorkspaceAdminObjectID`

AAD object ID of initial workspace admin.

- Required: No
- Type: string
- Default: `''`

### Parameter: `integrationRuntimes`

The Integration Runtimes to create.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `linkedAccessCheckOnTargetResource`

Linked Access Check On Target Resource.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `location`

The geo-location where the resource lives.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

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

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `managedResourceGroupName`

Workspace managed resource group. The resource group name uniquely identifies the resource group within the user subscriptionId. The resource group name must be no longer than 90 characters long, and must be alphanumeric characters (Char.IsLetterOrDigit()) and '-', '_', '(', ')' and'.'. Note that the name cannot end with '.'.

- Required: No
- Type: string
- Default: `''`

### Parameter: `managedVirtualNetwork`

Enable this to ensure that connection from your workspace to your data sources use Azure Private Links. You can create managed private endpoints to your data sources.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `preventDataExfiltration`

Prevent Data Exfiltration.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.

- Required: No
- Type: array

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
| [`resourceGroupResourceId`](#parameter-privateendpointsresourcegroupresourceid) | string | The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `privateEndpoints.service`

The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file" for a Storage Account's Private Endpoints.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

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

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

FQDN that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-privateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `privateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

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

### Parameter: `privateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.location`

The location to deploy the private endpoint to.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

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

### Parameter: `privateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `privateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `privateEndpoints.name`

The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup`

The private DNS zone group to configure for the private endpoint.

- Required: No
- Type: object

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

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS Zone Group config.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `privateEndpoints.resourceGroupResourceId`

The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
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
  - `'Role Based Access Control Administrator'`

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

### Parameter: `privateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

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

### Parameter: `privateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

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

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `publicNetworkAccess`

Enable or Disable public network access to workspace.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `purviewResourceID`

Purview Resource ID.

- Required: No
- Type: string
- Default: `''`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Resource Policy Contributor'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

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

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

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

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

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

### Parameter: `sqlAdministratorLoginPassword`

Password for administrator access to the workspace's SQL pools. If you don't provide a password, one will be automatically generated. You can change the password later.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `sqlPools`

List of SQL Pools to be created in the workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-sqlpoolsname) | string | The name of the SQL Pool. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`collation`](#parameter-sqlpoolscollation) | string | The collation of the SQL pool. |
| [`diagnosticSettings`](#parameter-sqlpoolsdiagnosticsettings) | array | The diagnostic settings of the service. |
| [`lock`](#parameter-sqlpoolslock) | object | The lock settings of the service. |
| [`maxSizeBytes`](#parameter-sqlpoolsmaxsizebytes) | int | The max size of the SQL pool in bytes. |
| [`recoverableDatabaseResourceId`](#parameter-sqlpoolsrecoverabledatabaseresourceid) | string | The recoverable database resource ID to restore from. |
| [`restorePointInTime`](#parameter-sqlpoolsrestorepointintime) | string | The restore point in time to restore from (ISO8601 format). |
| [`roleAssignments`](#parameter-sqlpoolsroleassignments) | array | Array of role assignments to create. |
| [`sku`](#parameter-sqlpoolssku) | string | The performance level of the SQL pool. |
| [`storageAccountType`](#parameter-sqlpoolsstorageaccounttype) | string | The storage account type to use for the SQL pool. |
| [`tags`](#parameter-sqlpoolstags) | object | Tags of the resource. |
| [`transparentDataEncryption`](#parameter-sqlpoolstransparentdataencryption) | string | Enable database transparent data encryption. |

### Parameter: `sqlPools.name`

The name of the SQL Pool.

- Required: Yes
- Type: string

### Parameter: `sqlPools.collation`

The collation of the SQL pool.

- Required: No
- Type: string

### Parameter: `sqlPools.diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-sqlpoolsdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-sqlpoolsdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-sqlpoolsdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-sqlpoolsdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-sqlpoolsdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-sqlpoolsdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-sqlpoolsdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-sqlpoolsdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-sqlpoolsdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `sqlPools.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `sqlPools.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `sqlPools.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `sqlPools.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-sqlpoolsdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-sqlpoolsdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-sqlpoolsdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `sqlPools.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `sqlPools.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `sqlPools.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `sqlPools.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `sqlPools.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-sqlpoolsdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-sqlpoolsdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `sqlPools.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `sqlPools.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `sqlPools.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `sqlPools.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `sqlPools.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `sqlPools.lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-sqlpoolslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-sqlpoolslockname) | string | Specify the name of lock. |

### Parameter: `sqlPools.lock.kind`

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

### Parameter: `sqlPools.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `sqlPools.maxSizeBytes`

The max size of the SQL pool in bytes.

- Required: No
- Type: int

### Parameter: `sqlPools.recoverableDatabaseResourceId`

The recoverable database resource ID to restore from.

- Required: No
- Type: string

### Parameter: `sqlPools.restorePointInTime`

The restore point in time to restore from (ISO8601 format).

- Required: No
- Type: string

### Parameter: `sqlPools.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-sqlpoolsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-sqlpoolsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-sqlpoolsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-sqlpoolsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-sqlpoolsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-sqlpoolsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-sqlpoolsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-sqlpoolsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `sqlPools.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `sqlPools.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `sqlPools.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `sqlPools.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `sqlPools.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `sqlPools.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `sqlPools.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `sqlPools.roleAssignments.principalType`

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

### Parameter: `sqlPools.sku`

The performance level of the SQL pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'DW10000c'
    'DW1000c'
    'DW100c'
    'DW15000c'
    'DW1500c'
    'DW2000c'
    'DW200c'
    'DW2500c'
    'DW30000c'
    'DW3000c'
    'DW300c'
    'DW400c'
    'DW5000c'
    'DW500c'
    'DW6000c'
    'DW7500c'
  ]
  ```

### Parameter: `sqlPools.storageAccountType`

The storage account type to use for the SQL pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'GRS'
    'LRS'
    'ZRS'
  ]
  ```

### Parameter: `sqlPools.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `sqlPools.transparentDataEncryption`

Enable database transparent data encryption.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `workspaceRepositoryConfiguration`

Git integration settings.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `connectivityEndpoints` | object | The workspace connectivity endpoints. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed Synapse Workspace. |
| `privateEndpoints` | array | The private endpoints of the Synapse Workspace. |
| `resourceGroupName` | string | The resource group of the deployed Synapse Workspace. |
| `resourceID` | string | The resource ID of the deployed Synapse Workspace. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.11.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

# App Service Plan `[Microsoft.Web/serverfarms]`

This module deploys an App Service Plan.

You can reference the module as follows:
```bicep
module serverfarm 'br/public:avm/res/web/serverfarm:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Web/serverfarms` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_serverfarms.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/serverfarms)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/web/serverfarm:<version>`.

- [Using default parameter set](#example-1-using-default-parameter-set)
- [Flexible Consumption](#example-2-flexible-consumption)
- [Linux App Service Plan](#example-3-linux-app-service-plan)
- [Windows Managed Instance App Service Plan](#example-4-windows-managed-instance-app-service-plan)
- [Using large parameter set](#example-5-using-large-parameter-set)
- [WAF-aligned](#example-6-waf-aligned)
- [Windows Container App Service Plan](#example-7-windows-container-app-service-plan)

### Example 1: _Using default parameter set_

This instance deploys the module with a base set of parameters. Note it does include the use of Availability zones by default.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module serverfarm 'br/public:avm/res/web/serverfarm:<version>' = {
  params: {
    name: 'wsfmin001'
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
    "name": {
      "value": "wsfmin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/web/serverfarm:<version>'

param name = 'wsfmin001'
```

</details>
<p>

### Example 2: _Flexible Consumption_

This instance deploys the module in a flexible consumption app service plan.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/flexible-consumption]


<details>

<summary>via Bicep module</summary>

```bicep
module serverfarm 'br/public:avm/res/web/serverfarm:<version>' = {
  params: {
    // Required parameters
    name: 'wsffcp001'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSettingwsffcp'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    reserved: true
    skuName: 'FC1'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    zoneRedundant: false
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
      "value": "wsffcp001"
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSettingwsffcp",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "reserved": {
      "value": true
    },
    "skuName": {
      "value": "FC1"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "zoneRedundant": {
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
using 'br/public:avm/res/web/serverfarm:<version>'

// Required parameters
param name = 'wsffcp001'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSettingwsffcp'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param reserved = true
param skuName = 'FC1'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param zoneRedundant = false
```

</details>
<p>

### Example 3: _Linux App Service Plan_

This instance deploys a Linux App Service Plan.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/linux]


<details>

<summary>via Bicep module</summary>

```bicep
module serverfarm 'br/public:avm/res/web/serverfarm:<version>' = {
  params: {
    // Required parameters
    name: 'wsflnx001'
    // Non-required parameters
    kind: 'linux'
    location: '<location>'
    reserved: true
    skuCapacity: 3
    skuName: 'P1v3'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    zoneRedundant: true
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
      "value": "wsflnx001"
    },
    // Non-required parameters
    "kind": {
      "value": "linux"
    },
    "location": {
      "value": "<location>"
    },
    "reserved": {
      "value": true
    },
    "skuCapacity": {
      "value": 3
    },
    "skuName": {
      "value": "P1v3"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "zoneRedundant": {
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
using 'br/public:avm/res/web/serverfarm:<version>'

// Required parameters
param name = 'wsflnx001'
// Non-required parameters
param kind = 'linux'
param location = '<location>'
param reserved = true
param skuCapacity = 3
param skuName = 'P1v3'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param zoneRedundant = true
```

</details>
<p>

### Example 4: _Windows Managed Instance App Service Plan_

This instance deploys a Windows Managed Instance App Service Plan with install scripts, registry adapters, storage mounts, and RDP enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/managed-instance]


<details>

<summary>via Bicep module</summary>

```bicep
module serverfarm 'br/public:avm/res/web/serverfarm:<version>' = {
  params: {
    // Required parameters
    name: 'wsfmi001'
    // Non-required parameters
    installScripts: [
      {
        name: 'CustomInstaller'
        source: {
          sourceUri: '<sourceUri>'
          type: 'RemoteAzureBlob'
        }
      }
    ]
    isCustomMode: true
    kind: 'app'
    location: '<location>'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    planDefaultIdentity: {
      identityType: 'UserAssigned'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    rdpEnabled: true
    registryAdapters: [
      {
        keyVaultSecretReference: {
          secretUri: '<secretUri>'
        }
        registryKey: 'HKEY_LOCAL_MACHINE/SOFTWARE/MyApp1/RegistryAdapterString'
        type: 'String'
      }
      {
        keyVaultSecretReference: {
          secretUri: '<secretUri>'
        }
        registryKey: 'HKEY_LOCAL_MACHINE/SOFTWARE/MyApp1/RegistryAdapterDWORD'
        type: 'DWORD'
      }
    ]
    skuCapacity: 3
    skuName: 'P1v4'
    storageMounts: [
      {
        destinationPath: 'G:\\'
        name: 'g-drive'
        type: 'LocalStorage'
      }
      {
        credentialsKeyVaultReference: {
          secretUri: '<secretUri>'
        }
        destinationPath: 'H:\\'
        name: 'h-drive'
        source: '<source>'
        type: 'AzureFiles'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    virtualNetworkSubnetId: '<virtualNetworkSubnetId>'
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
      "value": "wsfmi001"
    },
    // Non-required parameters
    "installScripts": {
      "value": [
        {
          "name": "CustomInstaller",
          "source": {
            "sourceUri": "<sourceUri>",
            "type": "RemoteAzureBlob"
          }
        }
      ]
    },
    "isCustomMode": {
      "value": true
    },
    "kind": {
      "value": "app"
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
    "planDefaultIdentity": {
      "value": {
        "identityType": "UserAssigned",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "rdpEnabled": {
      "value": true
    },
    "registryAdapters": {
      "value": [
        {
          "keyVaultSecretReference": {
            "secretUri": "<secretUri>"
          },
          "registryKey": "HKEY_LOCAL_MACHINE/SOFTWARE/MyApp1/RegistryAdapterString",
          "type": "String"
        },
        {
          "keyVaultSecretReference": {
            "secretUri": "<secretUri>"
          },
          "registryKey": "HKEY_LOCAL_MACHINE/SOFTWARE/MyApp1/RegistryAdapterDWORD",
          "type": "DWORD"
        }
      ]
    },
    "skuCapacity": {
      "value": 3
    },
    "skuName": {
      "value": "P1v4"
    },
    "storageMounts": {
      "value": [
        {
          "destinationPath": "G:\\",
          "name": "g-drive",
          "type": "LocalStorage"
        },
        {
          "credentialsKeyVaultReference": {
            "secretUri": "<secretUri>"
          },
          "destinationPath": "H:\\",
          "name": "h-drive",
          "source": "<source>",
          "type": "AzureFiles"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "virtualNetworkSubnetId": {
      "value": "<virtualNetworkSubnetId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/web/serverfarm:<version>'

// Required parameters
param name = 'wsfmi001'
// Non-required parameters
param installScripts = [
  {
    name: 'CustomInstaller'
    source: {
      sourceUri: '<sourceUri>'
      type: 'RemoteAzureBlob'
    }
  }
]
param isCustomMode = true
param kind = 'app'
param location = '<location>'
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param planDefaultIdentity = {
  identityType: 'UserAssigned'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
param rdpEnabled = true
param registryAdapters = [
  {
    keyVaultSecretReference: {
      secretUri: '<secretUri>'
    }
    registryKey: 'HKEY_LOCAL_MACHINE/SOFTWARE/MyApp1/RegistryAdapterString'
    type: 'String'
  }
  {
    keyVaultSecretReference: {
      secretUri: '<secretUri>'
    }
    registryKey: 'HKEY_LOCAL_MACHINE/SOFTWARE/MyApp1/RegistryAdapterDWORD'
    type: 'DWORD'
  }
]
param skuCapacity = 3
param skuName = 'P1v4'
param storageMounts = [
  {
    destinationPath: 'G:\\'
    name: 'g-drive'
    type: 'LocalStorage'
  }
  {
    credentialsKeyVaultReference: {
      secretUri: '<secretUri>'
    }
    destinationPath: 'H:\\'
    name: 'h-drive'
    source: '<source>'
    type: 'AzureFiles'
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param virtualNetworkSubnetId = '<virtualNetworkSubnetId>'
```

</details>
<p>

### Example 5: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module serverfarm 'br/public:avm/res/web/serverfarm:<version>' = {
  params: {
    // Required parameters
    name: 'wsfmax001'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSettingwsfmax'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    kind: 'app'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'lock'
    }
    perSiteScaling: true
    roleAssignments: [
      {
        name: '97fc1da9-bfe4-409d-b17a-da9a82fad0d0'
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
    skuCapacity: 3
    skuName: 'P1v3'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    zoneRedundant: true
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
      "value": "wsfmax001"
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSettingwsfmax",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "kind": {
      "value": "app"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "lock"
      }
    },
    "perSiteScaling": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "name": "97fc1da9-bfe4-409d-b17a-da9a82fad0d0",
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
    "skuCapacity": {
      "value": 3
    },
    "skuName": {
      "value": "P1v3"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "zoneRedundant": {
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
using 'br/public:avm/res/web/serverfarm:<version>'

// Required parameters
param name = 'wsfmax001'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSettingwsfmax'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param kind = 'app'
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'lock'
}
param perSiteScaling = true
param roleAssignments = [
  {
    name: '97fc1da9-bfe4-409d-b17a-da9a82fad0d0'
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
param skuCapacity = 3
param skuName = 'P1v3'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param zoneRedundant = true
```

</details>
<p>

### Example 6: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module serverfarm 'br/public:avm/res/web/serverfarm:<version>' = {
  params: {
    // Required parameters
    name: 'wsfwaf001'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSettingwsfwaf'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    kind: 'app'
    skuCapacity: 3
    skuName: 'P1v3'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    zoneRedundant: true
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
      "value": "wsfwaf001"
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSettingwsfwaf",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "kind": {
      "value": "app"
    },
    "skuCapacity": {
      "value": 3
    },
    "skuName": {
      "value": "P1v3"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "zoneRedundant": {
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
using 'br/public:avm/res/web/serverfarm:<version>'

// Required parameters
param name = 'wsfwaf001'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSettingwsfwaf'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param kind = 'app'
param skuCapacity = 3
param skuName = 'P1v3'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param zoneRedundant = true
```

</details>
<p>

### Example 7: _Windows Container App Service Plan_

This instance deploys a Windows Container (Hyper-V) App Service Plan.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/windows-container]


<details>

<summary>via Bicep module</summary>

```bicep
module serverfarm 'br/public:avm/res/web/serverfarm:<version>' = {
  params: {
    // Required parameters
    name: 'wsfwcn001'
    // Non-required parameters
    hyperV: true
    kind: 'xenon'
    location: '<location>'
    skuCapacity: 3
    skuName: 'P1v3'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    zoneRedundant: true
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
      "value": "wsfwcn001"
    },
    // Non-required parameters
    "hyperV": {
      "value": true
    },
    "kind": {
      "value": "xenon"
    },
    "location": {
      "value": "<location>"
    },
    "skuCapacity": {
      "value": 3
    },
    "skuName": {
      "value": "P1v3"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "zoneRedundant": {
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
using 'br/public:avm/res/web/serverfarm:<version>'

// Required parameters
param name = 'wsfwcn001'
// Non-required parameters
param hyperV = true
param kind = 'xenon'
param location = '<location>'
param skuCapacity = 3
param skuName = 'P1v3'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param zoneRedundant = true
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the app service plan. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`reserved`](#parameter-reserved) | bool | Defaults to false when creating Windows/app App Service Plan. Required if creating a Linux App Service Plan and must be set to true. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appServiceEnvironmentResourceId`](#parameter-appserviceenvironmentresourceid) | string | The Resource ID of the App Service Environment to use for the App Service Plan. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`elasticScaleEnabled`](#parameter-elasticscaleenabled) | bool | Enable/Disable ElasticScaleEnabled App Service Plan. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`hyperV`](#parameter-hyperv) | bool | If Hyper-V container app service plan true, false otherwise. |
| [`installScripts`](#parameter-installscripts) | array | A list of install scripts for Managed Instance plans. Only applicable when isCustomMode is true. |
| [`isCustomMode`](#parameter-iscustommode) | bool | Set to true to enable Managed Instance custom mode. Required for App Service Managed Instance plans. |
| [`kind`](#parameter-kind) | string | Kind of server OS. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`maximumElasticWorkerCount`](#parameter-maximumelasticworkercount) | int | Maximum number of total workers allowed for this ElasticScaleEnabled App Service Plan. |
| [`perSiteScaling`](#parameter-persitescaling) | bool | If true, apps assigned to this App Service plan can be scaled independently. If false, apps assigned to this App Service plan will scale to all instances of the plan. |
| [`planDefaultIdentity`](#parameter-plandefaultidentity) | object | The default identity configuration for Managed Instance plans. Only applicable when isCustomMode is true. |
| [`rdpEnabled`](#parameter-rdpenabled) | bool | Whether RDP is enabled for Managed Instance plans. Only applicable when isCustomMode is true. Requires a Bastion host deployed in the VNet. |
| [`registryAdapters`](#parameter-registryadapters) | array | A list of registry adapters for Managed Instance plans. Only applicable when isCustomMode is true. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`skuCapacity`](#parameter-skucapacity) | int | Number of workers associated with the App Service Plan. This defaults to 3, to leverage availability zones. |
| [`skuName`](#parameter-skuname) | string | The name of the SKU will Determine the tier, size, family of the App Service Plan. This defaults to P1v3 to leverage availability zones. |
| [`storageMounts`](#parameter-storagemounts) | array | A list of storage mounts for Managed Instance plans. Only applicable when isCustomMode is true. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`targetWorkerCount`](#parameter-targetworkercount) | int | Scaling worker count. |
| [`targetWorkerSize`](#parameter-targetworkersize) | int | The instance size of the hosting plan (small, medium, or large). |
| [`virtualNetworkSubnetId`](#parameter-virtualnetworksubnetid) | string | The resource ID of the subnet to integrate the App Service Plan with for VNet integration. |
| [`workerTierName`](#parameter-workertiername) | string | Target worker tier assigned to the App Service plan. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Zone Redundant server farms can only be used on Premium or ElasticPremium SKU tiers within ZRS Supported regions (https://learn.microsoft.com/en-us/azure/storage/common/redundancy-regions-zrs). |

### Parameter: `name`

Name of the app service plan.

- Required: Yes
- Type: string

### Parameter: `reserved`

Defaults to false when creating Windows/app App Service Plan. Required if creating a Linux App Service Plan and must be set to true.

- Required: No
- Type: bool
- Default: `[equals(parameters('kind'), 'linux')]`

### Parameter: `appServiceEnvironmentResourceId`

The Resource ID of the App Service Environment to use for the App Service Plan.

- Required: No
- Type: string

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
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
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

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

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

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

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

### Parameter: `elasticScaleEnabled`

Enable/Disable ElasticScaleEnabled App Service Plan.

- Required: No
- Type: bool
- Default: `[greater(parameters('maximumElasticWorkerCount'), 1)]`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `hyperV`

If Hyper-V container app service plan true, false otherwise.

- Required: No
- Type: bool

### Parameter: `installScripts`

A list of install scripts for Managed Instance plans. Only applicable when isCustomMode is true.

- Required: No
- Type: array

### Parameter: `isCustomMode`

Set to true to enable Managed Instance custom mode. Required for App Service Managed Instance plans.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `kind`

Kind of server OS.

- Required: No
- Type: string
- Default: `'app'`

### Parameter: `location`

Location for all resources.

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
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

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

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `maximumElasticWorkerCount`

Maximum number of total workers allowed for this ElasticScaleEnabled App Service Plan.

- Required: No
- Type: int
- Default: `1`

### Parameter: `perSiteScaling`

If true, apps assigned to this App Service plan can be scaled independently. If false, apps assigned to this App Service plan will scale to all instances of the plan.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `planDefaultIdentity`

The default identity configuration for Managed Instance plans. Only applicable when isCustomMode is true.

- Required: No
- Type: object

### Parameter: `rdpEnabled`

Whether RDP is enabled for Managed Instance plans. Only applicable when isCustomMode is true. Requires a Bastion host deployed in the VNet.

- Required: No
- Type: bool

### Parameter: `registryAdapters`

A list of registry adapters for Managed Instance plans. Only applicable when isCustomMode is true.

- Required: No
- Type: array

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`
  - `'Web Plan Contributor'`
  - `'Website Contributor'`

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

### Parameter: `skuCapacity`

Number of workers associated with the App Service Plan. This defaults to 3, to leverage availability zones.

- Required: No
- Type: int
- Default: `3`

### Parameter: `skuName`

The name of the SKU will Determine the tier, size, family of the App Service Plan. This defaults to P1v3 to leverage availability zones.

- Required: No
- Type: string
- Default: `'P1v3'`
- Example:
  ```Bicep
  'F1'
  'B1'
  'P1v3'
  'I1v2'
  'FC1'
  ```

### Parameter: `storageMounts`

A list of storage mounts for Managed Instance plans. Only applicable when isCustomMode is true.

- Required: No
- Type: array

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `targetWorkerCount`

Scaling worker count.

- Required: No
- Type: int
- Default: `0`

### Parameter: `targetWorkerSize`

The instance size of the hosting plan (small, medium, or large).

- Required: No
- Type: int
- Default: `0`
- Allowed:
  ```Bicep
  [
    0
    1
    2
  ]
  ```

### Parameter: `virtualNetworkSubnetId`

The resource ID of the subnet to integrate the App Service Plan with for VNet integration.

- Required: No
- Type: string

### Parameter: `workerTierName`

Target worker tier assigned to the App Service plan.

- Required: No
- Type: string

### Parameter: `zoneRedundant`

Zone Redundant server farms can only be used on Premium or ElasticPremium SKU tiers within ZRS Supported regions (https://learn.microsoft.com/en-us/azure/storage/common/redundancy-regions-zrs).

- Required: No
- Type: bool
- Default: `[if(or(startsWith(parameters('skuName'), 'P'), startsWith(parameters('skuName'), 'EP')), true(), false())]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the app service plan. |
| `resourceGroupName` | string | The resource group the app service plan was deployed into. |
| `resourceId` | string | The resource ID of the app service plan. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

# AI Platform Baseline `[AiPlatform/Baseline]`

This module provides a secure and scalable environment for deploying AI applications on Azure.
The module encompasses all essential components required for building, managing, and observing AI solutions, including a machine learning workspace, observability tools, and necessary data management services.
By integrating with Microsoft Entra ID for secure identity management and utilizing private endpoints for services like Key Vault and Blob Storage, the module ensures secure communication and data access.

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
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/replications) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/webhooks) |
| `Microsoft.Insights/components` | [2020-02-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components) |
| `microsoft.insights/components/linkedStorageAccounts` | [2020-03-01-preview](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets) |
| `Microsoft.MachineLearningServices/workspaces` | [2024-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-04-01-preview/workspaces) |
| `Microsoft.MachineLearningServices/workspaces/computes` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2022-10-01/workspaces/computes) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.OperationalInsights/workspaces` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces) |
| `Microsoft.Storage/storageAccounts` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/tableServices/tables) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/ai-platform/baseline:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module baseline 'br/public:avm/ptn/ai-platform/baseline:<version>' = {
  name: 'baselineDeployment'
  params: {
    name: '<name>'
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
    "name": {
      "value": "<name>"
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module baseline 'br/public:avm/ptn/ai-platform/baseline:<version>' = {
  name: 'baselineDeployment'
  params: {
    // Required parameters
    name: 'aipbmax'
    // Non-required parameters
    applicationInsightsSettings: {
      name: 'appi-aipbmax'
    }
    containerRegistrySettings: {
      name: 'craipbmax'
      trustPolicyStatus: 'disabled'
    }
    keyVaultSettings: {
      enablePurgeProtection: false
      name: '<name>'
    }
    logAnalyticsSettings: {
      name: 'log-aipbmax'
    }
    managedIdentitySettings: {
      name: 'id-aipbmax'
    }
    storageAccountSettings: {
      allowSharedKeyAccess: true
      name: 'staipbmax'
      sku: 'Standard_GRS'
    }
    workspaceHubSettings: {
      computes: [
        {
          computeType: 'ComputeInstance'
          description: 'Default'
          location: '<location>'
          name: '<name>'
          properties: {
            vmSize: 'STANDARD_DS11_V2'
          }
          sku: 'Standard'
        }
      ]
      name: 'hub-aipbmax'
      networkIsolationMode: 'AllowOnlyApprovedOutbound'
      networkOutboundRules: {
        rule1: {
          category: 'UserDefined'
          destination: 'pypi.org'
          type: 'FQDN'
        }
      }
    }
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
    // Required parameters
    "name": {
      "value": "aipbmax"
    },
    // Non-required parameters
    "applicationInsightsSettings": {
      "value": {
        "name": "appi-aipbmax"
      }
    },
    "containerRegistrySettings": {
      "value": {
        "name": "craipbmax",
        "trustPolicyStatus": "disabled"
      }
    },
    "keyVaultSettings": {
      "value": {
        "enablePurgeProtection": false,
        "name": "<name>"
      }
    },
    "logAnalyticsSettings": {
      "value": {
        "name": "log-aipbmax"
      }
    },
    "managedIdentitySettings": {
      "value": {
        "name": "id-aipbmax"
      }
    },
    "storageAccountSettings": {
      "value": {
        "allowSharedKeyAccess": true,
        "name": "staipbmax",
        "sku": "Standard_GRS"
      }
    },
    "workspaceHubSettings": {
      "value": {
        "computes": [
          {
            "computeType": "ComputeInstance",
            "description": "Default",
            "location": "<location>",
            "name": "<name>",
            "properties": {
              "vmSize": "STANDARD_DS11_V2"
            },
            "sku": "Standard"
          }
        ],
        "name": "hub-aipbmax",
        "networkIsolationMode": "AllowOnlyApprovedOutbound",
        "networkOutboundRules": {
          "rule1": {
            "category": "UserDefined",
            "destination": "pypi.org",
            "type": "FQDN"
          }
        }
      }
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module baseline 'br/public:avm/ptn/ai-platform/baseline:<version>' = {
  name: 'baselineDeployment'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    workspaceHubSettings: {
      networkIsolationMode: 'AllowOnlyApprovedOutbound'
      networkOutboundRules: {
        rule: {
          category: 'UserDefined'
          destination: {
            serviceResourceId: '<serviceResourceId>'
            subresourceTarget: 'blob'
          }
          type: 'PrivateEndpoint'
        }
      }
    }
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
    // Required parameters
    "name": {
      "value": "<name>"
    },
    // Non-required parameters
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "workspaceHubSettings": {
      "value": {
        "networkIsolationMode": "AllowOnlyApprovedOutbound",
        "networkOutboundRules": {
          "rule": {
            "category": "UserDefined",
            "destination": {
              "serviceResourceId": "<serviceResourceId>",
              "subresourceTarget": "blob"
            },
            "type": "PrivateEndpoint"
          }
        }
      }
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Alphanumberic suffix to use for resource naming. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationInsightsSettings`](#parameter-applicationinsightssettings) | object | Settings for Application Insights. |
| [`containerRegistrySettings`](#parameter-containerregistrysettings) | object | Settings for the container registry. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`keyVaultSettings`](#parameter-keyvaultsettings) | object | Settings for the key vault. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`logAnalyticsSettings`](#parameter-loganalyticssettings) | object | Settings for the Log Analytics workspace. |
| [`managedIdentitySettings`](#parameter-managedidentitysettings) | object | Settings for the user-assigned managed identity. |
| [`storageAccountSettings`](#parameter-storageaccountsettings) | object | Settings for the storage account. |
| [`tags`](#parameter-tags) | object | Resource tags. |
| [`workspaceHubSettings`](#parameter-workspacehubsettings) | object | Settings for the AI Studio workspace hub. |

### Parameter: `name`

Alphanumberic suffix to use for resource naming.

- Required: Yes
- Type: string

### Parameter: `applicationInsightsSettings`

Settings for Application Insights.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-applicationinsightssettingsname) | string | The name of the Application Insights resource. |

### Parameter: `applicationInsightsSettings.name`

The name of the Application Insights resource.

- Required: No
- Type: string

### Parameter: `containerRegistrySettings`

Settings for the container registry.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-containerregistrysettingsname) | string | The name of the container registry. |
| [`trustPolicyStatus`](#parameter-containerregistrysettingstrustpolicystatus) | string | Whether the trust policy is enabled for the container registry. Defaults to 'enabled'. |

### Parameter: `containerRegistrySettings.name`

The name of the container registry.

- Required: No
- Type: string

### Parameter: `containerRegistrySettings.trustPolicyStatus`

Whether the trust policy is enabled for the container registry. Defaults to 'enabled'.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'disabled'
    'enabled'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `keyVaultSettings`

Settings for the key vault.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enablePurgeProtection`](#parameter-keyvaultsettingsenablepurgeprotection) | bool | Provide 'true' to enable Key Vault's purge protection feature. Defaults to 'true'. |
| [`name`](#parameter-keyvaultsettingsname) | string | The name of the key vault. |

### Parameter: `keyVaultSettings.enablePurgeProtection`

Provide 'true' to enable Key Vault's purge protection feature. Defaults to 'true'.

- Required: No
- Type: bool

### Parameter: `keyVaultSettings.name`

The name of the key vault.

- Required: No
- Type: string

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `logAnalyticsSettings`

Settings for the Log Analytics workspace.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-loganalyticssettingsname) | string | The name of the Log Analytics workspace. |

### Parameter: `logAnalyticsSettings.name`

The name of the Log Analytics workspace.

- Required: No
- Type: string

### Parameter: `managedIdentitySettings`

Settings for the user-assigned managed identity.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-managedidentitysettingsname) | string | The name of the user-assigned managed identity. |

### Parameter: `managedIdentitySettings.name`

The name of the user-assigned managed identity.

- Required: No
- Type: string

### Parameter: `storageAccountSettings`

Settings for the storage account.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowSharedKeyAccess`](#parameter-storageaccountsettingsallowsharedkeyaccess) | bool | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Microsoft Entra ID. Defaults to 'false'. |
| [`name`](#parameter-storageaccountsettingsname) | string | The name of the storage account. |
| [`sku`](#parameter-storageaccountsettingssku) | string | Storage account SKU. Defaults to 'Standard_RAGZRS'. |

### Parameter: `storageAccountSettings.allowSharedKeyAccess`

Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Microsoft Entra ID. Defaults to 'false'.

- Required: No
- Type: bool

### Parameter: `storageAccountSettings.name`

The name of the storage account.

- Required: No
- Type: string

### Parameter: `storageAccountSettings.sku`

Storage account SKU. Defaults to 'Standard_RAGZRS'.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
    'Standard_GRS'
    'Standard_GZRS'
    'Standard_LRS'
    'Standard_RAGRS'
    'Standard_RAGZRS'
    'Standard_ZRS'
  ]
  ```

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `workspaceHubSettings`

Settings for the AI Studio workspace hub.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`computes`](#parameter-workspacehubsettingscomputes) | array | Computes to create and attach to the workspace hub. |
| [`name`](#parameter-workspacehubsettingsname) | string | The name of the AI Studio workspace hub. |
| [`networkIsolationMode`](#parameter-workspacehubsettingsnetworkisolationmode) | string | The network isolation mode of the workspace hub. Defaults to 'AllowInternetOutbound'. |
| [`networkOutboundRules`](#parameter-workspacehubsettingsnetworkoutboundrules) | object | The outbound rules for the managed network of the workspace hub. |

### Parameter: `workspaceHubSettings.computes`

Computes to create and attach to the workspace hub.

- Required: No
- Type: array

### Parameter: `workspaceHubSettings.name`

The name of the AI Studio workspace hub.

- Required: No
- Type: string

### Parameter: `workspaceHubSettings.networkIsolationMode`

The network isolation mode of the workspace hub. Defaults to 'AllowInternetOutbound'.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AllowInternetOutbound'
    'AllowOnlyApprovedOutbound'
  ]
  ```

### Parameter: `workspaceHubSettings.networkOutboundRules`

The outbound rules for the managed network of the workspace hub.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-workspacehubsettingsnetworkoutboundrules>any_other_property<) | object | The outbound rule. The name of the rule is the object key. |

### Parameter: `workspaceHubSettings.networkOutboundRules.>Any_other_property<`

The outbound rule. The name of the rule is the object key.

- Required: Yes
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `applicationInsightsApplicationId` | string | The application ID of the application insights component. |
| `applicationInsightsConnectionString` | string | The connection string of the application insights component. |
| `applicationInsightsInstrumentationKey` | string | The instrumentation key of the application insights component. |
| `applicationInsightsName` | string | The name of the application insights component. |
| `applicationInsightsResourceId` | string | The resource ID of the application insights component. |
| `containerRegistryName` | string | The name of the container registry. |
| `containerRegistryResourceId` | string | The resource ID of the container registry. |
| `keyVaultName` | string | The name of the key vault. |
| `keyVaultResourceId` | string | The resource ID of the key vault. |
| `keyVaultUri` | string | The URI of the key vault. |
| `location` | string | The location the module was deployed to. |
| `logAnalyticsWorkspaceName` | string | The name of the log analytics workspace. |
| `logAnalyticsWorkspaceResourceId` | string | The resource ID of the log analytics workspace. |
| `managedIdentityClientId` | string | The client ID of the user assigned managed identity. |
| `managedIdentityName` | string | The name of the user assigned managed identity. |
| `managedIdentityPrincipalId` | string | The principal ID of the user assigned managed identity. |
| `managedIdentityResourceId` | string | The resource ID of the user assigned managed identity. |
| `resourceGroupName` | string | The name of the resource group the module was deployed to. |
| `storageAccountName` | string | The name of the storage account. |
| `storageAccountResourceId` | string | The resource ID of the storage account. |
| `workspaceHubName` | string | The name of the workspace hub. |
| `workspaceHubResourceId` | string | The resource ID of the workspace hub. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/container-registry/registry:0.3.1` | Remote reference |
| `br/public:avm/res/insights/component:0.3.1` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.6.2` | Remote reference |
| `br/public:avm/res/machine-learning-services/workspace:0.4.0` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.11.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

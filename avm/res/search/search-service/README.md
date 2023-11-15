# Search Services `[Microsoft.Search/searchServices]`

This module deploys a Search Service.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Search/searchServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2022-09-01/searchServices) |
| `Microsoft.Search/searchServices/sharedPrivateLinkResources` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2022-09-01/searchServices/sharedPrivateLinkResources) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/search.search-service:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [Pe](#example-3-pe)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module searchService 'br:bicep/modules/search.search-service:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-sssmin'
  params: {
    // Required parameters
    name: 'sssmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
      "value": "sssmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
module searchService 'br:bicep/modules/search.search-service:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-sssmax'
  params: {
    // Required parameters
    name: 'sssmax001'
    // Non-required parameters
    authOptions: {
      aadOrApiKey: {
        aadAuthFailureMode: 'http401WithBearerChallenge'
      }
    }
    cmkEnforcement: 'Enabled'
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
    disableLocalAuth: false
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    hostingMode: 'highDensity'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
    }
    networkRuleSet: {
      ipRules: [
        {
          value: '40.74.28.0/23'
        }
        {
          value: '87.147.204.13'
        }
      ]
    }
    partitionCount: 2
    replicaCount: 3
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Search Service Contributor'
      }
    ]
    sku: 'standard3'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "sssmax001"
    },
    // Non-required parameters
    "authOptions": {
      "value": {
        "aadOrApiKey": {
          "aadAuthFailureMode": "http401WithBearerChallenge"
        }
      }
    },
    "cmkEnforcement": {
      "value": "Enabled"
    },
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
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "disableLocalAuth": {
      "value": false
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "hostingMode": {
      "value": "highDensity"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "networkRuleSet": {
      "value": {
        "ipRules": [
          {
            "value": "40.74.28.0/23"
          },
          {
            "value": "87.147.204.13"
          }
        ]
      }
    },
    "partitionCount": {
      "value": 2
    },
    "replicaCount": {
      "value": 3
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Search Service Contributor"
        }
      ]
    },
    "sku": {
      "value": "standard3"
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

### Example 3: _Pe_

<details>

<summary>via Bicep module</summary>

```bicep
module searchService 'br:bicep/modules/search.search-service:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ssspe'
  params: {
    // Required parameters
    name: 'ssspe001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    privateEndpoints: [
      {
        applicationSecurityGroupResourceIds: [
          '<applicationSecurityGroupResourceId>'
        ]
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    publicNetworkAccess: 'disabled'
    sharedPrivateLinkResources: [
      {
        groupId: 'blob'
        privateLinkResourceId: '<privateLinkResourceId>'
        requestMessage: 'Please approve this request'
        resourceRegion: '<resourceRegion>'
      }
      {
        groupId: 'vault'
        privateLinkResourceId: '<privateLinkResourceId>'
        requestMessage: 'Please approve this request'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "ssspe001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "privateEndpoints": {
      "value": [
        {
          "applicationSecurityGroupResourceIds": [
            "<applicationSecurityGroupResourceId>"
          ],
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "publicNetworkAccess": {
      "value": "disabled"
    },
    "sharedPrivateLinkResources": {
      "value": [
        {
          "groupId": "blob",
          "privateLinkResourceId": "<privateLinkResourceId>",
          "requestMessage": "Please approve this request",
          "resourceRegion": "<resourceRegion>"
        },
        {
          "groupId": "vault",
          "privateLinkResourceId": "<privateLinkResourceId>",
          "requestMessage": "Please approve this request"
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

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module searchService 'br:bicep/modules/search.search-service:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ssswaf'
  params: {
    // Required parameters
    name: 'ssswaf001'
    // Non-required parameters
    authOptions: {
      aadOrApiKey: {
        aadAuthFailureMode: 'http401WithBearerChallenge'
      }
    }
    cmkEnforcement: 'Enabled'
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
    disableLocalAuth: false
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    hostingMode: 'highDensity'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
    }
    networkRuleSet: {
      ipRules: [
        {
          value: '40.74.28.0/23'
        }
        {
          value: '87.147.204.13'
        }
      ]
    }
    partitionCount: 2
    replicaCount: 3
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Search Service Contributor'
      }
    ]
    sku: 'standard3'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "ssswaf001"
    },
    // Non-required parameters
    "authOptions": {
      "value": {
        "aadOrApiKey": {
          "aadAuthFailureMode": "http401WithBearerChallenge"
        }
      }
    },
    "cmkEnforcement": {
      "value": "Enabled"
    },
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
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "disableLocalAuth": {
      "value": false
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "hostingMode": {
      "value": "highDensity"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "networkRuleSet": {
      "value": {
        "ipRules": [
          {
            "value": "40.74.28.0/23"
          },
          {
            "value": "87.147.204.13"
          }
        ]
      }
    },
    "partitionCount": {
      "value": 2
    },
    "replicaCount": {
      "value": 3
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Search Service Contributor"
        }
      ]
    },
    "sku": {
      "value": "standard3"
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Azure Cognitive Search service to create or update. Search service names must only contain lowercase letters, digits or dashes, cannot use dash as the first two or last one characters, cannot contain consecutive dashes, and must be between 2 and 60 characters in length. Search service names must be globally unique since they are part of the service URI (https://<name>.search.windows.net). You cannot change the service name after the service is created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authOptions`](#parameter-authoptions) | object | Defines the options for how the data plane API of a Search service authenticates requests. Must remain an empty object {} if 'disableLocalAuth' is set to true. |
| [`cmkEnforcement`](#parameter-cmkenforcement) | string | Describes a policy that determines how resources within the search service are to be encrypted with Customer Managed Keys. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`disableLocalAuth`](#parameter-disablelocalauth) | bool | When set to true, calls to the search service will not be permitted to utilize API keys for authentication. This cannot be set to true if 'authOptions' are defined. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| [`hostingMode`](#parameter-hostingmode) | string | Applicable only for the standard3 SKU. You can set this property to enable up to 3 high density partitions that allow up to 1000 indexes, which is much higher than the maximum indexes allowed for any other SKU. For the standard3 SKU, the value is either 'default' or 'highDensity'. For all other SKUs, this value must be 'default'. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`networkRuleSet`](#parameter-networkruleset) | object | Network specific rules that determine how the Azure Cognitive Search service may be reached. |
| [`partitionCount`](#parameter-partitioncount) | int | The number of partitions in the search service; if specified, it can be 1, 2, 3, 4, 6, or 12. Values greater than 1 are only valid for standard SKUs. For 'standard3' services with hostingMode set to 'highDensity', the allowed values are between 1 and 3. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | This value can be set to 'enabled' to avoid breaking changes on existing customer resources and templates. If set to 'disabled', traffic over public interface is not allowed, and private endpoint connections would be the exclusive access method. |
| [`replicaCount`](#parameter-replicacount) | int | The number of replicas in the search service. If specified, it must be a value between 1 and 12 inclusive for standard SKUs or between 1 and 3 inclusive for basic SKU. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`sharedPrivateLinkResources`](#parameter-sharedprivatelinkresources) | array | The sharedPrivateLinkResources to create as part of the search Service. |
| [`sku`](#parameter-sku) | string | Defines the SKU of an Azure Cognitive Search Service, which determines price tier and capacity limits. |
| [`tags`](#parameter-tags) | object | Tags to help categorize the resource in the Azure portal. |

### Parameter: `authOptions`

Defines the options for how the data plane API of a Search service authenticates requests. Must remain an empty object {} if 'disableLocalAuth' is set to true.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `cmkEnforcement`

Describes a policy that determines how resources within the search service are to be encrypted with Customer Managed Keys.
- Required: No
- Type: string
- Default: `'Unspecified'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
    'Unspecified'
  ]
  ```

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | No | string | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | No | string | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | No | string | Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | No | array | Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | No | string | Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | No | array | Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`name`](#parameter-diagnosticsettingsname) | No | string | Optional. The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | No | string | Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | No | string | Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed: `[AzureDiagnostics, Dedicated]`

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | No | string | Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | No | string | Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to 'AllLogs' to collect all logs. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to 'AllLogs' to collect all logs.

- Required: No
- Type: string


### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | Yes | string | Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to 'AllMetrics' to collect all metrics. |

### Parameter: `diagnosticSettings.metricCategories.category`

Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to 'AllMetrics' to collect all metrics.

- Required: Yes
- Type: string


### Parameter: `diagnosticSettings.name`

Optional. The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `disableLocalAuth`

When set to true, calls to the search service will not be permitted to utilize API keys for authentication. This cannot be set to true if 'authOptions' are defined.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via the Customer Usage Attribution ID (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `hostingMode`

Applicable only for the standard3 SKU. You can set this property to enable up to 3 high density partitions that allow up to 1000 indexes, which is much higher than the maximum indexes allowed for any other SKU. For the standard3 SKU, the value is either 'default' or 'highDensity'. For all other SKUs, this value must be 'default'.
- Required: No
- Type: string
- Default: `'default'`
- Allowed:
  ```Bicep
  [
    'default'
    'highDensity'
  ]
  ```

### Parameter: `location`

Location for all Resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`kind`](#parameter-lockkind) | No | string | Optional. Specify the type of lock. |
| [`name`](#parameter-lockname) | No | string | Optional. Specify the name of lock. |

### Parameter: `lock.kind`

Optional. Specify the type of lock.

- Required: No
- Type: string
- Allowed: `[CanNotDelete, None, ReadOnly]`

### Parameter: `lock.name`

Optional. Specify the name of lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | No | bool | Optional. Enables system assigned managed identity on the resource. |

### Parameter: `managedIdentities.systemAssigned`

Optional. Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `name`

The name of the Azure Cognitive Search service to create or update. Search service names must only contain lowercase letters, digits or dashes, cannot use dash as the first two or last one characters, cannot contain consecutive dashes, and must be between 2 and 60 characters in length. Search service names must be globally unique since they are part of the service URI (https://<name>.search.windows.net). You cannot change the service name after the service is created.
- Required: Yes
- Type: string

### Parameter: `networkRuleSet`

Network specific rules that determine how the Azure Cognitive Search service may be reached.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `partitionCount`

The number of partitions in the search service; if specified, it can be 1, 2, 3, 4, 6, or 12. Values greater than 1 are only valid for standard SKUs. For 'standard3' services with hostingMode set to 'highDensity', the allowed values are between 1 and 3.
- Required: No
- Type: int
- Default: `1`

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | No | array | Optional. Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | No | array | Optional. Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | No | string | Optional. The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | No | bool | Optional. Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | No | array | Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`location`](#parameter-privateendpointslocation) | No | string | Optional. The location to deploy the private endpoint to. |
| [`lock`](#parameter-privateendpointslock) | No | object | Optional. Specify the type of lock. |
| [`manualPrivateLinkServiceConnections`](#parameter-privateendpointsmanualprivatelinkserviceconnections) | No | array | Optional. Manual PrivateLink Service Connections. |
| [`name`](#parameter-privateendpointsname) | No | string | Optional. The name of the private endpoint. |
| [`privateDnsZoneGroupName`](#parameter-privateendpointsprivatednszonegroupname) | No | string | Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided. |
| [`privateDnsZoneResourceIds`](#parameter-privateendpointsprivatednszoneresourceids) | No | array | Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | No | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`service`](#parameter-privateendpointsservice) | No | string | Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob". |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | Yes | string | Required. Resource ID of the subnet where the endpoint needs to be created. |
| [`tags`](#parameter-privateendpointstags) | No | object | Optional. Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Optional. Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Optional. Custom DNS configurations.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | No | string | Required. Fqdn that resolves to private endpoint ip address. |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | Yes | array | Required. A list of private ip addresses of the private endpoint. |

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

Required. Fqdn that resolves to private endpoint ip address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

Required. A list of private ip addresses of the private endpoint.

- Required: Yes
- Type: array


### Parameter: `privateEndpoints.customNetworkInterfaceName`

Optional. The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Optional. Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`name`](#parameter-privateendpointsipconfigurationsname) | Yes | string | Required. The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-privateendpointsipconfigurationsproperties) | Yes | object | Required. Properties of private endpoint IP configurations. |

### Parameter: `privateEndpoints.ipConfigurations.name`

Required. The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties`

Required. Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`groupId`](#parameter-privateendpointsipconfigurationspropertiesgroupid) | Yes | string | Required. The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-privateendpointsipconfigurationspropertiesmembername) | Yes | string | Required. The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-privateendpointsipconfigurationspropertiesprivateipaddress) | Yes | string | Required. A private ip address obtained from the private endpoint's subnet. |

### Parameter: `privateEndpoints.ipConfigurations.properties.groupId`

Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.memberName`

Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.privateIPAddress`

Required. A private ip address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string



### Parameter: `privateEndpoints.location`

Optional. The location to deploy the private endpoint to.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock`

Optional. Specify the type of lock.

- Required: No
- Type: object

### Parameter: `privateEndpoints.manualPrivateLinkServiceConnections`

Optional. Manual PrivateLink Service Connections.

- Required: No
- Type: array

### Parameter: `privateEndpoints.name`

Optional. The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroupName`

Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneResourceIds`

Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.

- Required: No
- Type: array

### Parameter: `privateEndpoints.roleAssignments`

Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: No
- Type: array

### Parameter: `privateEndpoints.service`

Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".

- Required: No
- Type: string

### Parameter: `privateEndpoints.subnetResourceId`

Required. Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.tags`

Optional. Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `publicNetworkAccess`

This value can be set to 'enabled' to avoid breaking changes on existing customer resources and templates. If set to 'disabled', traffic over public interface is not allowed, and private endpoint connections would be the exclusive access method.
- Required: No
- Type: string
- Default: `'enabled'`
- Allowed:
  ```Bicep
  [
    'disabled'
    'enabled'
  ]
  ```

### Parameter: `replicaCount`

The number of replicas in the search service. If specified, it must be a value between 1 and 12 inclusive for standard SKUs or between 1 and 3 inclusive for basic SKU.
- Required: No
- Type: int
- Default: `1`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | No | string | Optional. The description of the role assignment. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | Yes | string | Required. The principal ID of the principal (user/group/identity) to assign the role to. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | No | string | Optional. The principal type of the assigned principal ID. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | Yes | string | Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

### Parameter: `roleAssignments.condition`

Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Optional. Version of the condition.

- Required: No
- Type: string
- Allowed: `[2.0]`

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

Optional. The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

Optional. The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalId`

Required. The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

Optional. The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed: `[Device, ForeignGroup, Group, ServicePrincipal, User]`

### Parameter: `roleAssignments.roleDefinitionIdOrName`

Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

### Parameter: `sharedPrivateLinkResources`

The sharedPrivateLinkResources to create as part of the search Service.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `sku`

Defines the SKU of an Azure Cognitive Search Service, which determines price tier and capacity limits.
- Required: No
- Type: string
- Default: `'standard'`
- Allowed:
  ```Bicep
  [
    'basic'
    'free'
    'standard'
    'standard2'
    'standard3'
    'storage_optimized_l1'
    'storage_optimized_l2'
  ]
  ```

### Parameter: `tags`

Tags to help categorize the resource in the Azure portal.
- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the search service. |
| `resourceGroupName` | string | The name of the resource group the search service was created in. |
| `resourceId` | string | The resource ID of the search service. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/private-endpoint` | Local reference |

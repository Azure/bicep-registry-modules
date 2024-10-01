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
| `Microsoft.Kusto/clusters` | [2023-08-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2023-08-15/clusters) |
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
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/kusto/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    name: 'akcmin0001'
    sku: 'Standard_E2ads_v5'
    // Non-required parameters
    location: '<location>'
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
      "value": "akcmin0001"
    },
    "sku": {
      "value": "Standard_E2ads_v5"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
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
module cluster 'br/public:avm/res/kusto/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    name: 'akcmax0001'
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
        principalType: 'Group'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "akcmax0001"
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
          "principalType": "Group",
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

### Example 3: _Private endpoint-enabled deployment_

This instance deploys the module with private endpoints.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/kusto/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    name: 'akcpe0001'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "akcpe0001"
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

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/kusto/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    name: 'akcwaf0001'
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
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "akcwaf0001"
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

**Optional parameters**

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

### Parameter: `autoScaleMin`

When auto-scale is enabled, the minimum number of instances in the Kusto Cluster.

- Required: No
- Type: int
- Default: `2`

### Parameter: `capacity`

The number of instances of the Kusto Cluster.

- Required: No
- Type: int
- Default: `2`

### Parameter: `customerManagedKey`

The customer managed key definition.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-customermanagedkeykeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-customermanagedkeykeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using 'latest'. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, using 'latest'.

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
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
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

### Parameter: `enableAutoScale`

Enable/disable auto-scale.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableAutoStop`

Enable/disable auto-stop.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableDiskEncryption`

Enable/disable disk encryption.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableDoubleEncryption`

Enable/disable double encryption.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePublicNetworkAccess`

Enable/disable public network access. If disabled, only private endpoint connection is allowed to the Kusto Cluster.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enablePurge`

Enable/disable purge.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableRestrictOutboundNetworkAccess`

Enable/disable restricting outbound network access.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableStreamingIngest`

Enable/disable streaming ingest.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableZoneRedundant`

Enable/disable zone redundancy.

- Required: No
- Type: bool
- Default: `False`

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

### Parameter: `languageExtensions`

List of the language extensions of the Kusto Cluster.

- Required: No
- Type: array
- Default: `[]`

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
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource id(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource id(s) to assign to the resource.

- Required: Yes
- Type: array

### Parameter: `principalAssignments`

The Principal Assignments for the Kusto Cluster.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`service`](#parameter-privateendpointsservice) | string | The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file". |
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

The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file".

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
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | string | Fqdn that resolves to private endpoint IP address. |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

Fqdn that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

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
| [`privateDnsZoneGroupConfigs`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS zone group config. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS zone group config.

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

### Parameter: `privateEndpoints.resourceGroupName`

Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.

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

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
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

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

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

### Parameter: `trustedExternalTenants`

The external tenants trusted by the Kusto Cluster.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`value`](#parameter-trustedexternaltenantsvalue) | string | GUID representing an external tenant. |

### Parameter: `trustedExternalTenants.value`

GUID representing an external tenant.

- Required: Yes
- Type: string

### Parameter: `virtualClusterGraduationProperties`

The virtual cluster graduation properties of the Kusto Cluster.

- Required: No
- Type: securestring

### Parameter: `virtualNetworkConfiguration`

The virtual network configuration of the Kusto Cluster.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataManagementPublicIpId`](#parameter-virtualnetworkconfigurationdatamanagementpublicipid) | string | The public IP address resource id of the data management service.. |
| [`enableVirtualNetworkInjection`](#parameter-virtualnetworkconfigurationenablevirtualnetworkinjection) | bool | Enable/disable virtual network injection. When enabled, the Kusto Cluster will be deployed into the specified subnet. When disabled, the Kusto Cluster will be removed from the specified subnet. |
| [`enginePublicIpId`](#parameter-virtualnetworkconfigurationenginepublicipid) | string | The public IP address resource id of the engine service. |
| [`subnetId`](#parameter-virtualnetworkconfigurationsubnetid) | string | The resource ID of the subnet to which to deploy the Kusto Cluster. |

### Parameter: `virtualNetworkConfiguration.dataManagementPublicIpId`

The public IP address resource id of the data management service..

- Required: Yes
- Type: string

### Parameter: `virtualNetworkConfiguration.enableVirtualNetworkInjection`

Enable/disable virtual network injection. When enabled, the Kusto Cluster will be deployed into the specified subnet. When disabled, the Kusto Cluster will be removed from the specified subnet.

- Required: Yes
- Type: bool

### Parameter: `virtualNetworkConfiguration.enginePublicIpId`

The public IP address resource id of the engine service.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkConfiguration.subnetId`

The resource ID of the subnet to which to deploy the Kusto Cluster.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

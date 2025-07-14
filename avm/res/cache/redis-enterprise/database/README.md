# Redis database `[Microsoft.Cache/redisEnterprise/databases]`

This module deploys a Redis database in a Redis Enterprise or Azure Managed Redis cluster.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cache/redisEnterprise/databases` | [2025-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/2025-05-01-preview/redisEnterprise/databases) |
| `Microsoft.Cache/redisEnterprise/databases/accessPolicyAssignments` | [2025-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/2025-05-01-preview/redisEnterprise/databases/accessPolicyAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults/secrets` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`redisClusterName`](#parameter-redisclustername) | string | The name of the parent Redis Enterprise or Azure Managed Redis resource. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessKeysAuthentication`](#parameter-accesskeysauthentication) | string | Allow authentication via access keys. Only supported on Azure Managed Redis SKUs: Balanced, ComputeOptimized, FlashOptimized, and MemoryOptimized. |
| [`accessPolicyAssignments`](#parameter-accesspolicyassignments) | array | Access policy assignments for Microsoft Entra authentication. Only supported on Azure Managed Redis SKUs: Balanced, ComputeOptimized, FlashOptimized, and MemoryOptimized. |
| [`clientProtocol`](#parameter-clientprotocol) | string | Specifies whether Redis clients can connect using TLS-encrypted or plaintext Redis protocols. |
| [`clusteringPolicy`](#parameter-clusteringpolicy) | string | Redis clustering policy. [Learn more](https://learn.microsoft.com/azure/redis/architecture#cluster-policies). |
| [`deferUpgrade`](#parameter-deferupgrade) | string | Specifies whether to defer future Redis major version upgrades by up to 90 days. [Learn more](https://aka.ms/redisversionupgrade#defer-upgrades). |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The database-level diagnostic settings of the service. |
| [`evictionPolicy`](#parameter-evictionpolicy) | string | Specifies the eviction policy for the Redis resource. |
| [`geoReplication`](#parameter-georeplication) | object | The active geo-replication settings of the service. All caches within a geo-replication group must have the same configuration. |
| [`modules`](#parameter-modules) | array | Redis modules to enable. Restrictions may apply based on SKU and configuration. [Learn more](https://aka.ms/redis/enterprise/modules). |
| [`name`](#parameter-name) | string | Name of the database. |
| [`persistence`](#parameter-persistence) | object | The persistence settings of the service. THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/azure/redis/how-to-persistence) FOR CLARIFICATION. |
| [`port`](#parameter-port) | int | TCP port of the database endpoint. |
| [`secretsExportConfiguration`](#parameter-secretsexportconfiguration) | object | Key vault reference and secret settings for the module's secrets export. |

### Parameter: `redisClusterName`

The name of the parent Redis Enterprise or Azure Managed Redis resource. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `accessKeysAuthentication`

Allow authentication via access keys. Only supported on Azure Managed Redis SKUs: Balanced, ComputeOptimized, FlashOptimized, and MemoryOptimized.

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

### Parameter: `accessPolicyAssignments`

Access policy assignments for Microsoft Entra authentication. Only supported on Azure Managed Redis SKUs: Balanced, ComputeOptimized, FlashOptimized, and MemoryOptimized.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userObjectId`](#parameter-accesspolicyassignmentsuserobjectid) | string | Object ID to which the access policy will be assigned. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessPolicyName`](#parameter-accesspolicyassignmentsaccesspolicyname) | string | Name of the access policy to be assigned. The current only allowed name is 'default'. |
| [`name`](#parameter-accesspolicyassignmentsname) | string | Name of the access policy assignment. |

### Parameter: `accessPolicyAssignments.userObjectId`

Object ID to which the access policy will be assigned.

- Required: Yes
- Type: string

### Parameter: `accessPolicyAssignments.accessPolicyName`

Name of the access policy to be assigned. The current only allowed name is 'default'.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'default'
  ]
  ```

### Parameter: `accessPolicyAssignments.name`

Name of the access policy assignment.

- Required: No
- Type: string

### Parameter: `clientProtocol`

Specifies whether Redis clients can connect using TLS-encrypted or plaintext Redis protocols.

- Required: No
- Type: string
- Default: `'Encrypted'`
- Allowed:
  ```Bicep
  [
    'Encrypted'
    'Plaintext'
  ]
  ```

### Parameter: `clusteringPolicy`

Redis clustering policy. [Learn more](https://learn.microsoft.com/azure/redis/architecture#cluster-policies).

- Required: No
- Type: string
- Default: `'OSSCluster'`
- Allowed:
  ```Bicep
  [
    'EnterpriseCluster'
    'NoCluster'
    'OSSCluster'
  ]
  ```

### Parameter: `deferUpgrade`

Specifies whether to defer future Redis major version upgrades by up to 90 days. [Learn more](https://aka.ms/redisversionupgrade#defer-upgrades).

- Required: No
- Type: string
- Default: `'NotDeferred'`
- Allowed:
  ```Bicep
  [
    'Deferred'
    'NotDeferred'
  ]
  ```

### Parameter: `diagnosticSettings`

The database-level diagnostic settings of the service.

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

### Parameter: `evictionPolicy`

Specifies the eviction policy for the Redis resource.

- Required: No
- Type: string
- Default: `'VolatileLRU'`
- Allowed:
  ```Bicep
  [
    'AllKeysLFU'
    'AllKeysLRU'
    'AllKeysRandom'
    'NoEviction'
    'VolatileLFU'
    'VolatileLRU'
    'VolatileRandom'
    'VolatileTTL'
  ]
  ```

### Parameter: `geoReplication`

The active geo-replication settings of the service. All caches within a geo-replication group must have the same configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupNickname`](#parameter-georeplicationgroupnickname) | string | The name of the geo-replication group. |
| [`linkedDatabases`](#parameter-georeplicationlinkeddatabases) | array | List of database resources to link with this database, including itself. |

### Parameter: `geoReplication.groupNickname`

The name of the geo-replication group.

- Required: Yes
- Type: string

### Parameter: `geoReplication.linkedDatabases`

List of database resources to link with this database, including itself.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-georeplicationlinkeddatabasesid) | string | Resource ID of linked database. Should be in the form: `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cache/redisEnterprise/{redisName}/databases/default`. |

### Parameter: `geoReplication.linkedDatabases.id`

Resource ID of linked database. Should be in the form: `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cache/redisEnterprise/{redisName}/databases/default`.

- Required: Yes
- Type: string

### Parameter: `modules`

Redis modules to enable. Restrictions may apply based on SKU and configuration. [Learn more](https://aka.ms/redis/enterprise/modules).

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-modulesname) | string | The name of the module. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`args`](#parameter-modulesargs) | string | Additional module arguments. |

### Parameter: `modules.name`

The name of the module.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'RedisBloom'
    'RediSearch'
    'RedisJSON'
    'RedisTimeSeries'
  ]
  ```

### Parameter: `modules.args`

Additional module arguments.

- Required: No
- Type: string

### Parameter: `name`

Name of the database.

- Required: No
- Type: string
- Default: `'default'`
- Allowed:
  ```Bicep
  [
    'default'
  ]
  ```

### Parameter: `persistence`

The persistence settings of the service. THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/azure/redis/how-to-persistence) FOR CLARIFICATION.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      type: 'disabled'
  }
  ```
- Discriminator: `type`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`disabled`](#variant-persistencetype-disabled) |  |
| [`aof`](#variant-persistencetype-aof) |  |
| [`rdb`](#variant-persistencetype-rdb) |  |

### Variant: `persistence.type-disabled`


To use this variant, set the property `type` to `disabled`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`type`](#parameter-persistencetype-disabledtype) | string | Disabled persistence type. |

### Parameter: `persistence.type-disabled.type`

Disabled persistence type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'disabled'
  ]
  ```

### Variant: `persistence.type-aof`


To use this variant, set the property `type` to `aof`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`frequency`](#parameter-persistencetype-aoffrequency) | string | The frequency at which data is written to disk. |
| [`type`](#parameter-persistencetype-aoftype) | string | AOF persistence type. |

### Parameter: `persistence.type-aof.frequency`

The frequency at which data is written to disk.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    '1s'
  ]
  ```

### Parameter: `persistence.type-aof.type`

AOF persistence type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'aof'
  ]
  ```

### Variant: `persistence.type-rdb`


To use this variant, set the property `type` to `rdb`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`frequency`](#parameter-persistencetype-rdbfrequency) | string | The frequency at which an RDB snapshot of the database is created. |
| [`type`](#parameter-persistencetype-rdbtype) | string | RDB persistence type. |

### Parameter: `persistence.type-rdb.frequency`

The frequency at which an RDB snapshot of the database is created.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    '12h'
    '1h'
    '6h'
  ]
  ```

### Parameter: `persistence.type-rdb.type`

RDB persistence type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'rdb'
  ]
  ```

### Parameter: `port`

TCP port of the database endpoint.

- Required: No
- Type: int
- Default: `10000`
- MinValue: 10000
- MaxValue: 10000

### Parameter: `secretsExportConfiguration`

Key vault reference and secret settings for the module's secrets export.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultResourceId`](#parameter-secretsexportconfigurationkeyvaultresourceid) | string | The resource ID of the key vault where to store the secrets of this module. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`primaryAccessKeyName`](#parameter-secretsexportconfigurationprimaryaccesskeyname) | string | The primaryAccessKey secret name to create. |
| [`primaryConnectionStringName`](#parameter-secretsexportconfigurationprimaryconnectionstringname) | string | The primaryConnectionString secret name to create. |
| [`primaryStackExchangeRedisConnectionStringName`](#parameter-secretsexportconfigurationprimarystackexchangeredisconnectionstringname) | string | The primaryStackExchangeRedisConnectionString secret name to create. |
| [`secondaryAccessKeyName`](#parameter-secretsexportconfigurationsecondaryaccesskeyname) | string | The secondaryAccessKey secret name to create. |
| [`secondaryConnectionStringName`](#parameter-secretsexportconfigurationsecondaryconnectionstringname) | string | The secondaryConnectionString secret name to create. |
| [`secondaryStackExchangeRedisConnectionStringName`](#parameter-secretsexportconfigurationsecondarystackexchangeredisconnectionstringname) | string | The secondaryStackExchangeRedisConnectionString secret name to create. |

### Parameter: `secretsExportConfiguration.keyVaultResourceId`

The resource ID of the key vault where to store the secrets of this module.

- Required: Yes
- Type: string

### Parameter: `secretsExportConfiguration.primaryAccessKeyName`

The primaryAccessKey secret name to create.

- Required: No
- Type: string

### Parameter: `secretsExportConfiguration.primaryConnectionStringName`

The primaryConnectionString secret name to create.

- Required: No
- Type: string

### Parameter: `secretsExportConfiguration.primaryStackExchangeRedisConnectionStringName`

The primaryStackExchangeRedisConnectionString secret name to create.

- Required: No
- Type: string

### Parameter: `secretsExportConfiguration.secondaryAccessKeyName`

The secondaryAccessKey secret name to create.

- Required: No
- Type: string

### Parameter: `secretsExportConfiguration.secondaryConnectionStringName`

The secondaryConnectionString secret name to create.

- Required: No
- Type: string

### Parameter: `secretsExportConfiguration.secondaryStackExchangeRedisConnectionStringName`

The secondaryStackExchangeRedisConnectionString secret name to create.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `endpoint` | string | The Redis endpoint. |
| `exportedSecrets` |  | A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret's name. |
| `hostname` | string | The Redis host name. |
| `name` | string | The name of the Redis database. |
| `port` | int | The Redis database port. |
| `resourceGroupName` | string | The name of the resource group the Redis resource was created in. |
| `resourceId` | string | The resource ID of the database. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

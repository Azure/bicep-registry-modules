# SQL Server Elastic Pool `[Microsoft.Sql/servers/elasticPools]`

This module deploys an Azure SQL Server Elastic Pool.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/elasticPools` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/elasticPools) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Elastic Pool. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverName`](#parameter-servername) | string | The name of the parent SQL Server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoPauseDelay`](#parameter-autopausedelay) | int | Time in minutes after which elastic pool is automatically paused. A value of -1 means that automatic pause is disabled. |
| [`availabilityZone`](#parameter-availabilityzone) | string | Specifies the availability zone the pool's primary replica is pinned to. |
| [`highAvailabilityReplicaCount`](#parameter-highavailabilityreplicacount) | int | The number of secondary replicas associated with the elastic pool that are used to provide high availability. Applicable only to Hyperscale elastic pools. |
| [`licenseType`](#parameter-licensetype) | string | The license type to apply for this elastic pool. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`maintenanceConfigurationId`](#parameter-maintenanceconfigurationid) | string | Maintenance configuration resource ID assigned to the elastic pool. This configuration defines the period when the maintenance updates will will occur. |
| [`maxSizeBytes`](#parameter-maxsizebytes) | int | The storage limit for the database elastic pool in bytes. |
| [`minCapacity`](#parameter-mincapacity) | int | Minimal capacity that serverless pool will not shrink below, if not paused. |
| [`perDatabaseSettings`](#parameter-perdatabasesettings) | object | The per database settings for the elastic pool. |
| [`preferredEnclaveType`](#parameter-preferredenclavetype) | string | Type of enclave requested on the elastic pool. |
| [`sku`](#parameter-sku) | object | The elastic pool SKU. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Whether or not this elastic pool is zone redundant, which means the replicas of this elastic pool will be spread across multiple availability zones. |

### Parameter: `name`

The name of the Elastic Pool.

- Required: Yes
- Type: string

### Parameter: `serverName`

The name of the parent SQL Server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `autoPauseDelay`

Time in minutes after which elastic pool is automatically paused. A value of -1 means that automatic pause is disabled.

- Required: No
- Type: int
- Default: `-1`

### Parameter: `availabilityZone`

Specifies the availability zone the pool's primary replica is pinned to.

- Required: No
- Type: string
- Default: `'NoPreference'`
- Allowed:
  ```Bicep
  [
    '1'
    '2'
    '3'
    'NoPreference'
  ]
  ```

### Parameter: `highAvailabilityReplicaCount`

The number of secondary replicas associated with the elastic pool that are used to provide high availability. Applicable only to Hyperscale elastic pools.

- Required: No
- Type: int

### Parameter: `licenseType`

The license type to apply for this elastic pool.

- Required: No
- Type: string
- Default: `'LicenseIncluded'`
- Allowed:
  ```Bicep
  [
    'BasePrice'
    'LicenseIncluded'
  ]
  ```

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `maintenanceConfigurationId`

Maintenance configuration resource ID assigned to the elastic pool. This configuration defines the period when the maintenance updates will will occur.

- Required: No
- Type: string

### Parameter: `maxSizeBytes`

The storage limit for the database elastic pool in bytes.

- Required: No
- Type: int
- Default: `34359738368`

### Parameter: `minCapacity`

Minimal capacity that serverless pool will not shrink below, if not paused.

- Required: No
- Type: int

### Parameter: `perDatabaseSettings`

The per database settings for the elastic pool.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      autoPauseDelay: -1
      maxCapacity: '2'
      minCapacity: '0'
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`maxCapacity`](#parameter-perdatabasesettingsmaxcapacity) | string | The maximum capacity any one database can consume. Examples: '0.5', '2'. |
| [`minCapacity`](#parameter-perdatabasesettingsmincapacity) | string | The minimum capacity all databases are guaranteed. Examples: '0.5', '1'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoPauseDelay`](#parameter-perdatabasesettingsautopausedelay) | int | Auto Pause Delay for per database within pool. |

### Parameter: `perDatabaseSettings.maxCapacity`

The maximum capacity any one database can consume. Examples: '0.5', '2'.

- Required: Yes
- Type: string

### Parameter: `perDatabaseSettings.minCapacity`

The minimum capacity all databases are guaranteed. Examples: '0.5', '1'.

- Required: Yes
- Type: string

### Parameter: `perDatabaseSettings.autoPauseDelay`

Auto Pause Delay for per database within pool.

- Required: No
- Type: int

### Parameter: `preferredEnclaveType`

Type of enclave requested on the elastic pool.

- Required: No
- Type: string
- Default: `'Default'`
- Allowed:
  ```Bicep
  [
    'Default'
    'VBS'
  ]
  ```

### Parameter: `sku`

The elastic pool SKU.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      capacity: 2
      name: 'GP_Gen5'
      tier: 'GeneralPurpose'
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-skuname) | string | The name of the SKU, typically, a letter + Number code, e.g. P3. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-skucapacity) | int | The capacity of the particular SKU. |
| [`family`](#parameter-skufamily) | string | If the service has different generations of hardware, for the same SKU, then that can be captured here. |
| [`size`](#parameter-skusize) | string | Size of the particular SKU. |
| [`tier`](#parameter-skutier) | string | The tier or edition of the particular SKU, e.g. Basic, Premium. |

### Parameter: `sku.name`

The name of the SKU, typically, a letter + Number code, e.g. P3.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'BasicPool'
    'BC_DC'
    'BC_Gen5'
    'GP_DC'
    'GP_FSv2'
    'GP_Gen5'
    'HS_Gen5'
    'HS_MOPRMS'
    'HS_PRMS'
    'PremiumPool'
    'ServerlessPool'
    'StandardPool'
  ]
  ```

### Parameter: `sku.capacity`

The capacity of the particular SKU.

- Required: No
- Type: int

### Parameter: `sku.family`

If the service has different generations of hardware, for the same SKU, then that can be captured here.

- Required: No
- Type: string

### Parameter: `sku.size`

Size of the particular SKU.

- Required: No
- Type: string

### Parameter: `sku.tier`

The tier or edition of the particular SKU, e.g. Basic, Premium.

- Required: No
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `zoneRedundant`

Whether or not this elastic pool is zone redundant, which means the replicas of this elastic pool will be spread across multiple availability zones.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed Elastic Pool. |
| `resourceGroupName` | string | The resource group of the deployed Elastic Pool. |
| `resourceId` | string | The resource ID of the deployed Elastic Pool. |

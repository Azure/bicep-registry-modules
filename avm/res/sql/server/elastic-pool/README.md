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
| [`databaseMaxCapacity`](#parameter-databasemaxcapacity) | int | The maximum capacity any one database can consume. |
| [`databaseMinCapacity`](#parameter-databasemincapacity) | int | The minimum capacity all databases are guaranteed. |
| [`highAvailabilityReplicaCount`](#parameter-highavailabilityreplicacount) | int | The number of secondary replicas associated with the elastic pool that are used to provide high availability. Applicable only to Hyperscale elastic pools. |
| [`licenseType`](#parameter-licensetype) | string | The license type to apply for this elastic pool. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`maintenanceConfigurationId`](#parameter-maintenanceconfigurationid) | string | Maintenance configuration resource ID assigned to the elastic pool. This configuration defines the period when the maintenance updates will will occur. |
| [`maxSizeBytes`](#parameter-maxsizebytes) | int | The storage limit for the database elastic pool in bytes. |
| [`minCapacity`](#parameter-mincapacity) | int | Minimal capacity that serverless pool will not shrink below, if not paused. |
| [`skuCapacity`](#parameter-skucapacity) | int | Capacity of the particular SKU. |
| [`skuName`](#parameter-skuname) | string | The name of the SKU, typically, a letter + Number code, e.g. P3. |
| [`skuTier`](#parameter-skutier) | string | The tier or edition of the particular SKU, e.g. Basic, Premium. |
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

### Parameter: `databaseMaxCapacity`

The maximum capacity any one database can consume.

- Required: No
- Type: int
- Default: `2`

### Parameter: `databaseMinCapacity`

The minimum capacity all databases are guaranteed.

- Required: No
- Type: int
- Default: `0`

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
- Default: `''`

### Parameter: `maxSizeBytes`

The storage limit for the database elastic pool in bytes.

- Required: No
- Type: int
- Default: `34359738368`

### Parameter: `minCapacity`

Minimal capacity that serverless pool will not shrink below, if not paused.

- Required: No
- Type: int

### Parameter: `skuCapacity`

Capacity of the particular SKU.

- Required: No
- Type: int
- Default: `2`

### Parameter: `skuName`

The name of the SKU, typically, a letter + Number code, e.g. P3.

- Required: No
- Type: string
- Default: `'GP_Gen5'`

### Parameter: `skuTier`

The tier or edition of the particular SKU, e.g. Basic, Premium.

- Required: No
- Type: string
- Default: `'GeneralPurpose'`

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

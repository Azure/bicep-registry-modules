# Kusto Cluster Databases `[Microsoft.Kusto/clusters/databases]`

This module deploys a Kusto Cluster Database.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Kusto/clusters/databases` | [2024-04-13](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2024-04-13/clusters/databases) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Kusto Cluster database. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kustoClusterName`](#parameter-kustoclustername) | string | The name of the parent Kusto Cluster. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseKind`](#parameter-databasekind) | string | The object type of the databse. |
| [`databaseReadWriteProperties`](#parameter-databasereadwriteproperties) | object | The properties of the database if using read-write. Only used if databaseKind is ReadWrite. |
| [`location`](#parameter-location) | string | Location for the databases. |

### Parameter: `name`

The name of the Kusto Cluster database.

- Required: Yes
- Type: string

### Parameter: `kustoClusterName`

The name of the parent Kusto Cluster. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `databaseKind`

The object type of the databse.

- Required: No
- Type: string
- Default: `'ReadWrite'`
- Allowed:
  ```Bicep
  [
    'ReadOnlyFollowing'
    'ReadWrite'
  ]
  ```

### Parameter: `databaseReadWriteProperties`

The properties of the database if using read-write. Only used if databaseKind is ReadWrite.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hotCachePeriod`](#parameter-databasereadwritepropertieshotcacheperiod) | string | Te time the data should be kept in cache for fast queries in TimeSpan. |
| [`keyVaultProperties`](#parameter-databasereadwritepropertieskeyvaultproperties) | object | The properties of the key vault. |
| [`softDeletePeriod`](#parameter-databasereadwritepropertiessoftdeleteperiod) | string | The time the data should be kept before it stops being accessible to queries in TimeSpan. |

### Parameter: `databaseReadWriteProperties.hotCachePeriod`

Te time the data should be kept in cache for fast queries in TimeSpan.

- Required: No
- Type: string

### Parameter: `databaseReadWriteProperties.keyVaultProperties`

The properties of the key vault.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-databasereadwritepropertieskeyvaultpropertieskeyname) | string | The name of the key. |
| [`keyVaultUri`](#parameter-databasereadwritepropertieskeyvaultpropertieskeyvaulturi) | string | The Uri of the key vault. |
| [`keyVersion`](#parameter-databasereadwritepropertieskeyvaultpropertieskeyversion) | string | The version of the key. |
| [`userIdentity`](#parameter-databasereadwritepropertieskeyvaultpropertiesuseridentity) | string | The user identity. |

### Parameter: `databaseReadWriteProperties.keyVaultProperties.keyName`

The name of the key.

- Required: No
- Type: string

### Parameter: `databaseReadWriteProperties.keyVaultProperties.keyVaultUri`

The Uri of the key vault.

- Required: No
- Type: string

### Parameter: `databaseReadWriteProperties.keyVaultProperties.keyVersion`

The version of the key.

- Required: No
- Type: string

### Parameter: `databaseReadWriteProperties.keyVaultProperties.userIdentity`

The user identity.

- Required: No
- Type: string

### Parameter: `databaseReadWriteProperties.softDeletePeriod`

The time the data should be kept before it stops being accessible to queries in TimeSpan.

- Required: No
- Type: string

### Parameter: `location`

Location for the databases.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Kusto Cluster database. |
| `resourceGroupName` | string | The resource group containing the Kusto Cluster database. |
| `resourceId` | string | The resource ID of the Kusto Cluster database. |

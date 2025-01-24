# Elastic SAN Volumes `[Microsoft.ElasticSan/elasticSans/volumegroups/volumes]`

This module deploys an Elastic SAN Volume.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ElasticSan/elasticSans/volumegroups/snapshots` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ElasticSan/2023-01-01/elasticSans/volumegroups/snapshots) |
| `Microsoft.ElasticSan/elasticSans/volumegroups/volumes` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ElasticSan/2023-01-01/elasticSans/volumegroups/volumes) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Elastic SAN Volume. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. |
| [`sizeGiB`](#parameter-sizegib) | int | Size of the Elastic SAN Volume in Gibibytes (GiB). The supported capacity ranges from 1 Gibibyte (GiB) to 64 Tebibyte (TiB), equating to 65536 Gibibytes (GiB). |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`elasticSanName`](#parameter-elasticsanname) | string | The name of the parent Elastic SAN. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. |
| [`volumeGroupName`](#parameter-volumegroupname) | string | The name of the parent Elastic SAN Volume Group. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers and hyphens, and must begin and end with a letter or a number. Each hyphen must be preceded and followed by an alphanumeric character. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`snapshots`](#parameter-snapshots) | array | List of Elastic SAN Volume Snapshots to be created in the Elastic SAN Volume. |

### Parameter: `name`

The name of the Elastic SAN Volume. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.

- Required: Yes
- Type: string

### Parameter: `sizeGiB`

Size of the Elastic SAN Volume in Gibibytes (GiB). The supported capacity ranges from 1 Gibibyte (GiB) to 64 Tebibyte (TiB), equating to 65536 Gibibytes (GiB).

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 65536

### Parameter: `elasticSanName`

The name of the parent Elastic SAN. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.

- Required: Yes
- Type: string
- MinValue: 1
- MaxValue: 65536

### Parameter: `volumeGroupName`

The name of the parent Elastic SAN Volume Group. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers and hyphens, and must begin and end with a letter or a number. Each hyphen must be preceded and followed by an alphanumeric character.

- Required: Yes
- Type: string
- MinValue: 1
- MaxValue: 65536

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`
- MinValue: 1
- MaxValue: 65536

### Parameter: `snapshots`

List of Elastic SAN Volume Snapshots to be created in the Elastic SAN Volume.

- Required: No
- Type: array
- MinValue: 1
- MaxValue: 65536

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-snapshotsname) | string | The name of the Elastic SAN Volume Snapshot. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. |

### Parameter: `snapshots.name`

The name of the Elastic SAN Volume Snapshot. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.

- Required: Yes
- Type: string
- MinValue: 1
- MaxValue: 65536

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location of the deployed Elastic SAN Volume. |
| `name` | string | The name of the deployed Elastic SAN Volume. |
| `resourceGroupName` | string | The resource group of the deployed Elastic SAN Volume. |
| `resourceId` | string | The resource ID of the deployed Elastic SAN Volume. |
| `snapshots` | array | Details on the deployed Elastic SAN Volume Snapshots. |
| `targetIqn` | string | The iSCSI Target IQN (iSCSI Qualified Name) of the deployed Elastic SAN Volume. |
| `targetPortalHostname` | string | The iSCSI Target Portal Host Name of the deployed Elastic SAN Volume. |
| `targetPortalPort` | int | The iSCSI Target Portal Port of the deployed Elastic SAN Volume. |
| `volumeId` | string | The volume Id of the deployed Elastic SAN Volume. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `avm/res/elastic-san/elastic-san/volume-group/snapshot` | Local reference |

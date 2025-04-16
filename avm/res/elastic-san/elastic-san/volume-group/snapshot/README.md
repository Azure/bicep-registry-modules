# Elastic SAN Volume Snapshots `[Microsoft.ElasticSan/elasticSans/volumegroups/snapshots]`

This module deploys an Elastic SAN Volume Snapshot.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ElasticSan/elasticSans/volumegroups/snapshots` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ElasticSan/2023-01-01/elasticSans/volumegroups/snapshots) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Elastic SAN Volume Snapshot. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`elasticSanName`](#parameter-elasticsanname) | string | The name of the parent Elastic SAN. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. |
| [`volumeGroupName`](#parameter-volumegroupname) | string | The name of the parent Elastic SAN Volume Group. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers and hyphens, and must begin and end with a letter or a number. Each hyphen must be preceded and followed by an alphanumeric character. |
| [`volumeName`](#parameter-volumename) | string | The name of the parent Elastic SAN Volume. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Location for all resources. |

### Parameter: `name`

The name of the Elastic SAN Volume Snapshot. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.

- Required: Yes
- Type: string

### Parameter: `elasticSanName`

The name of the parent Elastic SAN. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.

- Required: Yes
- Type: string

### Parameter: `volumeGroupName`

The name of the parent Elastic SAN Volume Group. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers and hyphens, and must begin and end with a letter or a number. Each hyphen must be preceded and followed by an alphanumeric character.

- Required: Yes
- Type: string

### Parameter: `volumeName`

The name of the parent Elastic SAN Volume. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.

- Required: Yes
- Type: string

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location of the deployed Elastic SAN Volume Snapshot. |
| `name` | string | The name of the deployed Elastic SAN Volume Snapshot. |
| `resourceGroupName` | string | The resource group of the deployed Elastic SAN Volume Snapshot. |
| `resourceId` | string | The resource ID of the deployed Elastic SAN Volume Snapshot. |

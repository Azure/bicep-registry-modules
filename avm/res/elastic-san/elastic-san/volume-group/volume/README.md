# Elastic SAN Volumes `[Microsoft.ElasticSan/elasticSans/volumegroups/volumes]`

This module deploys an Elastic SAN Volume.

You can reference the module as follows:
```bicep
module elasticSan 'br/public:avm/res/elastic-san/elastic-san/volume-group/volume:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ElasticSan/elasticSans/volumegroups/snapshots` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.elasticsan_elasticsans_volumegroups_snapshots.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ElasticSan/2024-05-01/elasticSans/volumegroups/snapshots)</li></ul> |
| `Microsoft.ElasticSan/elasticSans/volumegroups/volumes` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.elasticsan_elasticsans_volumegroups_volumes.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ElasticSan/2024-05-01/elasticSans/volumegroups/volumes)</li></ul> |

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `volumeGroupName`

The name of the parent Elastic SAN Volume Group. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers and hyphens, and must begin and end with a letter or a number. Each hyphen must be preceded and followed by an alphanumeric character.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `snapshots`

List of Elastic SAN Volume Snapshots to be created in the Elastic SAN Volume.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-snapshotsname) | string | The name of the Elastic SAN Volume Snapshot. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. |

### Parameter: `snapshots.name`

The name of the Elastic SAN Volume Snapshot. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.

- Required: Yes
- Type: string

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

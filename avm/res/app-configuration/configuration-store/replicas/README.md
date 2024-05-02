# App Configuration Replicas `[Microsoft.AppConfiguration/configurationStores/replicas]`

This module deploys an App Configuration Replica.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AppConfiguration/configurationStores/replicas` | [2023-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AppConfiguration/2023-03-01/configurationStores/replicas) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the replica. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appConfigurationName`](#parameter-appconfigurationname) | string | The name of the parent app configuration store. |
| [`replicaLocation`](#parameter-replicalocation) | string | Location of the replica. |

### Parameter: `name`

Name of the replica.

- Required: Yes
- Type: string

### Parameter: `appConfigurationName`

The name of the parent app configuration store.

- Required: Yes
- Type: string

### Parameter: `replicaLocation`

Location of the replica.

- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replica that was deployed. |
| `resourceGroupName` | string | The resource group the app configuration was deployed into. |
| `resourceId` | string | The resource ID of the replica that was deployed. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

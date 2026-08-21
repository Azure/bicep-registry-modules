# Log Analytics Workspace Data Exports `[Microsoft.OperationalInsights/workspaces/dataExports]`

This module deploys a Log Analytics Workspace Data Export.

You can reference the module as follows:
```bicep
module workspace 'br/public:avm/res/operational-insights/workspace/data-export:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/dataExports` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_dataexports.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/dataExports)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The data export rule name. |
| [`tableNames`](#parameter-tablenames) | array | An array of tables to export, for example: ['Heartbeat', 'SecurityEvent']. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent workspaces. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-destination) | object | Destination properties. |
| [`enable`](#parameter-enable) | bool | Active when enabled. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |

### Parameter: `name`

The data export rule name.

- Required: Yes
- Type: string

### Parameter: `tableNames`

An array of tables to export, for example: ['Heartbeat', 'SecurityEvent'].

- Required: Yes
- Type: array

### Parameter: `workspaceName`

The name of the parent workspaces. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `destination`

Destination properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-destinationresourceid) | string | The destination resource ID. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metaData`](#parameter-destinationmetadata) | object | The destination metadata. |

### Parameter: `destination.resourceId`

The destination resource ID.

- Required: Yes
- Type: string

### Parameter: `destination.metaData`

The destination metadata.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubName`](#parameter-destinationmetadataeventhubname) | string | Allows to define an Event Hub name. Not applicable when destination is Storage Account. |

### Parameter: `destination.metaData.eventHubName`

Allows to define an Event Hub name. Not applicable when destination is Storage Account.

- Required: No
- Type: string

### Parameter: `enable`

Active when enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the data export. |
| `resourceGroupName` | string | The name of the resource group the data export was created in. |
| `resourceId` | string | The resource ID of the data export. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

# Virtual Hub Route Maps `[Microsoft.Network/virtualHubs/routeMaps]`

This module deploys a Virtual Hub Route Map.

You can reference the module as follows:
```bicep
module virtualHub 'br/public:avm/res/network/virtual-hub/route-map:<version>' = {
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
| `Microsoft.Network/virtualHubs/routeMaps` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualhubs_routemaps.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/virtualHubs/routeMaps)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the route map. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualHubName`](#parameter-virtualhubname) | string | The name of the parent virtual hub. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`associatedInboundConnections`](#parameter-associatedinboundconnections) | array | List of connections which have this route map associated for inbound traffic. |
| [`associatedOutboundConnections`](#parameter-associatedoutboundconnections) | array | List of connections which have this route map associated for outbound traffic. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`rules`](#parameter-rules) | array | List of route map rules to be applied. |

### Parameter: `name`

The name of the route map.

- Required: Yes
- Type: string

### Parameter: `virtualHubName`

The name of the parent virtual hub. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `associatedInboundConnections`

List of connections which have this route map associated for inbound traffic.

- Required: No
- Type: array

### Parameter: `associatedOutboundConnections`

List of connections which have this route map associated for outbound traffic.

- Required: No
- Type: array

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `rules`

List of route map rules to be applied.

- Required: No
- Type: array

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed route map. |
| `resourceGroupName` | string | The resource group the route map was deployed into. |
| `resourceId` | string | The resource ID of the deployed route map. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

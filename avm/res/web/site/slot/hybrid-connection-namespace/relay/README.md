# Web/Function Apps Slot Hybrid Connection Relay `[Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays]`

This module deploys a Site Slot Hybrid Connection Namespace Relay.

You can reference the module as follows:
```bicep
module site 'br/public:avm/res/web/site/slot/hybrid-connection-namespace/relay:<version>' = {
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
| `Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_slots_hybridconnectionnamespaces_relays.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/slots/hybridConnectionNamespaces/relays)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hybridConnectionResourceId`](#parameter-hybridconnectionresourceid) | string | The resource ID of the relay namespace hybrid connection. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appName`](#parameter-appname) | string | The name of the parent web site. Required if the template is used in a standalone deployment. |
| [`slotName`](#parameter-slotname) | string | The name of the site slot. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`sendKeyName`](#parameter-sendkeyname) | string | Name of the authorization rule send key to use. |

### Parameter: `hybridConnectionResourceId`

The resource ID of the relay namespace hybrid connection.

- Required: Yes
- Type: string

### Parameter: `appName`

The name of the parent web site. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `slotName`

The name of the site slot. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `sendKeyName`

Name of the authorization rule send key to use.

- Required: No
- Type: string
- Default: `'defaultSender'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the hybrid connection relay.. |
| `resourceGroupName` | string | The name of the resource group the resource was deployed into. |
| `resourceId` | string | The resource ID of the hybrid connection relay. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

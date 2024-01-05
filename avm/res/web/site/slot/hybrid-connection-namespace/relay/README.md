# Web/Function Apps Slot Hybrid Connection Relay `[Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays]`

This module deploys a Site Slot Hybrid Connection Namespace Relay.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/slots/hybridConnectionNamespaces/relays) |

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

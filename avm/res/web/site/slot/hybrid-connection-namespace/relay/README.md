# Web/Function Apps Slot Hybrid Connection Relay `[Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays]`

This module deploys a Site Slot Hybrid Connection Namespace Relay.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

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
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location for all Resources. |
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

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

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

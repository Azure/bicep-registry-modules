# Web/Function Apps Slot Hybrid Connection Relay `[Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays]`

This module deploys a Site Slot Hybrid Connection Namespace Relay.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays` | 2024-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_slots_hybridconnectionnamespaces_relays.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/hybridConnectionNamespaces/relays)</li></ul> |

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

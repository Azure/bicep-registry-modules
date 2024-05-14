# Static Web App Site Linked Backends `[Microsoft.Web/staticSites/linkedBackends]`

This module deploys a Custom Function App into a Static Web App Site using the Linked Backends property.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/staticSites/linkedBackends` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-03-01/staticSites/linkedBackends) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backendResourceId`](#parameter-backendresourceid) | string | The resource ID of the backend linked to the static site. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`staticSiteName`](#parameter-staticsitename) | string | The name of the parent Static Web App. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the backend to link to the static site. |
| [`region`](#parameter-region) | string | The region of the backend linked to the static site. |

### Parameter: `backendResourceId`

The resource ID of the backend linked to the static site.

- Required: Yes
- Type: string

### Parameter: `staticSiteName`

The name of the parent Static Web App. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the backend to link to the static site.

- Required: No
- Type: string
- Default: `[uniqueString(parameters('backendResourceId'))]`

### Parameter: `region`

The region of the backend linked to the static site.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the static site linked backend. |
| `resourceGroupName` | string | The resource group the static site linked backend was deployed into. |
| `resourceId` | string | The resource ID of the static site linked backend. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

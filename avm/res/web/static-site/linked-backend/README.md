# Static Web App Site Linked Backends `[Microsoft.Web/staticSites/linkedBackends]`

This module deploys a Custom Function App into a Static Web App Site using the Linked Backends property.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

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

# Static Web App Site Custom Domains `[Microsoft.Web/staticSites/customDomains]`

This module deploys a Static Web App Site Custom Domain.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/staticSites/customDomains` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-03-01/staticSites/customDomains) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The custom domain name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`staticSiteName`](#parameter-staticsitename) | string | The name of the parent Static Web App. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`validationMethod`](#parameter-validationmethod) | string | Validation method for adding a custom domain. |

### Parameter: `name`

The custom domain name.

- Required: Yes
- Type: string

### Parameter: `staticSiteName`

The name of the parent Static Web App. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `validationMethod`

Validation method for adding a custom domain.

- Required: No
- Type: string
- Default: `'cname-delegation'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the static site custom domain. |
| `resourceGroupName` | string | The resource group the static site custom domain was deployed into. |
| `resourceId` | string | The resource ID of the static site custom domain. |

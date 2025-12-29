# Integration Account Maps `[Microsoft.Logic/integrationAccounts/maps]`

This module deploys an Integration Account Map.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Logic/integrationAccounts/maps` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_maps.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/maps)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`content`](#parameter-content) | string | The content of the map. |
| [`name`](#parameter-name) | string | The name of the map resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`integrationAccountName`](#parameter-integrationaccountname) | string | The name of the parent integration account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-contenttype) | string | The content type of the map. |
| [`location`](#parameter-location) | string | Resource location. |
| [`mapType`](#parameter-maptype) | string | The map type. |
| [`metadata`](#parameter-metadata) | object | The metadata. |
| [`parametersSchema`](#parameter-parametersschema) | object | The parameters schema of integration account map. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `content`

The content of the map.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the map resource.

- Required: Yes
- Type: string

### Parameter: `integrationAccountName`

The name of the parent integration account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `contentType`

The content type of the map.

- Required: No
- Type: string

### Parameter: `location`

Resource location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `mapType`

The map type.

- Required: No
- Type: string
- Default: `'Xslt'`
- Allowed:
  ```Bicep
  [
    'Liquid'
    'NotSpecified'
    'Xslt'
    'Xslt20'
    'Xslt30'
  ]
  ```

### Parameter: `metadata`

The metadata.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-metadata>any_other_property<) | string | A metadata key-value pair. |

### Parameter: `metadata.>Any_other_property<`

A metadata key-value pair.

- Required: No
- Type: string

### Parameter: `parametersSchema`

The parameters schema of integration account map.

- Required: No
- Type: object

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the integration account map. |
| `resourceGroupName` | string | The resource group the integration account map was deployed into. |
| `resourceId` | string | The resource ID of the integration account map. |

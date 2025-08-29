# Integration Account Schemas `[Microsoft.Logic/integrationAccounts/schemas]`

This module deploys an Integration Account Schema.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Logic/integrationAccounts/schemas` | [2019-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/schemas) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentLinkContent`](#parameter-contentlinkcontent) | object | Content link settings. |
| [`name`](#parameter-name) | string | The Name of the schema resource. |
| [`schemaType`](#parameter-schematype) | string | The schema type. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`integrationAccountName`](#parameter-integrationaccountname) | string | The name of the parent integration account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`documentName`](#parameter-documentname) | string | The document name. |
| [`location`](#parameter-location) | string | Resource location. |
| [`metadata`](#parameter-metadata) | object | The schema metadata. |
| [`tags`](#parameter-tags) | object | Resource tags. |
| [`targetNamespace`](#parameter-targetnamespace) | string | The target namespace of the schema. |

### Parameter: `contentLinkContent`

Content link settings.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`uri`](#parameter-contentlinkcontenturi) | string | The URI of the content link. |

### Parameter: `contentLinkContent.uri`

The URI of the content link.

- Required: Yes
- Type: string

### Parameter: `name`

The Name of the schema resource.

- Required: Yes
- Type: string

### Parameter: `schemaType`

The schema type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'NotSpecified'
    'Xml'
  ]
  ```

### Parameter: `integrationAccountName`

The name of the parent integration account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `documentName`

The document name.

- Required: No
- Type: string

### Parameter: `location`

Resource location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `metadata`

The schema metadata.

- Required: No
- Type: object

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `targetNamespace`

The target namespace of the schema.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the integration account schema. |
| `resourceGroupName` | string | The resource group the integration account schema was deployed into. |
| `resourceId` | string | The resource ID of the integration account schema. |

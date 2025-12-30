# Integration Account Schemas `[Microsoft.Logic/integrationAccounts/schemas]`

This module deploys an Integration Account Schema.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Logic/integrationAccounts/schemas` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_schemas.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/schemas)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`content`](#parameter-content) | string | The schema content. |
| [`name`](#parameter-name) | string | The Name of the schema resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`integrationAccountName`](#parameter-integrationaccountname) | string | The name of the parent integration account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-contenttype) | string | The schema content type. |
| [`documentName`](#parameter-documentname) | string | The document name. |
| [`location`](#parameter-location) | string | Resource location. |
| [`metadata`](#parameter-metadata) | object | The metadata. |
| [`schemaType`](#parameter-schematype) | string | The schema type. |
| [`tags`](#parameter-tags) | object | Resource tags. |
| [`targetNamespace`](#parameter-targetnamespace) | string | The target namespace of the schema. |

### Parameter: `content`

The schema content.

- Required: Yes
- Type: string

### Parameter: `name`

The Name of the schema resource.

- Required: Yes
- Type: string

### Parameter: `integrationAccountName`

The name of the parent integration account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `contentType`

The schema content type.

- Required: No
- Type: string
- Default: `'application/xml'`

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

### Parameter: `schemaType`

The schema type.

- Required: No
- Type: string
- Default: `'Xml'`
- Allowed:
  ```Bicep
  [
    'NotSpecified'
    'Xml'
  ]
  ```

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

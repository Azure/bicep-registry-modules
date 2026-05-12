# API Center Service Metadata Schemas `[Microsoft.ApiCenter/services/metadataSchemas]`

This module deploys an API Center Service Metadata Schema.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiCenter/services/metadataSchemas` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_metadataschemas.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/metadataSchemas)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the metadata schema. |
| [`schema`](#parameter-schema) | string | The JSON schema defining the metadata type. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serviceName`](#parameter-servicename) | string | The name of the parent API Center service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assignedTo`](#parameter-assignedto) | array | The entities the metadata schema is assigned to. |

### Parameter: `name`

The name of the metadata schema.

- Required: Yes
- Type: string

### Parameter: `schema`

The JSON schema defining the metadata type.

- Required: Yes
- Type: string

### Parameter: `serviceName`

The name of the parent API Center service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `assignedTo`

The entities the metadata schema is assigned to.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deprecated`](#parameter-assignedtodeprecated) | bool | Whether the assignment is deprecated. |
| [`entity`](#parameter-assignedtoentity) | string | The entity the metadata schema is assigned to. |
| [`required`](#parameter-assignedtorequired) | bool | Whether the metadata is required for the entity. |

### Parameter: `assignedTo.deprecated`

Whether the assignment is deprecated.

- Required: No
- Type: bool

### Parameter: `assignedTo.entity`

The entity the metadata schema is assigned to.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'api'
    'deployment'
    'environment'
  ]
  ```

### Parameter: `assignedTo.required`

Whether the metadata is required for the entity.

- Required: No
- Type: bool

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the metadata schema. |
| `resourceGroupName` | string | The name of the resource group the metadata schema was created in. |
| `resourceId` | string | The resource ID of the metadata schema. |

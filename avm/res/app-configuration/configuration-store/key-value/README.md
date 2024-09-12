# App Configuration Stores Key Values `[Microsoft.AppConfiguration/configurationStores/keyValues]`

This module deploys an App Configuration Store Key Value.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AppConfiguration/configurationStores/keyValues` | [2023-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AppConfiguration/2023-03-01/configurationStores/keyValues) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the key. |
| [`value`](#parameter-value) | string | The value of the key-value. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appConfigurationName`](#parameter-appconfigurationname) | string | The name of the parent app configuration store. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-contenttype) | string | The content type of the key-values value. Providing a proper content-type can enable transformations of values when they are retrieved by applications. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the key.

- Required: Yes
- Type: string

### Parameter: `value`

The value of the key-value.

- Required: Yes
- Type: string

### Parameter: `appConfigurationName`

The name of the parent app configuration store. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `contentType`

The content type of the key-values value. Providing a proper content-type can enable transformations of values when they are retrieved by applications.

- Required: No
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the key values. |
| `resourceGroupName` | string | The resource group the batch account was deployed into. |
| `resourceId` | string | The resource ID of the key values. |

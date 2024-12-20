# Data Factory Linked Service `[Microsoft.DataFactory/factories/linkedservices]`

This module deploys a Data Factory Linked Service.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DataFactory/factories/linkedservices` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/linkedservices) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Linked Service. |
| [`type`](#parameter-type) | string | The type of Linked Service. See https://learn.microsoft.com/en-us/azure/templates/microsoft.datafactory/factories/linkedservices?pivots=deployment-language-bicep#linkedservice-objects for more information. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataFactoryName`](#parameter-datafactoryname) | string | The name of the parent Azure Data Factory. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | The description of the Integration Runtime. |
| [`integrationRuntimeName`](#parameter-integrationruntimename) | string | The name of the Integration Runtime to use. |
| [`parameters`](#parameter-parameters) | object | Use this to add parameters for a linked service connection string. |
| [`typeProperties`](#parameter-typeproperties) | object | Used to add connection properties for your linked services. |

### Parameter: `name`

The name of the Linked Service.

- Required: Yes
- Type: string

### Parameter: `type`

The type of Linked Service. See https://learn.microsoft.com/en-us/azure/templates/microsoft.datafactory/factories/linkedservices?pivots=deployment-language-bicep#linkedservice-objects for more information.

- Required: Yes
- Type: string

### Parameter: `dataFactoryName`

The name of the parent Azure Data Factory. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

The description of the Integration Runtime.

- Required: No
- Type: string
- Default: `'Linked Service created by avm-res-datafactory-factories'`

### Parameter: `integrationRuntimeName`

The name of the Integration Runtime to use.

- Required: No
- Type: string
- Default: `'none'`

### Parameter: `parameters`

Use this to add parameters for a linked service connection string.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `typeProperties`

Used to add connection properties for your linked services.

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Linked Service. |
| `resourceGroupName` | string | The name of the Resource Group the Linked Service was created in. |
| `resourceId` | string | The resource ID of the Linked Service. |

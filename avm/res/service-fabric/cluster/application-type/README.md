# Service Fabric Cluster Application Types `[Microsoft.ServiceFabric/clusters/applicationTypes]`

This module deploys a Service Fabric Cluster Application Type.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceFabric/clusters/applicationTypes` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceFabric/2021-06-01/clusters/applicationTypes) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serviceFabricClusterName`](#parameter-servicefabricclustername) | string | The name of the parent Service Fabric cluster. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Application type name. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `serviceFabricClusterName`

The name of the parent Service Fabric cluster. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `name`

Application type name.

- Required: No
- Type: string
- Default: `'defaultApplicationType'`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The resource name of the Application type. |
| `resourceGroupName` | string | The resource group of the Application type. |
| `resourceID` | string | The resource ID of the Application type. |

# Data Factory Managed Virtual Network Managed PrivateEndpoints `[Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints]`

This module deploys a Data Factory Managed Virtual Network Managed Private Endpoint.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks/managedPrivateEndpoints) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdns`](#parameter-fqdns) | array | Fully qualified domain names. |
| [`groupId`](#parameter-groupid) | string | The groupId to which the managed private endpoint is created. |
| [`managedVirtualNetworkName`](#parameter-managedvirtualnetworkname) | string | The name of the parent managed virtual network. |
| [`name`](#parameter-name) | string | The managed private endpoint resource name. |
| [`privateLinkResourceId`](#parameter-privatelinkresourceid) | string | The ARM resource ID of the resource to which the managed private endpoint is created. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataFactoryName`](#parameter-datafactoryname) | string | The name of the parent data factory. Required if the template is used in a standalone deployment. |

### Parameter: `fqdns`

Fully qualified domain names.

- Required: Yes
- Type: array

### Parameter: `groupId`

The groupId to which the managed private endpoint is created.

- Required: Yes
- Type: string

### Parameter: `managedVirtualNetworkName`

The name of the parent managed virtual network.

- Required: Yes
- Type: string

### Parameter: `name`

The managed private endpoint resource name.

- Required: Yes
- Type: string

### Parameter: `privateLinkResourceId`

The ARM resource ID of the resource to which the managed private endpoint is created.

- Required: Yes
- Type: string

### Parameter: `dataFactoryName`

The name of the parent data factory. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed managed private endpoint. |
| `resourceGroupName` | string | The resource group of the deployed managed private endpoint. |
| `resourceId` | string | The resource ID of the deployed managed private endpoint. |

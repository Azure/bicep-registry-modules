# Arc Gateway `[Microsoft.AzureStackHCI/clusters]`

This module deploys an Arc Gateway.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.HybridCompute/gateways` | [2024-05-20-preview](https://learn.microsoft.com/en-us/azure/templates) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Arc Gateway to deploy. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedFeatures`](#parameter-allowedfeatures) | array | Arc Gateway allowed features. |
| [`gatewayType`](#parameter-gatewaytype) | string | Arc Gateway type. Detaults to Public. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

The name of the Arc Gateway to deploy.

- Required: Yes
- Type: string

### Parameter: `allowedFeatures`

Arc Gateway allowed features.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    '*'
  ]
  ```

### Parameter: `gatewayType`

Arc Gateway type. Detaults to Public.

- Required: No
- Type: string
- Default: `'Public'`
- Allowed:
  ```Bicep
  [
    'Public'
  ]
  ```

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `arcGWURI` | string | The endpoint of the Arc Gateway. |
| `location` | string | The location of the arcGateway. |
| `name` | string | The name of the Arc Gateway. |
| `resourceGroupName` | string | The resource group of the Arc Gateway. |
| `resourceId` | string | The ID of the Arc Gateway. |

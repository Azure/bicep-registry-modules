# Load Balancer Backend Address Pools `[Microsoft.Network/loadBalancers/backendAddressPools]`

This module deploys a Load Balancer Backend Address Pools.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/loadBalancers/backendAddressPools` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/loadBalancers/backendAddressPools) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the backend address pool. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`loadBalancerName`](#parameter-loadbalancername) | string | The name of the parent load balancer. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`drainPeriodInSeconds`](#parameter-drainperiodinseconds) | int | Amount of seconds Load Balancer waits for before sending RESET to client and backend address. if value is 0 then this property will be set to null. Subscription must register the feature Microsoft.Network/SLBAllowConnectionDraining before using this property. |
| [`loadBalancerBackendAddresses`](#parameter-loadbalancerbackendaddresses) | array | An array of backend addresses. |
| [`syncMode`](#parameter-syncmode) | string | Backend address synchronous mode for the backend pool. |
| [`tunnelInterfaces`](#parameter-tunnelinterfaces) | array | An array of gateway load balancer tunnel interfaces. |

### Parameter: `name`

The name of the backend address pool.

- Required: Yes
- Type: string

### Parameter: `loadBalancerName`

The name of the parent load balancer. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `drainPeriodInSeconds`

Amount of seconds Load Balancer waits for before sending RESET to client and backend address. if value is 0 then this property will be set to null. Subscription must register the feature Microsoft.Network/SLBAllowConnectionDraining before using this property.

- Required: No
- Type: int
- Default: `0`

### Parameter: `loadBalancerBackendAddresses`

An array of backend addresses.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `syncMode`

Backend address synchronous mode for the backend pool.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Automatic'
    'Manual'
  ]
  ```

### Parameter: `tunnelInterfaces`

An array of gateway load balancer tunnel interfaces.

- Required: No
- Type: array
- Default: `[]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backend address pool. |
| `resourceGroupName` | string | The resource group the backend address pool was deployed into. |
| `resourceId` | string | The resource ID of the backend address pool. |

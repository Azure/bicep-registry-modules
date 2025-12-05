# Load Balancer Backend Address Pools `[Microsoft.Network/loadBalancers/backendAddressPools]`

This module deploys a Load Balancer Backend Address Pools.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Network/loadBalancers/backendAddressPools` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_loadbalancers_backendaddresspools.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/loadBalancers/backendAddressPools)</li></ul> |

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
| [`backendMembershipMode`](#parameter-backendmembershipmode) | string | How backend pool members are managed. NIC = via NIC IP configs, BackendAddress = via backend addresses, None = empty pool. |
| [`drainPeriodInSeconds`](#parameter-drainperiodinseconds) | int | Amount of seconds Load Balancer waits for before sending RESET to client and backend address. if value is 0 then this property will be set to null. Subscription must register the feature Microsoft.Network/SLBAllowConnectionDraining before using this property. |
| [`loadBalancerBackendAddresses`](#parameter-loadbalancerbackendaddresses) | array | An array of backend addresses. |
| [`syncMode`](#parameter-syncmode) | string | Backend address synchronous mode for the backend pool. |
| [`tunnelInterfaces`](#parameter-tunnelinterfaces) | array | An array of gateway load balancer tunnel interfaces. |
| [`virtualNetworkResourceId`](#parameter-virtualnetworkresourceid) | string | The resource Id of the virtual network. |

### Parameter: `name`

The name of the backend address pool.

- Required: Yes
- Type: string

### Parameter: `loadBalancerName`

The name of the parent load balancer. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `backendMembershipMode`

How backend pool members are managed. NIC = via NIC IP configs, BackendAddress = via backend addresses, None = empty pool.

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'BackendAddress'
    'NIC'
    'None'
  ]
  ```

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

### Parameter: `virtualNetworkResourceId`

The resource Id of the virtual network.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backend address pool. |
| `resourceGroupName` | string | The resource group the backend address pool was deployed into. |
| `resourceId` | string | The resource ID of the backend address pool. |

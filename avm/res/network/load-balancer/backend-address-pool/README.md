# Load Balancer Backend Address Pools `[Microsoft.Network/loadBalancers/backendAddressPools]`

This module deploys a Load Balancer Backend Address Pools.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

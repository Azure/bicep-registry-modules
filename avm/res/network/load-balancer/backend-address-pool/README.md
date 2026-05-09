# Load Balancer Backend Address Pools `[Microsoft.Network/loadBalancers/backendAddressPools]`

This module deploys a Load Balancer Backend Address Pools.

You can reference the module as follows:
```bicep
module loadBalancer 'br/public:avm/res/network/load-balancer/backend-address-pool:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

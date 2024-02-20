# Load Balancer Inbound NAT Rules `[Microsoft.Network/loadBalancers/inboundNatRules]`

This module deploys a Load Balancer Inbound NAT Rules.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/loadBalancers/inboundNatRules` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/loadBalancers/inboundNatRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`frontendIPConfigurationName`](#parameter-frontendipconfigurationname) | string | The name of the frontend IP address to set for the inbound NAT rule. |
| [`frontendPort`](#parameter-frontendport) | int | The port for the external endpoint. Port numbers for each rule must be unique within the Load Balancer. |
| [`name`](#parameter-name) | string | The name of the inbound NAT rule. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`loadBalancerName`](#parameter-loadbalancername) | string | The name of the parent load balancer. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backendAddressPoolName`](#parameter-backendaddresspoolname) | string | Name of the backend address pool. |
| [`backendPort`](#parameter-backendport) | int | The port used for the internal endpoint. |
| [`enableFloatingIP`](#parameter-enablefloatingip) | bool | Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn Availability Group. This setting is required when using the SQL AlwaysOn Availability Groups in SQL server. This setting can't be changed after you create the endpoint. |
| [`enableTcpReset`](#parameter-enabletcpreset) | bool | Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination. This element is only used when the protocol is set to TCP. |
| [`frontendPortRangeEnd`](#parameter-frontendportrangeend) | int | The port range end for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeStart. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. |
| [`frontendPortRangeStart`](#parameter-frontendportrangestart) | int | The port range start for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeEnd. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. |
| [`idleTimeoutInMinutes`](#parameter-idletimeoutinminutes) | int | The timeout for the TCP idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. This element is only used when the protocol is set to TCP. |
| [`protocol`](#parameter-protocol) | string | The transport protocol for the endpoint. |

### Parameter: `frontendIPConfigurationName`

The name of the frontend IP address to set for the inbound NAT rule.

- Required: Yes
- Type: string

### Parameter: `frontendPort`

The port for the external endpoint. Port numbers for each rule must be unique within the Load Balancer.

- Required: Yes
- Type: int

### Parameter: `name`

The name of the inbound NAT rule.

- Required: Yes
- Type: string

### Parameter: `loadBalancerName`

The name of the parent load balancer. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `backendAddressPoolName`

Name of the backend address pool.

- Required: No
- Type: string
- Default: `''`

### Parameter: `backendPort`

The port used for the internal endpoint.

- Required: No
- Type: int
- Default: `[parameters('frontendPort')]`

### Parameter: `enableFloatingIP`

Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn Availability Group. This setting is required when using the SQL AlwaysOn Availability Groups in SQL server. This setting can't be changed after you create the endpoint.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTcpReset`

Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination. This element is only used when the protocol is set to TCP.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `frontendPortRangeEnd`

The port range end for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeStart. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool.

- Required: No
- Type: int
- Default: `-1`

### Parameter: `frontendPortRangeStart`

The port range start for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeEnd. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool.

- Required: No
- Type: int
- Default: `-1`

### Parameter: `idleTimeoutInMinutes`

The timeout for the TCP idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. This element is only used when the protocol is set to TCP.

- Required: No
- Type: int
- Default: `4`

### Parameter: `protocol`

The transport protocol for the endpoint.

- Required: No
- Type: string
- Default: `'Tcp'`
- Allowed:
  ```Bicep
  [
    'All'
    'Tcp'
    'Udp'
  ]
  ```


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the inbound NAT rule. |
| `resourceGroupName` | string | The resource group the inbound NAT rule was deployed into. |
| `resourceId` | string | The resource ID of the inbound NAT rule. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

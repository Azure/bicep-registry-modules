# Load Balancer Inbound NAT Rules `[Microsoft.Network/loadBalancers/inboundNatRules]`

This module deploys a Load Balancer Inbound NAT Rules.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

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
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`enableFloatingIP`](#parameter-enablefloatingip) | bool | Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn Availability Group. This setting is required when using the SQL AlwaysOn Availability Groups in SQL server. This setting can't be changed after you create the endpoint. |
| [`enableTcpReset`](#parameter-enabletcpreset) | bool | Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination. This element is only used when the protocol is set to TCP. |
| [`frontendPortRangeEnd`](#parameter-frontendportrangeend) | int | The port range end for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeStart. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. |
| [`frontendPortRangeStart`](#parameter-frontendportrangestart) | int | The port range start for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeEnd. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. |
| [`idleTimeoutInMinutes`](#parameter-idletimeoutinminutes) | int | The timeout for the TCP idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. This element is only used when the protocol is set to TCP. |
| [`protocol`](#parameter-protocol) | string | The transport protocol for the endpoint. |

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

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `frontendIPConfigurationName`

The name of the frontend IP address to set for the inbound NAT rule.
- Required: Yes
- Type: string

### Parameter: `frontendPort`

The port for the external endpoint. Port numbers for each rule must be unique within the Load Balancer.
- Required: Yes
- Type: int

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

### Parameter: `loadBalancerName`

The name of the parent load balancer. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `name`

The name of the inbound NAT rule.
- Required: Yes
- Type: string

### Parameter: `protocol`

The transport protocol for the endpoint.
- Required: No
- Type: string
- Default: `'Tcp'`
- Allowed: `[All, Tcp, Udp]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the inbound NAT rule. |
| `resourceGroupName` | string | The resource group the inbound NAT rule was deployed into. |
| `resourceId` | string | The resource ID of the inbound NAT rule. |

## Cross-referenced modules

_None_

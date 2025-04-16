# VPN Gateway NAT Rules `[Microsoft.Network/vpnGateways/natRules]`

This module deploys a VPN Gateway NAT Rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/vpnGateways/natRules` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/vpnGateways/natRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the NAT rule. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`vpnGatewayName`](#parameter-vpngatewayname) | string | The name of the parent VPN gateway this NAT rule is associated with. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`externalMappings`](#parameter-externalmappings) | array | An address prefix range of destination IPs on the outside network that source IPs will be mapped to. In other words, your post-NAT address prefix range. |
| [`internalMappings`](#parameter-internalmappings) | array | An address prefix range of source IPs on the inside network that will be mapped to a set of external IPs. In other words, your pre-NAT address prefix range. |
| [`ipConfigurationId`](#parameter-ipconfigurationid) | string | A NAT rule must be configured to a specific VPN Gateway instance. This is applicable to Dynamic NAT only. Static NAT rules are automatically applied to both VPN Gateway instances. |
| [`mode`](#parameter-mode) | string | The type of NAT rule for VPN NAT. IngressSnat mode (also known as Ingress Source NAT) is applicable to traffic entering the Azure hub's site-to-site VPN gateway. EgressSnat mode (also known as Egress Source NAT) is applicable to traffic leaving the Azure hub's Site-to-site VPN gateway. |
| [`type`](#parameter-type) | string | The type of NAT rule for VPN NAT. Static one-to-one NAT establishes a one-to-one relationship between an internal address and an external address while Dynamic NAT assigns an IP and port based on availability. |

### Parameter: `name`

The name of the NAT rule.

- Required: Yes
- Type: string

### Parameter: `vpnGatewayName`

The name of the parent VPN gateway this NAT rule is associated with. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `externalMappings`

An address prefix range of destination IPs on the outside network that source IPs will be mapped to. In other words, your post-NAT address prefix range.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `internalMappings`

An address prefix range of source IPs on the inside network that will be mapped to a set of external IPs. In other words, your pre-NAT address prefix range.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `ipConfigurationId`

A NAT rule must be configured to a specific VPN Gateway instance. This is applicable to Dynamic NAT only. Static NAT rules are automatically applied to both VPN Gateway instances.

- Required: No
- Type: string

### Parameter: `mode`

The type of NAT rule for VPN NAT. IngressSnat mode (also known as Ingress Source NAT) is applicable to traffic entering the Azure hub's site-to-site VPN gateway. EgressSnat mode (also known as Egress Source NAT) is applicable to traffic leaving the Azure hub's Site-to-site VPN gateway.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'EgressSnat'
    'IngressSnat'
  ]
  ```

### Parameter: `type`

The type of NAT rule for VPN NAT. Static one-to-one NAT establishes a one-to-one relationship between an internal address and an external address while Dynamic NAT assigns an IP and port based on availability.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dynamic'
    'Static'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the NAT rule. |
| `resourceGroupName` | string | The name of the resource group the NAT rule was deployed into. |
| `resourceId` | string | The resource ID of the NAT rule. |

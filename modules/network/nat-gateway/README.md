# NAT gateways

A bicep module for simplified deployment for NAT gateways and available configuration options.

## Description

NAT gateway provides outbound internet connectivity for one or more subnets of a virtual network.
The module creates a NAT Gateway resource using the Microsoft.Network/natGateways provider, with a standard SKU and the specified properties, including idle timeout, public IP addresses, public IP prefixes, and availability zones.
[quickstart-create-nat-gateway-portal](https://learn.microsoft.com/en-us/azure/virtual-network/nat-gateway/quickstart-create-nat-gateway-portal)
[nat-gateway](https://learn.microsoft.com/en-us/azure/virtual-network/nat-gateway/nat-gateway-resource)

## Parameters

| Name                   | Type     | Required | Description                                                                                 |
| :--------------------- | :------: | :------: | :------------------------------------------------------------------------------------------ |
| `prefix`               | `string` | No       | Required. Prefix of NAT Gateway Resource Name. This param is ignored when name is provided. |
| `name`                 | `string` | No       | Optional. The name of the NAT Gateway resource.                                             |
| `location`             | `string` | Yes      | Required. Location(region) for NAT Gateway will be deployed.                                |
| `tags`                 | `object` | No       | Optional. Tags for natGateways resource.                                                    |
| `idleTimeoutInMinutes` | `int`    | No       | Optional. The idle timeout of the NAT Gateway.                                              |
| `publicIpAddresses`    | `array`  | No       | Optional. An array of public ip addresses associated with the nat gateway resource.         |
| `publicIpPrefixes`     | `array`  | No       | Optional. An array of public ip prefixes associated with the nat gateway resource.          |
| `isZoneRedundant`      | `bool`   | No       | Toggle to enable or disable zone redundance.                                                |
| `zones`                | `array`  | No       | Optional. Specify Azure Availability Zone IDs when zone redundance is enabled.              |

## Outputs

| Name | Type   | Description                             |
| :--- | :----: | :-------------------------------------- |
| id   | string | Id of the NAT Gateway resource created. |
| name | string | Name of the NAT Gateway Resource.       |

## Examples

### Example 1

```bicep
param name string = 'my-natGateway-01'
param location = 'eastus'

module natGateway 'br/public:network/nat-gateway:1.0.1' = {
  name: 'my-natGateway-01'
  params: {
    name: name
    location: location
  }
}
```

### Example 2

```bicep
param name string = 'my-natGateway-02'
param location = 'eastus'

module natGateway 'br/public:network/nat-gateway:1.0.1' = {
  name: 'my-natGateway-02'
  params: {
    name: name
    location: location
    publicIpAddresses: [
      {
        id: '/subscriptions/xxxx/resourceGroups/xxxx/providers/Microsoft.Network/publicIPAddresses/xxx-nat-public-ip-xxxx'
      }
    ]
    publicIpPrefixes: [
      {
        id: '/subscriptions/xxxx/resourceGroups/xxxxx/providers/Microsoft.Network/publicIPPrefixes/xxxx-nat-public-ip-prefix-xxxx'
      }
    ]
  }
}
```
# NAT gateways

A bicep module for simplified deployment for NAT gateways and available configuration options.

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                   | Type     | Required | Description                                                                         |
| :--------------------- | :------: | :------: | :---------------------------------------------------------------------------------- |
| `name`                 | `string` | Yes      | Required. The name of the NAT Gateway resource.                                     |
| `location`             | `string` | Yes      | Required. Location(region) for NAT Gateway will be deployed.                        |
| `tags`                 | `object` | No       | Optional. Tags to apply to all Azure Resource(s).                                   |
| `idleTimeoutInMinutes` | `int`    | No       | Optional. The idle timeout of the NAT Gateway.                                      |
| `publicIpAddresses`    | `array`  | No       | Optional. An array of public ip addresses associated with the nat gateway resource. |
| `publicIpPrefixes`     | `array`  | No       | Optional. An array of public ip prefixes associated with the nat gateway resource.  |
| `zones`                | `array`  | No       | Optional. Specify Azure Availability Zone IDs or leave unset to disable.            |

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

module natGateway 'br/public:network/nat-gateway:1.0.0' = {
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

module natGateway 'br/public:network/nat-gateway:1.0.0' = {
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
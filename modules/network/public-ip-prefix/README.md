# Public Ip Prefix

Bicep Module for creating Public Ip Prefix

## Description

A public IP address prefix is a reserved range of public IP addresses in Azure. Public IP prefixes are assigned from a pool of addresses in each Azure region. You create a public IP address prefix in an Azure region and subscription by specifying a name and prefix size. The prefix size is the number of addresses available for use. Public IP address prefixes consist of IPv4 or IPv6 addresses. In regions with Availability Zones, Public IP address prefixes can be created as zone-redundant or associated with a specific availability zone. After the public IP prefix is created, you can create public IP addresses.

[public-ip-prefix](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-address-prefix)
[public-ip-prefix-bicep](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/publicipprefixes?pivots=deployment-language-bicep)

## Parameters

| Name                     | Type     | Required | Description                                                                                                             |
| :----------------------- | :------: | :------: | :---------------------------------------------------------------------------------------------------------------------- |
| `name`                   | `string` | Yes      | Required. Name of the public IP Prefix.                                                                                 |
| `location`               | `string` | Yes      | Required. Define the Azure Location that the Public IP Prefix should be created within.                                 |
| `tags`                   | `object` | No       | Optional. Tags for Public IP Prefix.                                                                                    |
| `tier`                   | `string` | No       | Optional. tier for the Public IP Prefix, Default set to Regional                                                        |
| `publicIPAddressVersion` | `string` | No       | Optional. IP address version.                                                                                           |
| `prefixLength`           | `int`    | Yes      | Required. The Length of the Public IP Prefix.                                                                           |
| `availabilityZones`      | `array`  | No       | Optional. A list of availability zones denoting the IP allocated for the resource needs to come from. Default set to [] |

## Outputs

| Name     | Type   | Description                   |
| :------- | :----: | :---------------------------- |
| id       | string | Id of the Public IP Prefix.   |
| name     | string | Name of the Public IP Prefix. |
| ipPrefix | string | The allocated IP Prefix.      |

## Examples

### Example 1

```bicep
param location string = 'eastus'

module publicIpPrefix1 'br/public:network/public-ip-prefixes:1.0.1' = {
  name: 'publicIpPrefix1'
  params: {
    name: 'publicIpPrefix1'
    location: location
    prefixLength: 30
  }
}
```

### Example 2

```bicep
param location string = 'eastus'

module publicIpPrefix2 'br/public:network/public-ip-prefixes:1.0.1' = {
  name: 'publicIpPrefix2'
  params: {
    name: 'publicIpPrefix2'
    location: location
    prefixLength: 30
    publicIPAddressVersion: 'IPv4'
    tier: 'Regional'
    availabilityZones: [
      1
      2
      3
    ]
  }
}
```
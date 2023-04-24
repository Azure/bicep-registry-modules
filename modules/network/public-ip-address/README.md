# Public Ip Address

Bicep Module for creating Public Ip Address

## Description

Public IP addresses allow Internet resources to communicate inbound to Azure resources. Public IP addresses enable Azure resources to communicate to Internet and public-facing Azure services. The address is dedicated to the resource, until it's unassigned by you. A resource without a public IP assigned can communicate outbound. Azure dynamically assigns an available IP address that isn't dedicated to the resource.
[public-ip-address](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses)
[public-ip-address-bicep](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/publicipaddresses?pivots=deployment-language-bicep)

## Parameters

| Name                       | Type     | Required | Description                                                                                                                                                                                                                                                                                                   |
| :------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `name`                     | `string` | Yes      | Required. Specifies the name of the publicIPAddress.                                                                                                                                                                                                                                                          |
| `location`                 | `string` | Yes      | Required. Specifies the Azure location where the publicIPAddress should be created.                                                                                                                                                                                                                           |
| `tags`                     | `object` | No       | Optional. Tags to assign to the Azure Resource(s).                                                                                                                                                                                                                                                            |
| `skuName`                  | `string` | No       | Optional. Name of a public IP address SKU.                                                                                                                                                                                                                                                                    |
| `skuTier`                  | `string` | No       | Optional. Tier of a public IP address SKU.                                                                                                                                                                                                                                                                    |
| `availabilityZones`        | `array`  | No       | Optional. A list of availability zones denoting the IP allocated for the resource needs to come from.                                                                                                                                                                                                         |
| `publicIPAddressVersion`   | `string` | No       | Optional. IP address version.                                                                                                                                                                                                                                                                                 |
| `publicIPAllocationMethod` | `string` | No       | Optional. IP address allocation method.                                                                                                                                                                                                                                                                       |
| `deleteOption`             | `string` | No       | Optional. Specify what happens to the public IP address when the VM using it is deleted.                                                                                                                                                                                                                      |
| `publicIPPrefixId`         | `string` | No       | Optional. Reference to another subresource ID                                                                                                                                                                                                                                                                 |
| `domainNameLabel`          | `string` | Yes      | Required. The domain name label. The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. |
| `idleTimeoutInMinutes`     | `int`    | No       | Optional. The idle timeout of the public IP address.                                                                                                                                                                                                                                                          |

## Outputs

| Name              | Type   | Description                                          |
| :---------------- | :----: | :--------------------------------------------------- |
| id                | string | Get id for publicIPAddress                           |
| name              | string | Get name for publicIPAddress                         |
| ipAddress         | string | Get ipAddress property from publicIPAddress resource |
| resourceGroupName | string | Get resourceGroup name for publicIPAddress           |

## Examples

### Example 1

```bicep
param location string = 'eastus'

module publicIp1 'br/public:network/public-ip-address:1.0.1' = {
  name: 'publicIp1'
  params: {
    location: location
    name: 'publicIp1'
  }
}
```

### Example 2

```bicep
param location string = 'eastus'

module publicIp2 'br/public:network/public-ip-address:1.0.1' = {
  name: 'publicIp2'
  params: {
    domainNameLabel: 'publicIp2'
    location: location
    name: 'publicIp2'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    skuName: 'Standard'
    skuTier: 'Regional'
  }
}
```
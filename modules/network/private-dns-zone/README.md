<h1 style="color: steelblue;">⚠️ Upcoming changes ⚠️</h1>

This module has been replaced by the following equivalent module in Azure Verified Modules (AVM): [avm/res/network/private-dns-zone](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/private-dns-zone).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-upcoming-changes-%EF%B8%8F).

# Private DNS Zone

A bicep module for simplified deployment for Private DNS Zones and available configuration options.

## Description

Azure Private DNS provides a reliable, secure DNS service to manage and resolve domain names in a virtual network without the need to add a custom DNS solution. By using private DNS zones, you can use your own custom domain names rather than the Azure-provided names available today.

## Parameters

| Name                  | Type     | Required | Description                                                              |
| :-------------------- | :------: | :------: | :----------------------------------------------------------------------- |
| `name`                | `string` | Yes      | Required. Name of privateDNSZone, but be in DNS format like example.test |
| `tags`                | `object` | No       | Optional. Tags for the resources.                                        |
| `location`            | `string` | Yes      | Required. The location of the PrivateDNSZone. Should be global.          |
| `virtualNetworkLinks` | `array`  | No       | Optional. Adding virtual network links to the PrivateDNSZone.            |
| `aRecords`            | `array`  | No       | Optional. Specifies the "A" Records array                                |
| `cnameRecords`        | `array`  | No       | Optional. Specifies the "CNAME" Records array                            |

## Outputs

| Name   | Type     | Description             |
| :----- | :------: | :---------------------- |
| `id`   | `string` | Get privateDnsZone ID   |
| `name` | `string` | Get privateDnsZone name |

## Examples

### Example 1

```
module dnsZone 'br/public:network/private-dns-zone:1.0.1' = {
  name:  'test0-${uniqueString(name)}'
  params: {
    name: 'testweb.nuannet'
    tags: tags
    location: 'global'
    virtualNetworkLinks: [
      {
        name: 'link${replace(name, '-', '')}'
        virtualNetworkId: prereq.outputs.vnetId
        location: 'global'
        registrationEnabled: true
        tags: tags
      }
    ]
    aRecords: [
      {
        name: 'arecord1' //(The name of the DNS record to be created.  The name is relative to the zone, not the FQDN)
        TTL: 3600 //(The TTL (time-to-live) of the records in the record set. type is 'int')
        ipv4Addresses: [
          //(The list of A records in the ipv4Addresses.)
          '1.0.0.6'
        ]
      }
      {
        name: 'arecord2'
        TTL: 3600
        ipv4Addresses: [
          '1.0.0.1'
          '1.0.0.2'
        ]
      }
    ]
    cnameRecords: [
      {
        name: 'cname1'
        TTL: 3600
        cname: 'nuaninc.test1.com'
      }
      {
        name: 'cname2'
        TTL: 3600
        cname: 'nuaninc.test2.com'
      }
      {
        name: 'cname3'
        TTL: 3600
        cname: 'nuaninc.test3.com'
      }
    ]
  }
}
```

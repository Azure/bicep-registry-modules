# Azure DNS zones

Azure DNS is a hosting service for DNS domains that provides name resolution.

## Description

Azure DNS is a hosting service for DNS domains that provides name resolution by using Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records by using the same credentials, APIs, tools, and billing as your other Azure services.

A DNS zone is used to host the DNS records for a particular domain. To start hosting your domain in Azure DNS, you need to create a DNS zone for that domain name. Each DNS record for your domain is then created inside this DNS zone.

For example, if you have a domain ‘contoso.com’, you can create a DNS zone for ‘contoso.com’ in Azure DNS. Then, you can create DNS records such as ‘mail.contoso.com’ (for a mail server) and ‘www.contoso.com’ (for a web site) inside this DNS zone.

Reference : https://learn.microsoft.com/en-us/azure/dns/dns-overview

## Parameters

| Name           | Type     | Required | Description                                                               |
| :------------- | :------: | :------: | :------------------------------------------------------------------------ |
| `prefix`       | `string` | No       | Prefix of DNS Resource Name. This param is ignored when name is provided. |
| `name`         | `string` | No       | Required. Specifies the resource name                                     |
| `tags`         | `object` | No       | Optional. Tags to assign to the resources used in dns-zones.              |
| `zoneType`     | `string` | No       | Optional. The type of this DNS zone, default set to Public.               |
| `aRecords`     | `array`  | No       | Optional. Specifies the "A" Records array                                 |
| `cnameRecords` | `array`  | No       | Optional. Specifies the "CNAME" Records array                             |
| `AAAARecords`  | `array`  | No       | Optional. Specifies the "AAAA" Records array                              |

## Outputs

| Name        | Type   | Description                         |
| :---------- | :----: | :---------------------------------- |
| id          | string | Id for DNS zone                     |
| nameServers | array  | The name servers for this DNS zone. |

## Examples

### Example 1

```bicep
module test01 'br/public:network/dns-zone:1.0.1' = {
  name: '${name}-minimal'
  params: {
    name: 'myendpoint1.example.com'
  }
}
```

### Example 2

```bicep
module test02 'br/public:network/dns-zone:1.0.1' = {
  name: '${name}-simple'
  params: {
    name: 'myendpoint2.example.com'
    zoneType: 'Public'
    tags: tags
    aRecords: [
      {
        name: 'aRecord1'
        aliasRecordSet: true
        targetResource: prereq.outputs.trafficManagerId
      }
      {
        name: 'aRecord2'
        ttl: 3600
        aliasRecordSet: false
        aRecord: [
          {
            ipv4Address: '1.0.0.9'
          }
        ]
      }
      {
        aliasRecordSet: true
        targetResource: prereq.outputs.trafficManagerId
      }
    ]
    cnameRecords: [
      {
        name: 'cNameRecord1'
        TTL: 3600
        cname: 'myendpoint2.example.com'
        aliasRecordSet: false
      }
    ]
    AAAARecords: [
      {
        name: 'AAAA1'
        TTL: 300
        aliasRecordSet: false
        aaaaRecord: [
          {
            ipv6Address: '2001:db8:3333:4444:5555:6666:7777:8888'
          }
        ]
      }
    ]
  }
}
```
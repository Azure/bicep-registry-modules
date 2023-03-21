@description('An existing DNS Zone resource name')
param dnsZoneName string

@description('Name of CNAME record to add to dnsZoneName')
param recordName string

@description('Target FQDN for CNAME record')
param targetFQDN string

resource zone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: dnsZoneName
}

resource cnameRecord 'Microsoft.Network/dnsZones/CNAME@2018-05-01' = {
  parent: zone
  name: recordName
  properties: {
    TTL: 3600
    CNAMERecord: {
      cname: targetFQDN
    }
  }
}

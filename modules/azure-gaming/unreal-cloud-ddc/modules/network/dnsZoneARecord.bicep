@description('An existing DNS Zone resource name')
param dnsZoneName string

@description('Name of A record to add to dnsZoneName')
param recordName string

@description('IP Address to add as A record')
param ipAddress string

resource zone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: dnsZoneName
}

resource aRecord 'Microsoft.Network/dnsZones/A@2018-05-01' = {
  parent: zone
  name: recordName
  properties: {
    TTL: 3600
    ARecords: [
      {
        ipv4Address: ipAddress
      }
    ]
  }
}

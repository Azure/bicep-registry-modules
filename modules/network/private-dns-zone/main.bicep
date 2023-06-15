@description('Required. Name of privateDNSZone, but be in DNS format like example.test')
param name string

@description('Optional. Tags for the resources.')
param tags object = {}

@description('Required. The location of the PrivateDNSZone. Should be global.')
param location string

@description('Optional. Adding virtual network links to the PrivateDNSZone.')
param virtualNetworkLinks array = []
/*** example
    virtualNetworkLinks: [
      {
        name: 'virtualNetworkLink-${uniqueString(resourceGroup.id)}'
        virtualNetworkId: virutalNetwork.outputs.vnetId
        location: deployment().location
        registrationEnabled: true
        tags: tags
      }
    ]
***/

@description('Optional. Specifies the "A" Records array')
param aRecords array = []
/*
Example:
aRecords:  [
  {
    name: 'arecord1'      //(The name of the DNS record to be created.  The name is relative to the zone, not the FQDN.)
    TTL: 3600           //(The TTL (time-to-live) of the records in the record set. type is 'int')
    ipv4Addresses: [    //(The list of A records in the ipv4Addresses.)
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
*/

@description('Optional. Specifies the "CNAME" Records array')
param cnameRecords array = []
/*
Example:
cnameRecords : [
  {
    name: 'cname1'
    TTL: 3600
    cname: 'test1.com'
  }
  {
    name: 'cname2'
    TTL: 3600
    cname: 'test2.com'
  }
  {
    name: 'cname3'
    TTL: 3600
    cname: 'test3.com'
  }
]
*/

var virtualNetworkLinksArray = [for virtualNetworkLink in virtualNetworkLinks: {
  name: contains(virtualNetworkLink, 'name') ? virtualNetworkLink.name : last(split(virtualNetworkLink.virtualNetworkId, '/'))
  virtualNetworkId: virtualNetworkLink.virtualNetworkId
  location: contains(virtualNetworkLink, 'location') ? virtualNetworkLink.location : 'global'
  registrationEnabled: contains(virtualNetworkLink, 'registrationEnabled') ? virtualNetworkLink.registrationEnabled : false
  tags: contains(virtualNetworkLink, 'tags') ? virtualNetworkLink.tags : {}
}]

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: name
  tags: tags
  location: location
}

resource virtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = [for virtualNetworkLink in virtualNetworkLinksArray: {
  name: virtualNetworkLink.name
  tags: virtualNetworkLink.tags
  location: virtualNetworkLink.location

  properties: {
    registrationEnabled: virtualNetworkLink.registrationEnabled
    virtualNetwork: {
      id: virtualNetworkLink.virtualNetworkId
    }
  }
  parent: privateDnsZone
}]

resource A 'Microsoft.Network/privateDnsZones/A@2020-06-01' = [for record in aRecords: {
  name: record.name
  parent: privateDnsZone
  properties: {
    aRecords: [for ipv4Address in record.ipv4Addresses: {
      ipv4Address: ipv4Address
    }]
    ttl: record.ttl
  }
}]

resource C 'Microsoft.Network/privateDnsZones/CNAME@2020-06-01' = [for cset in cnameRecords: {
  name: cset.name
  parent: privateDnsZone
  properties: {
    cnameRecord: {
      cname: cset.cname
    }
    ttl: cset.ttl
  }
}]

@description('Get privateDnsZone ID')
output id string = privateDnsZone.id

@description('Get privateDnsZone name')
output name string = privateDnsZone.name

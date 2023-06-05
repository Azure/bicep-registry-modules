@description('Prefix of DNS Resource Name. This param is ignored when name is provided.')
param prefix string = 'azure-'

@description('Required. Specifies the resource name')
param name string = '${prefix}${uniqueString(resourceGroup().id, subscription().id)}'

@description('Optional. Tags to assign to the resources used in dns-zones.')
param tags object = {}

@allowed([
  'Public'
  'Private'
])
@description('Optional. The type of this DNS zone, default set to Public.')
param zoneType string = 'Public'

@description('Optional. Specifies the "A" Records array')
param aRecords array = []

@description('Optional. Specifies the "CNAME" Records array')
param cnameRecords array = []

@description('Optional. Specifies the "AAAA" Records array')
param AAAARecords array = []

resource dnszones 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: name
  location: 'global'
  tags: tags
  properties: {
    zoneType: zoneType
  }
}

@batchSize(1)
resource A 'Microsoft.Network/dnsZones/A@2018-05-01' = [for record in aRecords: {
  name: record.name
  parent: dnszones
  properties: {
    ARecords: (record.aliasRecordSet) ? null : record.aRecord
    TTL: record.aliasRecordSet ? null : record.ttl
    targetResource: record.aliasRecordSet ? {
      id: record.targetResource
    } : {}
  }
}]

@batchSize(1)
resource CName 'Microsoft.Network/dnsZones/CNAME@2018-05-01' = [for record in cnameRecords: {
  name: record.name
  parent: dnszones
  properties: {
    CNAMERecord: record.aliasRecordSet ? null : {
      cname: record.cname
    }
    TTL: record.ttl
    targetResource: record.aliasRecordSet ? {
      id: record.targetResource
    } : {}
  }
}]

@batchSize(1)
resource AAAA 'Microsoft.Network/dnsZones/AAAA@2018-05-01' = [for record in AAAARecords: {
  name: record.name
  parent: dnszones
  properties: {
    AAAARecords: (record.aliasRecordSet) ? null : record.aaaaRecord
    TTL: record.ttl
    targetResource: record.aliasRecordSet ? {
      id: record.targetResource
    } : {}
  }
}]

@description('Id for DNS zone')
output id string = dnszones.id

@description('The name servers for this DNS zone.')
output nameServers array = dnszones.properties.nameServers

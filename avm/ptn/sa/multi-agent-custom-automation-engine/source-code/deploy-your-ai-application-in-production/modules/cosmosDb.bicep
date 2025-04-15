@minLength(3)
param name string

@description('Optional list of Cosmos DB databases to deploy')
param databases sqlDatabaseType[] = []

param location string = resourceGroup().location

@description('Optional tags to apply to the resources')
param tags object = {}

@minLength(1)
param virtualNetworkResourceId string

@minLength(1)
param virtualNetworkSubnetResourceId string

@minLength(1)
param storageAccountResourceId string

@minLength(1)
param logAnalyticsWorkspaceResourceId string

module privateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
  name: 'cosmosPrivateDnsZoneDeployment'
  params: {
    name: 'privatelink.documents.azure.com'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetworkResourceId
      }
    ]
    tags: tags
  }
}

module cosmosDb 'br/public:avm/res/document-db/database-account:0.11.0' = {
  name: 'cosmosDbAccountDeployment'
  params: {
    name: name
    automaticFailover: true
    diagnosticSettings: [
      {
        storageAccountResourceId: storageAccountResourceId
        workspaceResourceId: logAnalyticsWorkspaceResourceId
      }
    ]
    disableKeyBasedMetadataWriteAccess: true
    disableLocalAuth: true
    location: location
    minimumTlsVersion: 'Tls12'
    defaultConsistencyLevel: 'Session'
    networkRestrictions: {
      networkAclBypass: 'None'
      publicNetworkAccess: 'Disabled'
    }
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: privateDnsZone.outputs.resourceId
            }
          ]
        }
        service: 'Sql'
        subnetResourceId: virtualNetworkSubnetResourceId
      }
    ]
    sqlDatabases: databases
    tags: tags
  }
}

import { sqlDatabaseType } from 'customTypes.bicep'

output name string = cosmosDb.outputs.name
output resourceId string = cosmosDb.outputs.resourceId
output endpoint string = cosmosDb.outputs.endpoint


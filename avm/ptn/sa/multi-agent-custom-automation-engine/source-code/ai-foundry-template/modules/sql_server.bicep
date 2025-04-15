@minLength(3)
param name string

@description('Optional list of SQL databases to deploy')
param databases databasePropertyType[] = []

param location string = resourceGroup().location

@description('Optional tags to apply to the resources')
param tags object = {}

@minLength(1)
param virtualNetworkResourceId string

@minLength(1)
param virtualNetworkSubnetResourceId string

@minLength(1)
param managedIdentityResourceId string

@minLength(1)
param adminUsername string

@minLength(1)
@secure()
param adminPassword string

@minLength(1)
param keyVaultUri string

module privateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
  name: 'sqlServerPrivateDnsZoneDeployment'
  params: {
    name: 'privatelink${environment().suffixes.sqlServerHostname}'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetworkResourceId
      }
    ]
    tags: tags
  }
}

module sqlserver 'br/public:avm/res/sql/server:0.12.3' = {
  name: 'sqlServerDeployment'
  params: {
    name: name
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
    databases: databases
    location: location
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        managedIdentityResourceId
      ]
    }
    primaryUserAssignedIdentityId: managedIdentityResourceId
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: privateDnsZone.outputs.resourceId
            }
          ]
        }
        service: 'sqlServer'
        subnetResourceId: virtualNetworkSubnetResourceId
      }
    ]
    restrictOutboundNetworkAccess: 'Disabled'
    tags: tags
  }
}

import { databasePropertyType } from 'custom_types.bicep'

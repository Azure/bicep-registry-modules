@description('Name of the SQL Server instance.')
param name string

@description('Specifies the location for all the Azure resources.')
param location string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Username for the SQL Server administrator.')
param administratorLogin string

@secure()
@description('Password for the SQL Server administrator.')
param administratorLoginPassword string

@description('Resource ID of the virtual network to link the private DNS zones.')
param virtualNetworkResourceId string

@description('Resource ID of the subnet for the private endpoint.')
param virtualNetworkSubnetResourceId string

@description('Specifies whether network isolation is enabled. This will create a private endpoint for the SQL Server instance and link the private DNS zone.')
param networkIsolation bool = true

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. List of SQL Server databases to deploy.')
param databases databasePropertyType[]?

module privateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.0' = if (networkIsolation) {
  name: 'private-dns-sql-deployment'
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

var nameFormatted = toLower(name)

module sqlServer 'br/public:avm/res/sql/server:0.15.0' = {
  name: take('${nameFormatted}-sqlserver-deployment', 64)
  dependsOn: [privateDnsZone] // required due to optional flags that could change dependency
  params: {
    name: nameFormatted
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    databases: databases
    location: location
    managedIdentities: {
      systemAssigned: true
    }
    restrictOutboundNetworkAccess: 'Disabled'
    roleAssignments: roleAssignments
    privateEndpoints: networkIsolation ? [
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
    ] : []
    tags: tags
  }
}

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
import { databasePropertyType } from 'customTypes.bicep'

output resourceId string = sqlServer.outputs.resourceId
output name string = sqlServer.outputs.name

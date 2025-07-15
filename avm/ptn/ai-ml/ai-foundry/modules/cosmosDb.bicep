@maxLength(44)
@description('Name of the Cosmos DB Account.')
param name string

@description('Specifies the location for all the Azure resources.')
param location string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { resourcePrivateNetworkingType } from 'customTypes.bicep'
@description('Optional. Values to establish private networking for the Cosmos DB Account. If not provided, public access will be enabled.')
param privateNetworking resourcePrivateNetworkingType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var networkIsolation = privateNetworking != null && !empty(privateNetworking) && !empty(privateNetworking!.privateDnsZoneId) && !empty(privateNetworking!.privateEndpointSubnetId)

module cosmosDb 'br/public:avm/res/document-db/database-account:0.15.0' = {
  name: take('${name}-cosmosdb-deployment', 64)
  params: {
    name: name
    enableTelemetry: enableTelemetry
    automaticFailover: true
    disableKeyBasedMetadataWriteAccess: true
    disableLocalAuthentication: true
    location: location
    minimumTlsVersion: 'Tls12'
    defaultConsistencyLevel: 'Session'
    networkRestrictions: {
      networkAclBypass: 'AzureServices'
      publicNetworkAccess: networkIsolation ? 'Disabled' : 'Enabled'
    }
    privateEndpoints: networkIsolation
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: privateNetworking!.privateDnsZoneId
                }
              ]
            }
            service: 'Sql'
            subnetResourceId: privateNetworking!.privateEndpointSubnetId
          }
        ]
      : []
    roleAssignments: roleAssignments
    tags: tags
  }
}

@description('Resource ID of the Cosmos DB Account.')
output resourceId string = cosmosDb.outputs.resourceId

@description('Name of the Cosmos DB Account.')
output name string = cosmosDb.outputs.name

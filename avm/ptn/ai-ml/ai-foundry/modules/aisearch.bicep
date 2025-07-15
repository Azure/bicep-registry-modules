@minLength(2)
@maxLength(60)
@description('Name of the AI Search resource.')
param name string

@description('Specifies the location for all the Azure resources.')
param location string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { resourcePrivateNetworkingType } from 'customTypes.bicep'
@description('Optional. Values to establish private networking for the AI Search resource. If not provided, public access will be enabled.')
param privateNetworking resourcePrivateNetworkingType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var networkIsolation = privateNetworking != null && !empty(privateNetworking) && !empty(privateNetworking!.privateDnsZoneId) && !empty(privateNetworking!.privateEndpointSubnetId)

module aiSearch 'br/public:avm/res/search/search-service:0.11.0' = {
  name: take('${name}-search-services-deployment', 64)
  params: {
    name: name
    location: location
    enableTelemetry: enableTelemetry
    cmkEnforcement: 'Disabled'
    managedIdentities: {
      systemAssigned: true
    }
    publicNetworkAccess: networkIsolation ? 'Disabled' : 'Enabled'
    disableLocalAuth: networkIsolation
    sku: 'standard'
    partitionCount: 1
    replicaCount: 3
    roleAssignments: roleAssignments
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
            subnetResourceId: privateNetworking!.privateEndpointSubnetId
          }
        ]
      : []
    tags: tags
  }
}

@description('Resource ID of the AI Search resource.')
output resourceId string = aiSearch.outputs.resourceId

@description('Name of the AI Search resource.')
output name string = aiSearch.outputs.name

@description('System Assigned Identity principal ID of the AI Search resource.')
output systemAssignedMIPrincipalId string = aiSearch.outputs.systemAssignedMIPrincipalId!

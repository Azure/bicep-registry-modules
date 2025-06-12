@description('Name of the AI Search resource.')
param name string

@description('Specifies the location for all the Azure resources.')
param location string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Resource ID of the virtual network to link the private DNS zones.')
param virtualNetworkResourceId string

@description('Resource ID of the subnet for the private endpoint.')
param virtualNetworkSubnetResourceId string

@description('Resource ID of the Log Analytics workspace to use for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string

@description('Specifies whether network isolation is enabled. This will create a private endpoint for the AI Search resource and link the private DNS zone.')
param networkIsolation bool = true

@description('Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources. This defaults to the deploying user.')
param userObjectId string

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

module privateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (networkIsolation) {
  name: 'private-dns-search-deployment'
  params: {
    name: 'privatelink.search.windows.net'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetworkResourceId
      }
    ]
    tags: tags
  }
}

var nameFormatted = take(toLower(name), 60)

module aiSearch 'br/public:avm/res/search/search-service:0.10.0' = {
  name: take('${nameFormatted}-search-services-deployment', 64)
  dependsOn: [privateDnsZone] // required due to optional flags that could change dependency
  params: {
    name: nameFormatted
    location: location
    cmkEnforcement: 'Disabled'
    managedIdentities: {
      systemAssigned: true
    }
    publicNetworkAccess: networkIsolation ? 'Disabled' : 'Enabled'
    disableLocalAuth: true
    sku: 'standard'
    partitionCount: 1
    replicaCount: 3
    roleAssignments: empty(userObjectId)
      ? []
      : [
          {
            principalId: userObjectId
            principalType: 'User'
            roleDefinitionIdOrName: 'Search Index Data Contributor'
          }
          {
            principalId: userObjectId
            principalType: 'User'
            roleDefinitionIdOrName: 'Search Index Data Reader'
          }
        ]
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspaceResourceId
      }
    ]
    privateEndpoints: networkIsolation
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: privateDnsZone.outputs.resourceId
                }
              ]
            }
            subnetResourceId: virtualNetworkSubnetResourceId
          }
        ]
      : []
    tags: tags
  }
}

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'

output searchResourceId string = aiSearch.outputs.resourceId
output searchName string = aiSearch.outputs.name
output systemAssignedMIPrincipalId string = aiSearch.outputs.?systemAssignedMIPrincipalId ?? ''

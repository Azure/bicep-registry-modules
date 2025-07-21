@minLength(2)
@maxLength(60)
@description('Name of the AI Search resource. This is ignored if existingResourceId is provided.')
param name string

@description('Optional. Resource Id of an existing AI Search resource. If provided, the module will not create a new AI Search resource but will use the existing one.')
param existingResourceId string?

@description('Optional. Specifies the location for all the Azure resources. Defaults to the location of the resource group.')
param location string = resourceGroup().location

@description('Optional. Tags to be applied to the resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { resourcePrivateNetworkingType } from 'localSharedTypes.bicep'
@description('Optional. Values to establish private networking for the AI Search resource. If not provided, public access will be enabled.')
param privateNetworking resourcePrivateNetworkingType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

module parsedResourceId 'parseResourceId.bicep' = if (!empty(existingResourceId)) {
  name: take('${name}-search-parse-resource-id', 64)
  params: {
    resourceIdOrName: existingResourceId!
  }
}

resource existingAiSearch 'Microsoft.Search/searchServices@2025-05-01' existing = if (!empty(existingResourceId)) {
  #disable-next-line no-unnecessary-dependson
  dependsOn: [parsedResourceId]
  name: parsedResourceId!.outputs.name
  scope: resourceGroup(parsedResourceId!.outputs.subscriptionId, parsedResourceId!.outputs.resourceGroupName)
}

var networkIsolation = !empty(privateNetworking) && !empty(privateNetworking!.privateDnsZoneId) && !empty(privateNetworking!.privateEndpointSubnetId)

module aiSearch 'br/public:avm/res/search/search-service:0.11.0' = if (empty(existingResourceId)) {
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
output resourceId string = empty(existingResourceId) ? aiSearch!.outputs.resourceId : existingAiSearch.id

@description('Name of the AI Search resource.')
output name string = empty(existingResourceId) ? aiSearch!.outputs.name : existingAiSearch.name

@description('Location of the AI Search resource.')
output location string = empty(existingResourceId) ? aiSearch!.outputs.location : existingAiSearch!.location

@description('Endpoint/target for the AI Search resources.')
output endpoint string = empty(existingResourceId)
  ? aiSearch!.outputs.endpoint
  : 'https://${existingAiSearch.name}.search.windows.net/'

@description('System Assigned Identity principal ID of the AI Search resource.')
output systemAssignedMIPrincipalId string = empty(existingResourceId)
  ? existingAiSearch!.identity.principalId
  : aiSearch!.outputs.systemAssignedMIPrincipalId!

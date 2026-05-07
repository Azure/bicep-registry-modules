metadata name = 'Container Registry Module'
// AVM-compliant Azure Container Registry deployment

@description('The name of the Azure Container Registry')
param acrName string

@description('The location of the Azure Container Registry')
param location string

@description('SKU for the Azure Container Registry')
param acrSku string = 'Basic'

@description('Public network access setting for the Azure Container Registry')
param publicNetworkAccess string = 'Enabled'

@description('Zone redundancy setting for the Azure Container Registry')
param zoneRedundancy string = 'Disabled'

@description('Optional. The default action of allow or deny when no other rules match. Note, requires the \'acrSku\' to be \'Premium\'.')
@allowed([
  'Allow'
  'Deny'
])
param networkRuleSetDefaultAction string = 'Allow'

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Tags to be applied to the Container Registry')
param tags object = {}

import { replicationType } from 'br/public:avm/res/container-registry/registry:0.12.1'
@description('Optional. All replications to create.')
param replications replicationType[]?

module avmContainerRegistry 'br/public:avm/res/container-registry/registry:0.12.1' = {
  name: acrName
  params: {
    name: acrName
    location: location
    acrSku: acrSku
    publicNetworkAccess: publicNetworkAccess
    zoneRedundancy: zoneRedundancy
    networkRuleSetDefaultAction: networkRuleSetDefaultAction
    roleAssignments: roleAssignments
    replications: replications
    tags: tags
  }
}

output name string = avmContainerRegistry.outputs.name
output resourceId string = avmContainerRegistry.outputs.resourceId
output loginServer string = avmContainerRegistry.outputs.loginServer

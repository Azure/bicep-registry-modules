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

@description('The default action of the network rule set. Note: [Deny] requires the Premium SKU.')
param networkRuleSetDefaultAction string = 'Allow'

@description('Zone redundancy setting for the Azure Container Registry')
param zoneRedundancy string = 'Disabled'

@description('Optional. Geo-replications to create for the Azure Container Registry. Requires the Premium SKU.')
param replications array = []

@description('Optional. Private endpoints to create for the Azure Container Registry. Requires the Premium SKU.')
param privateEndpoints array = []

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Tags to be applied to the Container Registry')
param tags object = {}

module avmContainerRegistry 'br/public:avm/res/container-registry/registry:0.13.0' = {
  name: acrName
  params: {
    name: acrName
    location: location
    acrSku: acrSku
    publicNetworkAccess: publicNetworkAccess
    // v0.12.x emits networkRuleSet when default action is 'Deny', which the Standard SKU rejects (NetworkRuleNotSupported); callers must pass 'Deny' only with the Premium SKU.
    networkRuleSetDefaultAction: networkRuleSetDefaultAction
    zoneRedundancy: zoneRedundancy
    replications: replications
    privateEndpoints: privateEndpoints
    roleAssignments: roleAssignments
    tags: tags
  }
}

output name string = avmContainerRegistry.outputs.name
output resourceId string = avmContainerRegistry.outputs.resourceId
output loginServer string = avmContainerRegistry.outputs.loginServer

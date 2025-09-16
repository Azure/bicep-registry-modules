metadata name = 'Container Registry Module'
// AVM-compliant Azure Container Registry deployment

@description('Required. The name of the Azure Container Registry')
param acrName string

@description('Optional. The location of the Azure Container Registry')
param location string = resourceGroup().location

@description('Optional. SKU for the Azure Container Registry')
param acrSku string = 'Basic'

@description('Optional. Public network access setting for the Azure Container Registry')
param publicNetworkAccess string = 'Enabled'

@description('Optional. Zone redundancy setting for the Azure Container Registry')
param zoneRedundancy string = 'Disabled'

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags to be applied to the Container Registry')
param tags object = {}

module avmContainerRegistry 'br/public:avm/res/container-registry/registry:0.9.1' = {
  name: acrName
  params: {
    name: acrName
    location: location
    acrSku: acrSku
    publicNetworkAccess: publicNetworkAccess
    zoneRedundancy: zoneRedundancy
    roleAssignments: roleAssignments
    tags: tags
  }
}

output name string = avmContainerRegistry.outputs.name
output resourceId string = avmContainerRegistry.outputs.resourceId
output loginServer string = avmContainerRegistry.outputs.loginServer

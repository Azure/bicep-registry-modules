@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Proximity Placement Group to create.')
param proximityPlacementGroupName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource proximityPlacementGroup 'Microsoft.Compute/proximityPlacementGroups@2022-03-01' = {
  name: proximityPlacementGroupName
  location: location
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Proximity Placement Group.')
output proximityPlacementGroupResourceId string = proximityPlacementGroup.id

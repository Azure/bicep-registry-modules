@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Proximity Placement Group to create.')
param proximityPlacementGroupName string

resource proximityPlacementGroup 'Microsoft.Compute/proximityPlacementGroups@2022-03-01' = {
    name: proximityPlacementGroupName
    location: location
}

@description('The resource ID of the created Proximity Placement Group.')
output proximityPlacementGroupResourceId string = proximityPlacementGroup.id

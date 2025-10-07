@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Public IP to create.')
param existingPipName string

resource existingPip 'Microsoft.Network/publicIPAddresses@2024-10-01' = {
  name: existingPipName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
}

@description('The resource ID of the existing Public IP.')
output existingPipResourceId string = existingPip.id

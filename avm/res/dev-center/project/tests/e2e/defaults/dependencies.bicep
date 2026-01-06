@description('Required. The name of the Dev Center.')
param devCenterName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource devCenter 'Microsoft.DevCenter/devcenters@2025-02-01' = {
  name: devCenterName
  location: location
}

@description('The resource ID of the created DevCenter.')
output devCenterResourceId string = devCenter.id

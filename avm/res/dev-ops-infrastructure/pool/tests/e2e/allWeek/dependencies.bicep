@description('Required. The name of the Dev Center.')
param devCenterName string

@description('Required. The name of the Dev Center Project.')
param devCenterProjectName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource devCenter 'Microsoft.DevCenter/devcenters@2024-02-01' = {
  name: devCenterName
  location: location
}

resource devCenterProject 'Microsoft.DevCenter/projects@2024-02-01' = {
  name: devCenterProjectName
  location: location
  properties: {
    devCenterId: devCenter.id
  }
}

@description('The resource ID of the created DevCenter.')
output devCenterResourceId string = devCenter.id

@description('The resource ID of the created DevCenter Project.')
output devCenterProjectResourceId string = devCenterProject.id

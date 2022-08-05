param location string = resourceGroup().location
param vmName string = 'bicep'
param adminName string = 'dcibadmin'
@secure()
param adminPass string = newGuid()

@description('The base URI where artifacts required by this template are located including a trailing \'/\'')
param _artifactsLocation string = deployment().properties.templateLink.uri

@description('The sasToken required to access _artifactsLocation.')
@secure()
param _artifactsLocationSasToken string = ''

var engines = [
  'no_engine'
  'ue_4_27_2'
  'ue_5_0_1'
]

@batchSize(1)
module win10 '../main.bicep' = [for engine in engines: {
  name: 'win10_${engine}'
  params: {
    location : location
    vmName   : vmName
    adminName: adminName
    adminPass: adminPass
    osType: 'win10'
    gameEngine: engine
    _artifactsLocation: _artifactsLocation
  }
}]

@batchSize(1)
module ws2019 '../main.bicep' = [for engine in engines: {
  name: 'ws2019_${engine}'
  params: {
    location : location
    vmName   : vmName
    adminName: adminName
    adminPass: adminPass
    osType: 'ws2019'
    gameEngine: engine
    _artifactsLocationSasToken: _artifactsLocationSasToken
  }
}]

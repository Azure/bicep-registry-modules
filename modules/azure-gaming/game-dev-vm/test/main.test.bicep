param location string = resourceGroup().location
param vmName string = 'bicep'
param adminName string = 'dcibadmin'
param vmSize string = 'Standard_D4s_v3'

@secure()
param adminPass string = newGuid()

var osType = 'win11'
var engines = [
  'no_engine'
]

@batchSize(1)
module win10 '../main.bicep' = [for engine in engines: {
  name: 'win11_${engine}'
  params: {
    location  : location
    vmName    : vmName
    adminName : adminName
    adminPass : adminPass
    osType    : osType
    gameEngine: engine
    vmSize    : vmSize
  }
}]

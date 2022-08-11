param location string = resourceGroup().location
param vmName string = 'bicep'
param adminName string = 'dcibadmin'
param vmSize string = 'Standard_D4s_v3'

@secure()
param adminPass string = newGuid()

var engines = [
  'ue_4_27_2'
]

@batchSize(1)
module win10 '../main.bicep' = [for engine in engines: {
  name: 'win10_${engine}'
  params: {
    location  : location
    vmName    : vmName
    adminName : adminName
    adminPass : adminPass
    osType    : 'win10'
    gameEngine: engine
    vmSize    : vmSize
  }
}]

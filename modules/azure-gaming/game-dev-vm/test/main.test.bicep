param location string = resourceGroup().location
param vmName string = 'bicep'
param adminName string = 'dcibadmin'
param vmSize string = 'Standard_D4s_v3'

@secure()
param adminPass string = newGuid()

var engines = [
  // 'no_engine'
  'ue_4_27_2'
  // 'ue_5_0_1'
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

// @batchSize(1)
// module ws2019 '../main.bicep' = [for engine in engines: {
//   name: 'ws2019_${engine}'
//   params: {
//     location  : location
//     vmName    : vmName
//     adminName : adminName
//     adminPass : adminPass
//     osType    : 'ws2019'
//     gameEngine: engine
//     vmSize    : vmSize
//   }
// }]

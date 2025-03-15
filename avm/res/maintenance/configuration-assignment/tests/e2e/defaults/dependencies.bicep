// @description('Optional. The location to deploy to.')
// param location string = resourceGroup().location

// @description('Required. The name of the Maintenance Configuration to create.')
// param maintenanceConfigurationName string

// @description('Required. The name of the Virtual Network to create.')
// param virtualNetworkName string

// @description('Required. The name of the Virtual Machine to create.')
// param virtualMachineName string

// @description('Optional. The password to leverage for the VM login.')
// @secure()
// param password string = newGuid()

// var addressPrefix = '10.0.0.0/16'

// resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
//   name: virtualNetworkName
//   location: location
//   properties: {
//     addressSpace: {
//       addressPrefixes: [
//         addressPrefix
//       ]
//     }
//     subnets: [
//       {
//         name: 'defaultSubnet'
//         properties: {
//           addressPrefix: cidrSubnet(addressPrefix, 16, 0)
//         }
//       }
//     ]
//   }
// }

// resource networkInterface 'Microsoft.Network/networkInterfaces@2023-04-01' = {
//   name: '${virtualMachineName}-nic'
//   location: location
//   properties: {
//     ipConfigurations: [
//       {
//         name: 'ipconfig01'
//         properties: {
//           subnet: {
//             id: virtualNetwork.properties.subnets[0].id
//           }
//         }
//       }
//     ]
//   }
// }

// resource maintenanceConfiguration 'Microsoft.Maintenance/maintenanceConfigurations@2023-10-01-preview' = {
//   name: maintenanceConfigurationName
//   location: location
//   properties: {
//     extensionProperties: {
//       InGuestPatchMode: 'User'
//     }
//     maintenanceScope: 'InGuestPatch'
//     maintenanceWindow: {
//       startDateTime: '2025-01-09 00:00'
//       expirationDateTime: '2026-01-08 00:00'
//       duration: '03:00'
//       timeZone: 'UTC'
//       recurEvery: 'Week'
//     }
//     visibility: 'Custom'
//     installPatches: {
//       rebootSetting: 'AlwaysReboot'
//       windowsParameters: {
//         kbNumbersToExclude: [
//           'KB123456'
//           'KB3654321'
//         ]
//         kbNumbersToInclude: [
//           'KB111111'
//           'KB222222'
//         ]
//         classificationsToInclude: [
//           'Critical'
//           'Security'
//         ]
//       }
//       linuxParameters: {
//         classificationsToInclude: [
//           'Critical'
//           'Security'
//         ]
//       }
//     }
//   }
// }

// resource virtualMachine 'Microsoft.Compute/virtualMachines@2022-08-01' = {
//   name: virtualMachineName
//   location: location
//   properties: {
//     networkProfile: {
//       networkInterfaces: [
//         {
//           id: networkInterface.id
//           properties: {
//             deleteOption: 'Delete'
//             primary: true
//           }
//         }
//       ]
//     }
//     storageProfile: {
//       imageReference: {
//         publisher: 'Canonical'
//         offer: '0001-com-ubuntu-server-jammy'
//         sku: '22_04-lts-gen2'
//         version: 'latest'
//       }
//       osDisk: {
//         deleteOption: 'Delete'
//         createOption: 'FromImage'
//       }
//     }
//     hardwareProfile: {
//       vmSize: 'Standard_B1ms'
//     }
//     osProfile: {
//       adminUsername: '${virtualMachineName}cake'
//       adminPassword: password
//       computerName: virtualMachineName
//       linuxConfiguration: {
//         disablePasswordAuthentication: false
//       }
//     }
//   }
// }

// @description('The resource ID of the maintenance configuration.')
// output maintenanceConfigurationResourceId string = maintenanceConfiguration.id

// @description('The resource ID of the created Virtual Machine.')
// output virtualMachineResourceId string = virtualMachine.id

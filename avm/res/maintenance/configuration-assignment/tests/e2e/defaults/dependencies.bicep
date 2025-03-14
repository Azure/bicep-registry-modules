// resource maintenanceConfiguration 'Microsoft.Maintenance/maintenanceConfigurations@2023-10-01-preview' = {
//   name: maintenanceConfigurationName
//   location: location
//   properties: {
//     extensionProperties: {
//       InGuestPatchMode: 'User'
//     }
//     maintenanceScope: 'InGuestPatch'
//     maintenanceWindow: {
//       startDateTime: '2024-06-16 00:00'
//       duration: '03:55'
//       timeZone: 'W. Europe Standard Time'
//       recurEvery: '1Day'
//     }
//     visibility: 'Custom'
//     installPatches: {
//       rebootSetting: 'IfRequired'
//       windowsParameters: {
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

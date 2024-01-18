targetScope = 'subscription'
metadata name = 'Using Private Endpoints'
metadata description = 'This instance deploys the module with Private Endpoints.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-workspace-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dvwspe'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = 'tpe' //'#_namePrefix_#'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: location
  }
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: location
    publicNetworkAccess: 'Disabled'
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.privateDNSZoneResourceId_feed
        ]
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
        ipConfigurations: [
          {
            name: 'myIPconfig-feed'
            groupId: 'feed'
            memberName: 'feed'
            privateIpAddress: '10.0.0.10'
          }
        ]
        customDnsConfigs: []
      }
      {
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.privateDNSZoneResourceId_global
        ]
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
        ipConfigurations: [
          {
            name: 'myIPconfig-global'
            groupId: 'global'
            memberName: 'global'
            privateIpAddress: '10.0.0.11'
          }
        ]
        customDnsConfigs: []
      }
    ]
  }
}]

// privateEndpoints: [
//   {
//     service: 'feed'
//     subnetResourceId: nestedDependencies.outputs.subnetResourceId
//     privateDnsZoneGroup: {
//       privateDNSResourceIds: [
//         nestedDependencies.outputs.privateDNSZoneResourceId
//       ]
//     }
//     tags: {
//       Environment: 'Non-Prod'
//       Role: 'DeploymentValidation'
//     }
//   }
//   {
//     service: 'global'
//     subnetResourceId: nestedDependencies.outputs.subnetResourceId
//     privateDnsZoneGroup: {
//       privateDNSResourceIds: [
//         nestedDependencies.outputs.privateDNSZoneResourceId
//       ]
//     }
//     tags: {
//       Environment: 'Non-Prod'
//       Role: 'DeploymentValidation'
//     }
//   }
// ]

// privateEndpoints: [
// {
// privateDnsZoneResourceIds: [
// nestedDependencies.outputs.privateDNSZoneResourceId
// ]
// subnetResourceId: nestedDependencies.outputs.subnetResourceId
// tags: {
// 'hidden-title': 'This is visible in the resource name'
// Environment: 'Non-Prod'
// Role: 'DeploymentValidation'
// }
// ipConfigurations: [
// {
// name: 'myIPconfig-feed'
// properties: {
// groupId: 'feed'
// memberName: 'feed'
// privateIPAddress: '10.0.0.10'
// }
// }
// ]
// customDnsConfigs: [
// {
// fqdn: 'abc.avd.com'
// ipAddresses: [
// '10.0.0.10'
// ]
// }
// ]
// }
// {
// privateDnsZoneResourceIds: [
// nestedDependencies.outputs.privateDNSZoneResourceId
// ]
// subnetResourceId: nestedDependencies.outputs.subnetResourceId
// tags: {
// 'hidden-title': 'This is visible in the resource name'
// Environment: 'Non-Prod'
// Role: 'DeploymentValidation'
// }
// ipConfigurations: [
// {
// name: 'myIPconfig-global'
// properties: {
// groupId: 'global'
// memberName: 'global'
// privateIPAddress: '10.0.0.10'
// }
// }
// ]
// customDnsConfigs: [
// {
// fqdn: 'abc.avd.com'
// ipAddresses: [
// '10.0.0.11'
// ]
// }
// ]
// }
// ]

// module testDeployment '../../../main.bicep' = {
//   scope: resourceGroup
//   name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
//   params: {
//     name: '${namePrefix}-${serviceShort}'
//     location: location
//     administratorLogin: 'adminUserName'
//     administratorLoginPassword: password
//     privateEndpoints: [
//       {
//         privateDnsZoneResourceIds: [
//           nestedDependencies.outputs.privateDNSZoneResourceId
//         ]
//         subnetResourceId: nestedDependencies.outputs.subnetResourceId
//         tags: {
//           'hidden-title': 'This is visible in the resource name'
//           Environment: 'Non-Prod'
//           Role: 'DeploymentValidation'
//         }
//         ipConfigurations: [
//           {
//             name: 'myIPconfig'
//             properties: {
//               groupId: 'sqlServer'
//               memberName: 'sqlServer'
//               privateIPAddress: '10.0.0.10'
//             }
//           }
//         ]
//         customDnsConfigs: [
//           {
//             fqdn: 'abc.sqlServer.com'
//             ipAddresses: [
//               '10.0.0.10'
//             ]
//           }
//         ]
//       }
//     ]
//     tags: {
//       'hidden-title': 'This is visible in the resource name'
//       Environment: 'Non-Prod'
//       Role: 'DeploymentValidation'
//     }
//   }
// }

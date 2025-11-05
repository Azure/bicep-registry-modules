// targetScope = 'subscription'

metadata name = 'Using Customer-Managed-Keys with User-Assigned identity'
metadata description = 'This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'rsg-mhsm-temp-testing'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = 'uksouth'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssauhsm'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = 'avmh'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
// resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' existing = {
//   name: resourceGroupName
//   // location: resourceLocation
// }

#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'
var keyName = 'rsa-hsm-4096-key-1'
var keyVaultResourceId = '/subscriptions/cfa4dc0b-3d25-4e58-a70a-7085359080c5/resourceGroups/rsg-permanent-managed-hsm/providers/Microsoft.KeyVault/managedHSMs/mhsm-perm-avm-core-001'
var managedIdentityResourceId = '/subscriptions/cfa4dc0b-3d25-4e58-a70a-7085359080c5/resourceGroups/rsg-mhsm-temp-testing/providers/Microsoft.ManagedIdentity/userAssignedIdentities/dep-avmx-msi-ssauhsmuk02'
var keyVersion = 'd01d10f4bfe940a2354b0dd02613052a'

// module nestedDependencies 'dependencies.bicep' = {
//   // scope: resourceGroup
//   name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
//   params: {
//     location: resourceLocation
//     // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
//     keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
//     virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
//     managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
//   }
// }

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    // scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}012'
      // networkAcls: {
      //   bypass: 'AzureServices'
      //   defaultAction: 'Deny'
      // }
      // privateEndpoints: [
      //   {
      //     service: 'blob'
      //     subnetResourceId: nestedDependencies.outputs.subnetResourceId
      //     privateDnsZoneGroup: {
      //       privateDnsZoneGroupConfigs: [
      //         {
      //           privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
      //         }
      //       ]
      //     }
      //   }
      // ]
      blobServices: {
        containers: [
          {
            name: '${namePrefix}container'
            publicAccess: 'None'
          }
        ]
      }
      managedIdentities: {
        userAssignedResourceIds: [
          managedIdentityResourceId
        ]
      }
      customerManagedKey: {
        keyName: keyName
        keyVaultResourceId: keyVaultResourceId
        // keyVersion: keyVersion
        userAssignedIdentityResourceId: managedIdentityResourceId
        // autoRotationEnabled: false
      }
    }
  }
]

// resource key 'Microsoft.KeyVault/vaults/keys@2024-11-01' = {
//   name: name
//   parent: keyVault
//   tags: tags
//   properties: {
//     attributes: {
//       enabled: attributesEnabled
//       exp: attributesExp
//       nbf: attributesNbf
//     }
//     curveName: curveName
//     keyOps: keyOps
//     keySize: keySize
//     kty: kty
//     release_policy: releasePolicy ?? {}
//     ...(!empty(rotationPolicy)
//       ? {
//           rotationPolicy: rotationPolicy
//         }
//       : {})
//   }
// }

// module testDeployment 'module/hsmkeyrbac.bicep' = {
//   // scope: resourceGroup
//   name: '${uniqueString(deployment().name, enforcedLocation)}-testrbac-${serviceShort}'
//   params: {
//     keyVaultResourceId: keyVaultResourceId
//     // networkAcls: {
//     //   bypass: 'AzureServices'
//     //   defaultAction: 'Deny'
//     // }
//     // privateEndpoints: [
//     //   {
//     //     service: 'blob'
//     //     subnetResourceId: nestedDependencies.outputs.subnetResourceId
//     //     privateDnsZoneGroup: {
//     //       privateDnsZoneGroupConfigs: [
//     //         {
//     //           privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
//     //         }
//     //       ]
//     //     }
//     //   }
//     // ]
//   }
// }

// resource hSMCMKKeyVault 'Microsoft.KeyVault/managedHSMs@2024-11-01' existing = {
//   name: last(split((keyVaultResourceId), '/'))
//   scope: resourceGroup(split(keyVaultResourceId, '/')[2], split(keyVaultResourceId, '/')[4])
// }

// resource key_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(keyVaultResourceId, principalId, roleDefinitionId)
//   properties: {
//     roleDefinitionId: roleDefinitionId
//     principalId: principalId
//   }
//   // scope: hSMCMKKey
//   scope: hSMCMKKeyVault
// }

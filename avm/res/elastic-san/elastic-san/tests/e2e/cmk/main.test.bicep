targetScope = 'subscription'

metadata name = 'Using encryption with Customer-Managed-Key'
metadata description = 'This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.'

// ========== //
// Parameters //
// ========== //

@sys.description('Optional. The name of the resource group to deploy for testing purposes.')
@sys.maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-microsoft.elasticsan-${serviceShort}-rg'

@sys.description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@sys.description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'esancmk'

@sys.description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@sys.description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@sys.batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      sku: 'Premium_LRS'
      availabilityZone: 2
      volumeGroups: [
        // The only supported configuration is to use the same user-assigned identity for both 'managedIdentities.userAssignedResourceIds' and 'customerManagedKey.userAssignedIdentityResourceId'.
        // Other configurations such as system-assigned identity are not supported.
        {
          // Test - Encryption with Customer Managed Key
          name: 'vol-grp-01'
          managedIdentities: {
            userAssignedResourceIds: [
              nestedDependencies.outputs.managedIdentityResourceId
            ]
          }
          customerManagedKey: {
            keyName: nestedDependencies.outputs.keyVaultEncryptionKeyName
            keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
            userAssignedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
          }
        }
        {
          // Test - Encryption with Customer Managed Key and explicit Key Version
          name: 'vol-grp-02'
          managedIdentities: {
            userAssignedResourceIds: [
              nestedDependencies.outputs.managedIdentityResourceId
            ]
          }
          customerManagedKey: {
            keyName: nestedDependencies.outputs.keyVaultEncryptionKeyName
            keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
            keyVersion: nestedDependencies.outputs.keyVaultEncryptionKeyVersion
            userAssignedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
          }
        }
      ]
    }
  }
]

import { volumeGroupOutputType } from '../../../main.bicep'

output resourceId string = testDeployment[0].outputs.resourceId
output name string = testDeployment[0].outputs.name
output location string = testDeployment[0].outputs.location
output resourceGroupName string = testDeployment[0].outputs.resourceGroupName
output volumeGroups volumeGroupOutputType[] = testDeployment[0].outputs.volumeGroups

output tenantId string = tenant().tenantId
output managedIdentityResourceId string = nestedDependencies.outputs.managedIdentityResourceId
output cmkKeyVaultKeyUrl string = nestedDependencies.outputs.keyVaultKeyUrl
output cmkKeyVaultEncryptionKeyName string = nestedDependencies.outputs.keyVaultEncryptionKeyName
output cmkKeyVaultUrl string = nestedDependencies.outputs.keyVaultUrl
output cmkKeyVaultEncryptionKeyVersion string = nestedDependencies.outputs.keyVaultEncryptionKeyVersion

targetScope = 'subscription'

metadata name = 'Using Customer-Managed-Keys with User-Assigned identity'
metadata description = 'This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
// param resourceGroupName string = 'rsg-mhsm-temp-testing'
param resourceGroupName string = 'dep-${namePrefix}-storage.storageaccounts-${serviceShort}-rg'

// enforcing location due to quote restrictions
#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssauhsm'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}
var keyName = 'rsa-hsm-4096-key-stg'
var keyVaultResourceId = '/subscriptions/cfa4dc0b-3d25-4e58-a70a-7085359080c5/resourceGroups/rsg-permanent-managed-hsm/providers/Microsoft.KeyVault/managedHSMs/mhsm-perm-avm-core-001'
var managedIdentityResourceId = '/subscriptions/cfa4dc0b-3d25-4e58-a70a-7085359080c5/resourceGroups/rsg-permanent-managed-hsm/providers/Microsoft.ManagedIdentity/userAssignedIdentities/dep-avmx-msi-ssauhsm-001'
var keyVersion = '2fac56db8d0040899d98128d705ae038'

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}016'
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
        keyVersion: keyVersion
        userAssignedIdentityResourceId: managedIdentityResourceId
      }
    }
  }
]

targetScope = 'subscription'

metadata name = 'Using Customer-Managed-Keys with User-Assigned identity'
metadata description = 'This instance deploys the module with Customer-Managed-Keys using a User-Assigned Identity to access the key.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sql.servers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sscmk'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Generated. Used as a basis for unique resource names.')
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
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    databaseIdentityName: 'dep-${namePrefix}-msidb-${serviceShort}'
    location: resourceLocation
  }
}
// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      primaryUserAssignedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
      administrators: {
        azureADOnlyAuthentication: true
        login: 'myspn'
        sid: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'Application'
        tenantId: tenant().tenantId
      }
      managedIdentities: {
        systemAssigned: false
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      customerManagedKey: {
        keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
        keyName: nestedDependencies.outputs.keyVaultKeyName
        keyVersion: last(split(nestedDependencies.outputs.keyVaultEncryptionKeyUrl, '/'))
        autoRotationEnabled: true
      }
      databases: [
        {
          name: '${namePrefix}-${serviceShort}-db'
          managedIdentities: {
            userAssignedResourceIds: [
              nestedDependencies.outputs.databaseIdentityResourceId
            ]
          }
          customerManagedKey: {
            keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
            keyName: nestedDependencies.outputs.keyVaultDatabaseKeyName
            keyVersion: last(split(nestedDependencies.outputs.keyVaultDatabaseEncryptionKeyUrl, '/'))
            autoRotationEnabled: true
          }
          sku: {
            name: 'Basic'
            tier: 'Basic'
          }
          maxSizeBytes: 2147483648
          zoneRedundant: false
          availabilityZone: -1
        }
      ]
    }
  }
]

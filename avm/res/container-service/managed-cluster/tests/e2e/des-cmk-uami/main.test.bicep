targetScope = 'subscription'

metadata name = 'Enabling encryption via a Disk Encryption Set (DES) using Customer-Managed-Keys (CMK) and a User-Assigned Identity'
metadata description = 'This instance deploys the module with encryption-at-rest using a Disk Encryption Set (DES) secured by Customer-Managed Keys (CMK), and leveraging a User-Assigned Managed Identity to access the key.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-containerservice.managedclusters-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'csmscmk'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: resourceLocation
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    diskEncryptionSetName: 'dep-${namePrefix}-des-${serviceShort}'
    waitDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}-waitForPropagation'
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
      managedIdentities: {
        systemAssigned: true
      }
      primaryAgentPoolProfiles: [
        {
          name: 'systempool'
          count: 3
          vmSize: 'Standard_DS4_v2'
          mode: 'System'
        }
      ]
      aadProfile: {
        enableAzureRBAC: true
        managed: true
      }
      diskEncryptionSetResourceId: nestedDependencies.outputs.diskEncryptionSetResourceId
    }
  }
]

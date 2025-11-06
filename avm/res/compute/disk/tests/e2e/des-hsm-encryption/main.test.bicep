targetScope = 'subscription'

metadata name = 'Enabling encryption-at-rest via a Disk Encryption Set (DES) using Managed HSM Customer-Managed-Keys (CMK) and a User-Assigned Identity'
metadata description = 'This instance deploys the module with encryption-at-rest using a Disk Encryption Set (DES) secured by Managed HSM Customer-Managed Keys (CMK), and leveraging a User-Assigned Managed Identity to access the HSM key.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-compute.disks-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = 'uksouth'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cdhsm'

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
    diskEncryptionSetName: 'dep-${namePrefix}-des-${serviceShort}'
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
      name: '${namePrefix}-${serviceShort}004'
      location: resourceLocation
      sku: 'Standard_LRS'
      availabilityZone: -1
      diskSizeGB: 1
      diskEncryptionSetResourceId: nestedDependencies.outputs.diskEncryptionSetResourceId
    }
  }
]

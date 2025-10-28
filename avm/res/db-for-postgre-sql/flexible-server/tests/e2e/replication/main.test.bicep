targetScope = 'subscription'

metadata name = 'Primary server and Readonly Replication server'
metadata description = 'This instance deploys a primary and readonly replication server using the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-dbforpostgresql.flexibleservers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dfpsrep'

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
    primaryServerName: '${namePrefix}${serviceShort}pri001'
  }
}
// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module replicationTestDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      sourceServerResourceId: nestedDependencies.outputs.serverResourceId
      availabilityZone: -1
      authConfig: {
        activeDirectoryAuth: 'Enabled'
        passwordAuth: 'Disabled'
      }
      skuName: 'Standard_D2s_v3'
      tier: 'GeneralPurpose'
      version: '17'
      storageSizeGB: 512
      autoGrow: 'Enabled'
      highAvailability: 'Disabled' // Must be disabled for read-replicas
      createMode: iteration == 'init' ? 'Replica' : null // Only set createMode on initial deployment of replica
    }
  }
]

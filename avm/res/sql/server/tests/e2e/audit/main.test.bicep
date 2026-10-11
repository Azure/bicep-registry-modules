import { uniqueResourceName } from '../../../../../../../utilities/e2e-template-assets/functions/unique-resource-name.bicep'

targetScope = 'subscription'

metadata name = 'With audit settings'
metadata description = 'This instance deploys the module with auditing settings.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sql.servers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssaud'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
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
    storageAccountName: uniqueResourceName('dep${namePrefix}audstore${serviceShort}', resourceGroup.id, 24)
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
      name: uniqueResourceName('${namePrefix}${serviceShort}001', resourceGroup.id, 63)
      location: resourceLocation
      administratorLogin: 'adminUserName'
      administratorLoginPassword: password
      managedIdentities: {
        systemAssigned: true
      }
      auditSettings: {
        state: 'Enabled'
        isManagedIdentityInUse: true
        storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
      }
    }
  }
]

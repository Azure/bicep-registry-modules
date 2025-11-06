targetScope = 'subscription'

metadata name = 'Using HSM Customer-Managed-Keys with User-Assigned identity'
metadata description = 'This instance deploys the module using HSM Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-operational-insights-cluster-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'oichsm'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The name of the Managed Identity used by the deployment script. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-deploymentMSIName\'.')
@secure()
param deploymentMSIName string = ''

@description('Required. The name of the Resource Group containing the Managed Identity used by the deployment script. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-deploymentMSIResourceGroupName\'.')
@secure()
param deploymentMSIResourceGroupName string = ''

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
  }
}

module nestedHsmDependencies 'dependencies.hsm.bicep' = {
  scope: az.resourceGroup('rsg-permanent-managed-hsm')
  name: '${uniqueString(deployment().name)}-nestedHSMDependencies'
  params: {
    managedHsmName: 'mhsm-perm-avm-core-001'
    managedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
    hsmKeyName: '${serviceShort}-${namePrefix}-key'
    hsmDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
    deploymentMSIName: deploymentMSIName
    deploymentMSIResourceGroupName: deploymentMSIResourceGroupName
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
      location: resourceLocation
      sku: {
        capacity: 100
        name: 'CapacityReservation'
      }
      customerManagedKey: {
        keyName: nestedHsmDependencies.outputs.keyName
        keyVaultResourceId: nestedHsmDependencies.outputs.keyVaultResourceId
        userAssignedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
      }
    }
  }
]

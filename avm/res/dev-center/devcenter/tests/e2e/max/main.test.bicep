targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-devcenter-devcenter-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ddcmax'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = 'testa'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

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
    //keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
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
      location: resourceLocation
      tags: {
        costCenter: '1234'
      }
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      roleAssignments: [
        {
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          roleDefinitionIdOrName: 'DevCenter Project Admin'
          principalType: 'ServicePrincipal'
        }
        {
          name: guid('Custom seed ${namePrefix}${serviceShort}')
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
      //customerManagedKey: {
      //  keyName: nestedDependencies.outputs.keyVaultKeyName
      //  keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
      //  userAssignedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
      //}
      displayName: 'Dev Center Test'
      devBoxProvisioningSettings: {
        installAzureMonitorAgentEnableStatus: 'Enabled'
      }
      networkSettings: {
        microsoftHostedNetworkEnableStatus: 'Disabled'
      }
      projectCatalogSettings: {
        catalogItemSyncEnableStatus: 'Enabled'
      }
    }
  }
]

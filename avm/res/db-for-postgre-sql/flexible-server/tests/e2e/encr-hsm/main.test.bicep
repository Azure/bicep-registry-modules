targetScope = 'subscription'

metadata name = 'Using encryption with HSM Customer-Managed-Key'
metadata description = 'This instance deploys the module using HSM Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-dbforpostgresql.flexibleservers-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dfpshsm'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

var enforcedLocation = 'uksouth'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    // hsmKeyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
  }
}

module nestedHsmDependencies 'dependencies.hsm.bicep' = {
  scope: az.resourceGroup('rsg-permanent-managed-hsm')
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedHSMDependencies'
  params: {
    managedHsmName: 'mhsm-perm-avm-core-001'
    managedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
    hsmDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      availabilityZone: -1
      customerManagedKey: {
        keyName: nestedHsmDependencies.outputs.keyName
        keyVaultResourceId: nestedHsmDependencies.outputs.keyVaultResourceId
        userAssignedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
      }
      administrators: [
        {
          objectId: nestedDependencies.outputs.managedIdentityClientId
          principalName: nestedDependencies.outputs.managedIdentityName
          principalType: 'ServicePrincipal'
        }
      ]
      skuName: 'Standard_D2s_v3'
      tier: 'GeneralPurpose'
    }
  }
]

output dataEncryption object? = testDeployment[0].outputs.?dataEncryption

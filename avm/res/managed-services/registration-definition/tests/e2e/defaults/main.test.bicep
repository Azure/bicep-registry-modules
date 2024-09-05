targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'msrdmin'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The tenant Id of the lighthouse tenant. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-LighthouseManagedByTenantId\'.')
@secure()
param lighthouseManagedByTenantId string = ''

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name)}-test-${serviceShort}-${iteration}'
    params: {
      name: 'Component Validation - ${namePrefix}${serviceShort} Subscription assignment'
      metadataLocation: resourceLocation
      registrationDescription: 'Managed by Lighthouse'
      authorizations: [
        {
          principalId: 'ecadddf6-78c3-4516-afb2-7d30a174ea13'
          roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
        }
        {
          principalId: 'ecadddf6-78c3-4516-afb2-7d30a174ea13'
          roleDefinitionId: '91c1777a-f3dc-4fae-b103-61d183457e46'
        }
      ]
      managedByTenantId: lighthouseManagedByTenantId
    }
  }
]

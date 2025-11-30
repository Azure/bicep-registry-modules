targetScope = 'subscription'

metadata name = 'Deploying with standby container group pool'
metadata description = 'This instance deploys the module with the parameters required to have the container instance used a standby container pool.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-containerinstance.containergroups-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cicgsb'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The object id of the \'Standby Pool Resource Provider\' Enterprise Application. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-StandbyPoolResourceProviderEnterpriseApplicationObjectId\'.')
@secure()
param standbyPoolResourceProviderEnterpriseApplicationObjectId string = ''

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
    containerGroupProfileName: 'dep-${namePrefix}-cgp-${serviceShort}'
    standbyContainerGroupPoolName: 'dep-${namePrefix}-scgp-${serviceShort}'
    standbyPoolResourceProviderEnterpriseApplicationObjectId: standbyPoolResourceProviderEnterpriseApplicationObjectId
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
      availabilityZone: -1
      containers: [
        {
          name: '${namePrefix}-az-aci-x-001'
          properties: {
            configMap: {
              keyValuePairs: {
                aKey: 'aValue'
              }
            }
          }
        }
      ]
      containerGroupProfile: {
        resourceId: nestedDependencies.outputs.containerGroupProfileResourceId
        revision: 1
      }
      standbyPoolProfile: {
        failContainerGroupCreateOnReuseFailure: false
        resourceId: nestedDependencies.outputs.standbyContainerGroupPoolResourceId
      }
    }
  }
]

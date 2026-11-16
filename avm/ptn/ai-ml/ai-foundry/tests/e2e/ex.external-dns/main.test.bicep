targetScope = 'subscription'
metadata name = 'Private endpoints with externally managed DNS'
metadata description = 'Creates private endpoints without DNS zone groups. DNS integration must be managed externally, for example by Azure Policy.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-bicep-${serviceShort}-rg'

// Due to AI Services capacity constraints, this region must be used in the AVM testing subscription
#disable-next-line no-hardcoded-location
var enforcedLocation = 'australiaeast'

@description('Optional. A short identifier for the kind of deployment.')
param serviceShort string = 'fndrydns'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

var workloadName = take(padLeft('${namePrefix}${serviceShort}', 12), 12)

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
  tags: {
    SecurityControl: 'Ignore'
  }
}

module dependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  scope: resourceGroup
  params: {
    workloadName: workloadName
    location: enforcedLocation
  }
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      baseName: workloadName
      includeAssociatedResources: true
      privateEndpointSubnetResourceId: dependencies.outputs.subnetPrivateEndpointsResourceId
      aiFoundryConfiguration: {
        enablePublicNetworkAccess: true
        networking: {
          privateEndpointName: 'pep-${workloadName}-foundry'
        }
      }
      keyVaultConfiguration: {
        privateEndpointName: 'pep-${workloadName}-vault'
      }
      aiSearchConfiguration: {
        privateEndpointName: 'pep-${workloadName}-search'
        sku: 'basic'
        replicaCount: 1
      }
      storageAccountConfiguration: {
        privateEndpointName: 'pep-${workloadName}-blob'
      }
      cosmosDbConfiguration: {
        privateEndpointName: 'pep-${workloadName}-cosmos'
      }
    }
  }
]

targetScope = 'subscription'
metadata name = 'WAF-aligned'
metadata description = 'Creates an AI Foundry account and project with Standard Agent Services with private networking.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-bicep-${serviceShort}-rg'

// Due to AI Services capacity constraints, this region must be used in the AVM testing subscription
#disable-next-line no-hardcoded-location
var enforcedLocation = 'australiaeast'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'fndrywaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// Setting max length to 12 to stay within bounds of baseName length constraints.
// Setting min length to 12 to prevent min-char warnings on the test deployment.
// These warnings cannot be disabled due to AVM processes not able to parse the # characer.
var workloadName = take(padLeft('${namePrefix}${serviceShort}', 12), 12)

// ============ //
// Dependencies //
// ============ //

module dependencies 'dependencies.bicep' = {
  name: take('module.dependencies.${workloadName}', 64)
  scope: resourceGroup
  params: {
    workloadName: workloadName
    location: enforcedLocation
  }
}

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
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
      baseName: workloadName
      includeAssociatedResources: true
      privateEndpointSubnetId: dependencies.outputs.subnetPrivateEndpointsResourceId
      aiFoundryConfiguration: {
        networking: {
          aiServicesPrivateDnsZoneId: dependencies.outputs.servicesAiDnsZoneResourceId
          openAiPrivateDnsZoneId: dependencies.outputs.openaiDnsZoneResourceId
          cognitiveServicesPrivateDnsZoneId: dependencies.outputs.cognitiveServicesDnsZoneResourceId
        }
      }
      storageAccountConfiguration: {
        blobPrivateDnsZoneId: dependencies.outputs.blobDnsZoneResourceId
      }
      aiSearchConfiguration: {
        privateDnsZoneId: dependencies.outputs.searchDnsZoneResourceId
      }
      keyVaultConfiguration: {
        privateDnsZoneId: dependencies.outputs.keyVaultDnsZoneResourceId
      }
      cosmosDbConfiguration: {
        privateDnsZoneId: dependencies.outputs.documentsDnsZoneResourceId
      }
      aiModelDeployments: [
        {
          name: 'gpt-4.1'
          model: {
            name: 'gpt-4.1'
            format: 'OpenAI'
            version: '2025-04-14'
          }
          sku: {
            name: 'GlobalStandard'
            capacity: 1
          }
        }
      ]
    }
  }
]

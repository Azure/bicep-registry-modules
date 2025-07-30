targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

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
param serviceShort string = 'fndrymax'

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
      baseUniqueName: substring(uniqueString(subscription().id, resourceGroup.name, serviceShort), 0, 5)
      location: enforcedLocation
      includeAssociatedResources: true
      privateEndpointSubnetId: dependencies.outputs.subnetPrivateEndpointsResourceId
      sku: 'S0'
      aiFoundryConfiguration: {
        accountName: 'aifcustom${workloadName}'
        location: enforcedLocation
        project: {
          name: 'projcustom${workloadName}'
          displayName: 'Custom Project for ${workloadName}'
          desc: 'This is a custom project for testing.'
        }
        allowProjectManagement: true
        networking: {
          aiServicesPrivateDnsZoneId: dependencies.outputs.servicesAiDnsZoneResourceId
          openAiPrivateDnsZoneId: dependencies.outputs.openaiDnsZoneResourceId
          cognitiveServicesPrivateDnsZoneId: dependencies.outputs.cognitiveServicesDnsZoneResourceId
        }
        roleAssignments: [
          {
            principalId: dependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Cognitive Services OpenAI User'
          }
        ]
      }
      keyVaultConfiguration: {
        name: 'kvcustom${workloadName}'
        privateDnsZoneId: dependencies.outputs.keyVaultDnsZoneResourceId
        roleAssignments: [
          {
            principalId: dependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Key Vault Secrets User'
          }
        ]
      }
      storageAccountConfiguration: {
        name: 'stcustom${workloadName}'
        containerName: 'my-foundry-proj-data'
        blobPrivateDnsZoneId: dependencies.outputs.blobDnsZoneResourceId
        roleAssignments: [
          {
            principalId: dependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Storage Blob Data Contributor'
          }
        ]
      }
      cosmosDbConfiguration: {
        name: 'cosmoscustom${workloadName}'
        privateDnsZoneId: dependencies.outputs.documentsDnsZoneResourceId
        roleAssignments: [
          {
            principalId: dependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Cosmos DB Account Reader Role'
          }
        ]
      }
      aiSearchConfiguration: {
        name: 'srchcustom${workloadName}'
        privateDnsZoneId: dependencies.outputs.searchDnsZoneResourceId
        roleAssignments: [
          {
            principalId: dependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Search Index Data Contributor'
          }
        ]
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
      lock: {
        kind: 'CanNotDelete'
        name: 'lock${workloadName}'
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Example'
        Role: 'DeploymentValidation'
      }
    }
  }
]

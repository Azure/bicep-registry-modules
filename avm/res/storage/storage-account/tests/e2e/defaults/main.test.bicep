targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-storage.storageaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssamin'

@description('Optional. A token to inject into the name of each resource.')
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
    serverFarmName: 'dep-${namePrefix}-sf-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

module sa 'br/public:avm/res/storage/storage-account:0.8.3' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    allowBlobPublicAccess: false
    location: resourceLocation
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Owner'
        principalId: functionapp.outputs.systemAssignedMIPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
  }
  dependsOn: [
    functionapp
  ]
}

module functionapp 'br/public:avm/res/web/site:0.3.5' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-functionapp'
  params: {
    kind: 'functionapp'
    name: 'functionapp123'
    serverFarmResourceId: nestedDependencies.outputs.serverFarmResourceId
    managedIdentities: {
      systemAssigned: true
    }
  }
}

targetScope = 'subscription'

metadata name = 'Using Azure CLI'
metadata description = 'This instance deploys the module with an Azure CLI script.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'avm-${namePrefix}-resources.deploymentscripts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'rdscli'

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
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    storageAccountName: 'dep${namePrefix}st${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: resourceLocation
    azCliVersion: '2.9.1'
    kind: 'AzureCLI'
    retentionInterval: 'P1D'
    environmentVariables: {
      secureList: [
        {
          name: 'var1'
          value: 'AVM Deployment Script test!'
        }
      ]
    }
    scriptContent: 'echo \'Enviornment variable value is: \' $var1'
    storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
    managedIdentities: {
      userAssignedResourcesIds: [
        nestedDependencies.outputs.managedIdentityResourceId
      ]
    }
  }
  dependsOn: [
    nestedDependencies
  ]
}

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'avm-${namePrefix}-resources.deploymentscripts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'rdsmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags: {
    'hidden-title': 'This is visible in the resource name'
    Environment: 'Non-Prod'
    Role: 'DeploymentValidation'
  }
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    storageAccountName: 'dep${namePrefix}st${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: location
    azCliVersion: '2.9.1'
    kind: 'AzureCLI'
    retentionInterval: 'P1D'
    cleanupPreference: 'Always'
    lock: {
      kind: 'None'
    }
    subnetIds: [
      {
        id: nestedDependencies.outputs.subnetResourceId
      }
    ]
    containerGroupName: 'dep-${namePrefix}-cg-${serviceShort}'
    arguments: '-argument1 \\"test\\"'
    environmentVariables: {
      secureList: [
        {
          name: 'var1'
          value: 'test'
        }
        {
          name: 'var2'
          secureValue: guid(deployment().name)
        }
      ]
    }
    managedIdentities: {
      userAssignedResourcesIds: [
        nestedDependencies.outputs.managedIdentityResourceId
      ]
    }
    roleAssignments: [
      {
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    timeout: 'PT1H'
    runOnce: true
    scriptContent: 'echo \'AVM Deployment Script test!\''
    storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
  }
}

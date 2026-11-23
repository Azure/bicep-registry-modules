targetScope = 'subscription'

metadata name = 'Fork CI variable'
metadata description = 'Tests that a fork repository variable reaches the deployment.'

@description('Required. Canary supplied by the fork repository variable CI_FORK_CANARY.')
@allowed([
  'fork-var-proved'
])
param forkCanary string

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-example-example-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment.')
param serviceShort string = 'nevar'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: resourceLocation
    tags: {
      forkCanary: forkCanary
    }
  }
}

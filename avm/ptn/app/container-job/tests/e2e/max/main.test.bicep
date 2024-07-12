targetScope = 'subscription'

metadata name = 'Pass in existing resources'
metadata description = 'This instance deploys the module with existing resources.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-app-containerjob-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'acjmax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

module dependencies './dependencies.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-dependencies'
  scope: resourceGroup
  params: {
    lawName: 'dep${namePrefix}law${serviceShort}'
    appInsightsName: 'dep${namePrefix}ai${serviceShort}'
    userIdentityName: 'dep${namePrefix}uid${serviceShort}'
  }
}

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
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
      location: resourceLocation
      nameSuffix: 'cjob'
      containerImageSource: 'mcr.microsoft.com/k8se/quickstart-jobs:latest'
      logAnalyticsWorkspaceResourceId: dependencies.outputs.logAnalyticsResourceId
      // needed for idempotency testing
      overwriteExistingImage: true
      appInsightsConnectionString: dependencies.outputs.appInsightsConnectionString
      // with 'kv' in the uniqueString the name can start with a number, which is an invalid name for Key Vault
      keyVaultName: 'kv${uniqueString('cjob', resourceLocation, resourceGroupName)}'
      deployInVnet: true
      workloadProfiles: [
        {
          workloadProfileType: 'D4'
          name: 'CAW01'
          minimumCount: 0
          maximumCount: 1
        }
      ]
      workloadProfileName: 'CAW01'
      managedIdentityName: dependencies.outputs.userIdentityName
      cpu: '2'
      memory: '8Gi'
      addressPrefix: '192.168.0.0/16'
      cronExpression: '0 * * * *'
      environmentVariables: [
        { name: 'key1', value: 'value1' }
        { name: 'key2', secretRef: 'secretkey1' }
      ]
      secrets: [
        {
          name: 'secretkey1'
          keyVaultUrl: 'https://kv${uniqueString('cjob', resourceLocation, resourceGroupName)}${environment().suffixes.keyvaultDns}/secrets/key1'
          identity: dependencies.outputs.userIdentityName
        }
      ]
      deployDnsZoneContainerRegistry: false
      deployDnsZoneKeyVault: false
      tags: {
        environment: 'test'
      }
    }
  }
]

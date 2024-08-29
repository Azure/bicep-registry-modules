targetScope = 'subscription'

metadata name = 'Web App'
metadata description = 'This instance deploys the module as Web App with the set of logs configuration.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-web.sites-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'wslc'

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
    applicationInsightsName: 'dep-${namePrefix}-appInsights-${serviceShort}'
    location: resourceLocation
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
      location: resourceLocation
      kind: 'app'
      serverFarmResourceId: nestedDependencies.outputs.serverFarmResourceId
      appInsightResourceId: nestedDependencies.outputs.applicationInsigtsResourceId
      logsConfiguration: {
        applicationLogs: { fileSystem: { level: 'Verbose' } }
        detailedErrorMessages: { enabled: true }
        failedRequestsTracing: { enabled: true }
        httpLogs: { fileSystem: { enabled: true, retentionInDays: 1, retentionInMb: 35 } }
      }
      managedIdentities: {
        systemAssigned: true
      }
      siteConfig: {
        alwaysOn: true
        appCommandLine: ''
      }
      appSettingsKeyValuePairs: {
        SCM_DO_BUILD_DURING_DEPLOYMENT: 'True'
        ENABLE_ORYX_BUILD: 'True'
        JAVA_OPTS: join(concat([], ['-Djdk.attach.allowAttachSelf=true']), ' ')
      }
    }
  }
]

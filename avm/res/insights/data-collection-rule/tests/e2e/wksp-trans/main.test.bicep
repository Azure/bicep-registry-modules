targetScope = 'subscription'

metadata name = 'Collecting custom text logs with ingestion-time transformation'
metadata description = 'This instance deploys the module to setup collection of custom logs and ingestion-time transformation.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-insights.dataCollectionRules-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'idcrwktrns'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

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
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
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
      dataCollectionRuleProperties: {
        kind: 'WorkspaceTransforms'
        description: 'Data Collection Rule with ingestion-time transformation'
        dataFlows: [
          {
            streams: [
              'Microsoft-Table-LAQueryLogs'
            ]
            destinations: [
              nestedDependencies.outputs.logAnalyticsWorkspaceName
            ]
            transformKql: 'source | where QueryText !contains \'LAQueryLogs\''
          }
          {
            streams: [
              'Microsoft-Table-Event'
            ]
            destinations: [
              nestedDependencies.outputs.logAnalyticsWorkspaceName
            ]
            transformKql: 'source | project-away ParameterXml'
          }
        ]
        destinations: {
          logAnalytics: [
            {
              name: nestedDependencies.outputs.logAnalyticsWorkspaceName
              workspaceResourceId: nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
            }
          ]
        }
      }
    }
  }
]

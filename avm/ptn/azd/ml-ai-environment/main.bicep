metadata name = 'Azd Azure Machine Learning Environment'
metadata description = '''Create Azure Machine Learning workspaces of type 'Hub' and 'Project' and their required dependencies.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.'''

@description('Required. The AI Studio Hub Resource name.')
param hubName string

@description('Required. The AI Project resource name.')
param projectName string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
@metadata({
  example: '''
  {
      "key1": "value1"
      "key2": "value2"
  }
  '''
})
param tags object?

@description('Optional. The Container Registry resource name.')
param containerRegistryName string = ''

@description('Required. The Cognitive Services name.')
param cognitiveServicesName string

@description('Required. The Key Vault resource name.')
param keyVaultName string

@description('Required. The Storage Account resource name.')
param storageAccountName string

@description('Optional. The Application Insights resource name.')
param applicationInsightsName string = ''

@description('Optional. The Log Analytics resource name.')
param logAnalyticsName string = ''

@description('Optional. Array of deployments about cognitive service accounts to create.')
param cognitiveServicesDeployments array = []

@description('Condition. The Azure Search resource name. Required if the parameter searchServiceName is not empty.')
param searchServiceName string = ''

@description('Optional. The Open AI connection name.')
param openAiConnectionName string

@description('Optional. The Azure Search connection name.')
param searchConnectionName string

@description('Optional. The User Assigned Identity resource name.')
param userAssignedtName string

@description('Optional. The number of replicas in the search service. If specified, it must be a value between 1 and 12 inclusive for standard SKUs, or between 1 and 3 inclusive for basic SKU.')
@minValue(1)
@maxValue(12)
param replicaCount int = 1

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.azd-mlaienvironment.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

module hubDependencies 'br/public:avm/ptn/azd/ml-hub-dependencies:0.1.0' = {
  name: '${uniqueString(deployment().name, location)}-mlHubDependenciesDeployment'
  params: {
    location: location
    tags: tags
    cognitiveServicesName: cognitiveServicesName
    keyVaultName: keyVaultName
    storageAccountName: storageAccountName
    applicationInsightsName: applicationInsightsName
    logAnalyticsName: logAnalyticsName
    containerRegistryName: containerRegistryName
    cognitiveServicesDeployments: cognitiveServicesDeployments
    searchServiceName: searchServiceName
    replicaCount: replicaCount
    enableTelemetry: enableTelemetry
  }
}

module hub './modules/hub.bicep' = {
  name: '${uniqueString(deployment().name, location)}-hub'
  params: {
    location: location
    tags: tags
    name: hubName
    keyVaultResourceId: hubDependencies.outputs.keyVaultResourceId
    storageAccountResourceId: hubDependencies.outputs.storageAccountResourceId
    containerRegistryResourceId: hubDependencies.outputs.containerRegistryResourceId
    applicationInsightsResourceId: hubDependencies.outputs.applicationInsightsResourceId
    openAiName: hubDependencies.outputs.cognitiveServicesName
    aiSearchName: hubDependencies.outputs.searchServiceName
    aiSearchConnectionName: searchConnectionName
    openAiContentSafetyConnectionName: openAiConnectionName
  }
}

module project 'br/public:avm/ptn/azd/ml-project:0.1.1' = {
  name: '${uniqueString(deployment().name, location)}-project'
  params: {
    name: projectName
    hubResourceId: hub.outputs.resourceId
    keyVaultName: hubDependencies.outputs.keyVaultName
    userAssignedName: userAssignedtName
    enableTelemetry: enableTelemetry
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the resource group the module was deployed to.')
output resourceGroupName string = resourceGroup().name

@description('The name of the ai studio hub.')
output hubName string = hub.outputs.name

@description('The principal ID of the ai studio hub.')
output hubPrincipalId string = hub.outputs.principalId

@description('The name of the ai studio project.')
output projectName string = project.outputs.projectName

@description('The principal ID of the ai studio project.')
output projectPrincipalId string = project.outputs.projectPrincipalId

@description('The name of the key vault.')
output keyVaultName string = hubDependencies.outputs.keyVaultName

@description('The endpoint of the key vault.')
output keyVaultEndpoint string = hubDependencies.outputs.keyVaultEndpoint

@description('The name of the application insights.')
output applicationInsightsName string = hubDependencies.outputs.applicationInsightsName

@description('The name of the log analytics workspace.')
output logAnalyticsWorkspaceName string = hubDependencies.outputs.logAnalyticsWorkspaceName

@description('The name of the container registry.')
output containerRegistryName string = hubDependencies.outputs.containerRegistryName

@description('The endpoint of the container registry.')
output containerRegistryEndpoint string = hubDependencies.outputs.containerRegistryEndpoint

@description('The name of the storage account.')
output storageAccountName string = hubDependencies.outputs.storageAccountName

@description('The name of the cognitive services.')
output openAiName string = hubDependencies.outputs.cognitiveServicesName

@description('The endpoint of the cognitive services.')
output openAiEndpoint string = hubDependencies.outputs.cognitiveServicesEndpoint

@description('The name of the search service.')
output searchServiceName string = hubDependencies.outputs.searchServiceName

@description('The endpoint of the search service.')
output searchServiceEndpoint string = hubDependencies.outputs.searchServiceEndpoint

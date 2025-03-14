// NOTE: This module is required to pass keys from previously deployed resources leveraging the existing keyword
// This behavior will be updated in future versions to leverage more secure solutions such as Key Vault or managed identities
@description('Required. The name of the Rag Function resource to be created.')
param ragFunctionName string
@description('Required. The location of the Rag Function resource to be created.')
param ragFunctionLocation string
@description('Required. The tags to be applied to the Rag Function resource.')
param tags object
@description('Required. The name of the Rag Function Docker image to be used.')
param ragDockerImageName string
@description('Required. The name of the storage account to be used by the Rag Function resource.')
param ragStorageAccountName string
@description('Required. The name of the SQL database to be used by the Rag Function resource.')
param sqlDatabaseName string
@description('Required. The fully qualified domain name of the SQL server to be used by the Rag Function resource.')
param sqlServerFullyQualifiedDomainName string
@description('Required. The administrator login credentials of the SQL server to be used by the Rag Function resource.')
@secure()
param sqlServerAdministratorLogin string
@description('Required. The administrator password credentials of the SQL server to be used by the Rag Function resource.')
@secure()
param sqlServerAdministratorPassword string
@description('Required. The GPT Model preview version to be used by the Rag Function resource.')
param gptModelVersionPreview string
@description('Required. The GPT Model name to be used by the Rag Function resource.')
param gptModelName string
@description('Required. The name of the existing AI Foundry AI Services resource to be used by the Rag Function resource.')
param aiFoundryAIServicesName string
@description('Required. The name of the existing AI Foundry Search Services resource to be used by the Rag Function resource.')
param aiFoundrySearchServicesName string
@description('Required. The AI Foundry AI Services endpoint to be used by the Rag Function resource.')
param aiFoundryOpenAIServicesEndpoint string
@description('Required. The AI Foundry AI Project connection string to be used by the Rag Function resource.')
param aiFoundryAIHubProjectConnectionString string
@description('Required. The AI Foundry Search Services connection string to be used by the Rag Function resource.')
param aiFoundryAISearchServiceConnectionString string
@description('Required. The resource ID of the Managed Environment to deploy the Rag Function resource.')
param functionsManagedEnvironmentResourceId string
@description('Required. The CPU resource allocation for the Rag Function resource.')
param functionRagCpu int
@description('Required. The memory resource allocation for the Rag Function resource.')
param functionRagMemory string
@description('Required. The scale limit for the Rag Function resource.')
param functionRagAppScaleLimit int
@description('Required. The connection string for the Application Insights resource to be used by the Rag Function resource.')
param applicationInsightsConnectionString string
@description('Required. The instrumentation key for the Application Insights resource to be used by the Rag Function resource.')
param applicationInsightsInstrumentationKey string

resource existingAIFoundryAIServices 'Microsoft.CognitiveServices/accounts@2024-10-01' existing = {
  name: aiFoundryAIServicesName
}

resource existingAIFoundrySearchServices 'Microsoft.Search/searchServices@2024-06-01-preview' existing = {
  name: aiFoundrySearchServicesName
}

resource resFunctionRAG 'Microsoft.Web/sites@2023-12-01' = {
  name: ragFunctionName
  location: ragFunctionLocation
  tags: tags
  kind: 'functionapp,linux,container,azurecontainerapps'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage_accountname'
          value: ragStorageAccountName
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsightsConnectionString
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsightsInstrumentationKey
        }
        {
          name: 'PYTHON_ENABLE_INIT_INDEXING'
          value: '1'
        }
        {
          name: 'PYTHON_ISOLATE_WORKER_DEPENDENCIES'
          value: '1'
        }
        {
          name: 'SQLDB_DATABASE'
          value: sqlDatabaseName
        }
        {
          name: 'SQLDB_PASSWORD'
          value: sqlServerAdministratorPassword
        }
        {
          name: 'SQLDB_SERVER'
          value: sqlServerFullyQualifiedDomainName //'${varSQLServerName}.database.windows.net'
        }
        {
          name: 'SQLDB_USERNAME'
          value: sqlServerAdministratorLogin
        }
        {
          name: 'AZURE_OPEN_AI_ENDPOINT'
          value: aiFoundryOpenAIServicesEndpoint //moduleAIFoundry.outputs.aiServices_endpoint
        }
        {
          name: 'AZURE_OPEN_AI_API_KEY'
          value: existingAIFoundryAIServices.listKeys().key1
        }
        {
          name: 'AZURE_AI_PROJECT_CONN_STRING'
          value: aiFoundryAIHubProjectConnectionString //moduleAIFoundry.outputs.aiHub_project_connectionString
        }
        {
          name: 'OPENAI_API_VERSION'
          value: gptModelVersionPreview
        }
        {
          name: 'AZURE_OPEN_AI_DEPLOYMENT_MODEL'
          value: gptModelName
        }
        {
          name: 'AZURE_AI_SEARCH_ENDPOINT'
          value: aiFoundryAISearchServiceConnectionString //moduleAIFoundry.outputs.aiSearch_connectionString
        }
        {
          name: 'AZURE_AI_SEARCH_API_KEY'
          value: existingAIFoundrySearchServices.listAdminKeys().primaryKey
        }
        {
          name: 'AZURE_AI_SEARCH_INDEX'
          value: 'call_transcripts_index'
        }
      ]
      linuxFxVersion: ragDockerImageName
      functionAppScaleLimit: functionRagAppScaleLimit
      minimumElasticInstanceCount: 0
      // use32BitWorkerProcess: false
      // ftpsState: 'FtpsOnly'
    }
    managedEnvironmentId: functionsManagedEnvironmentResourceId
    workloadProfileName: 'Consumption'
    // virtualNetworkSubnetId: null
    // clientAffinityEnabled: false
    resourceConfig: {
      cpu: functionRagCpu
      memory: functionRagMemory
    }
    storageAccountRequired: false
  }
}

@description('The resource ID of the Rag Function resource created by this module.')
output resourceId string = resFunctionRAG.id
@description('The principal ID of the Rag Function resource created by this module.')
output principalId string = resFunctionRAG.identity.principalId
@description('The default host name of the Rag Function resource created by this module.')
output defaultHostName string = resFunctionRAG.properties.defaultHostName

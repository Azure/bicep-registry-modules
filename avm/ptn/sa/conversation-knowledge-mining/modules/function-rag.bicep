// NOTE: This module is required to pass keys from previously deployed resources leveraging the existing keyword
// This behavior will be updated in future versions to leverage more secure solutions such as Key Vault or managed identities

param ragFunctionName string
param solutionLocation string
param tags object
param ragDockerImageName string
param ragStorageAccountName string
param sqlDatabaseName string
param sqlServerFullyQualifiedDomainName string
param sqlServerAdministratorLogin string
@secure()
param sqlServerAdministratorPassword string
param gptModelVersionPreview string
param gptModelName string
param aiFoundryAIServicesName string
param aiFoundrySearchServicesName string
param aiFoundryOpenAIServicesEndpoint string
param aiFoundryAIHubProjectConnectionString string
param AIFoundryAISearchServiceConnectionString string
param functionsManagedEnvironmentResourceId string

resource existingAIFoundryAIServices 'Microsoft.CognitiveServices/accounts@2024-10-01' existing = {
  name: aiFoundryAIServicesName
}

resource existingAIFoundrySearchServices 'Microsoft.Search/searchServices@2024-06-01-preview' existing = {
  name: aiFoundrySearchServicesName
}

resource resFunctionRAG 'Microsoft.Web/sites@2023-12-01' = {
  name: ragFunctionName
  location: solutionLocation
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
          value: AIFoundryAISearchServiceConnectionString //moduleAIFoundry.outputs.aiSearch_connectionString
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
      functionAppScaleLimit: 10
      minimumElasticInstanceCount: 0
      // use32BitWorkerProcess: false
      // ftpsState: 'FtpsOnly'
    }
    managedEnvironmentId: functionsManagedEnvironmentResourceId
    workloadProfileName: 'Consumption'
    // virtualNetworkSubnetId: null
    // clientAffinityEnabled: false
    resourceConfig: {
      cpu: 1
      memory: '2Gi'
    }
    storageAccountRequired: false
  }
}

output resourceId string = resFunctionRAG.id
output principalId string = resFunctionRAG.identity.principalId
output defaultHostName string = resFunctionRAG.properties.defaultHostName

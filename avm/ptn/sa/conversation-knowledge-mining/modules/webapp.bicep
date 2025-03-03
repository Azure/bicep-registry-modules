// NOTE: This module is required to pass keys from previously deployed resources leveraging the existing keyword
// This behavior will be updated in future versions to leverage more secure solutions such as Key Vault or managed identities

param deploymentName string
param webAppName string
param location string
param tags object
param serverFarmResourceId string
param appInsightsResourceId string
param aiFoundryAIServicesName string
param webAppImageName string
param appInsightsInstrumentationKey string
param aiServicesEndpoint string
param gptModelVersionPreview string
param gptModelName string
param aiServicesResourceName string
param managedIdentityDefaultHostName string
param chartsFunctionFunctionName string
param webAppAppConfigReact string
param cosmosDbSqlDbName string
param cosmosDbSqlDbNameCollectionName string
param ragFunctionDefaultHostName string
param ragFunctionFunctionName string
param avmCosmosDbResourceName string

resource existingAIFoundryAIServices 'Microsoft.CognitiveServices/accounts@2024-10-01' existing = {
  name: aiFoundryAIServicesName
}

module avmWebsiteWebapp 'br/public:avm/res/web/site:0.13.3' = {
  name: deploymentName
  params: {
    name: webAppName
    tags: tags
    kind: 'app,linux,container'
    location: location
    serverFarmResourceId: serverFarmResourceId
    appInsightResourceId: appInsightsResourceId
    managedIdentities: {
      systemAssigned: true
    }
    siteConfig: {
      linuxFxVersion: webAppImageName
    }
    appSettingsKeyValuePairs: {
      APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
      AZURE_OPENAI_API_VERSION: gptModelVersionPreview
      AZURE_OPENAI_DEPLOYMENT_NAME: gptModelName
      AZURE_OPENAI_ENDPOINT: aiServicesEndpoint
      AZURE_OPENAI_API_KEY: existingAIFoundryAIServices.listKeys().key1
      AZURE_OPENAI_RESOURCE: aiServicesResourceName
      AZURE_OPENAI_PREVIEW_API_VERSION: gptModelVersionPreview
      USE_CHAT_HISTORY_ENABLED: 'True'
      USE_GRAPHRAG: 'False'
      CHART_DASHBOARD_URL: 'https://${managedIdentityDefaultHostName}/api/${chartsFunctionFunctionName}?data_type=charts'
      CHART_DASHBOARD_FILTERS_URL: 'https://${managedIdentityDefaultHostName}/api/${chartsFunctionFunctionName}?data_type=filters'
      GRAPHRAG_URL: 'TBD'
      RAG_URL: 'https://${ragFunctionDefaultHostName}/api/${ragFunctionFunctionName}'
      REACT_APP_LAYOUT_CONFIG: webAppAppConfigReact
      AzureCosmosDB_ACCOUNT: avmCosmosDbResourceName
      //AzureCosmosDB_ACCOUNT_KEY: existingCosmosDB.listKeys().primaryMasterKey //AzureCosmosDB_ACCOUNT_KEY
      AzureCosmosDB_CONVERSATIONS_CONTAINER: cosmosDbSqlDbNameCollectionName
      AzureCosmosDB_DATABASE: cosmosDbSqlDbName
      AzureCosmosDB_ENABLE_FEEDBACK: 'True'
      SCM_DO_BUILD_DURING_DEPLOYMENT: 'true'
      UWSGI_PROCESSES: '2'
      UWSGI_THREADS: '2'
    }
  }
}

output webAppSystemAssignedPrincipalId string = avmWebsiteWebapp.outputs.?systemAssignedMIPrincipalId!

// NOTE: This module is required to pass keys from previously deployed resources leveraging the existing keyword
// This behavior will be updated in future versions to leverage more secure solutions such as Key Vault or managed identities
@description('Required. The deployment name of the AI Hub resource.')
param deploymentName string
@description('Required. The name of the Web Site resource to deploy.')
param webAppName string
@description('Required. The location of the Web Site resource to deploy.')
param location string
@description('Required. The tags to be applied to the Web Site resource.')
param tags object
@description('Required. The resource ID of the App Service Plan resource to deploy the Web Site.')
param serverFarmResourceId string
@description('Required. The resource ID of the Application Insights resource to associate with the Web Site.')
param appInsightsResourceId string
@description('Required. The name of the existing AI Foundry AI Services resource to configure in the Web App.')
param aiFoundryAIServicesName string
@description('Required. The docker image name to associate with the Web Site.')
param webAppImageName string
@description('Required. The instrumentation key of the Application Insights resource to associate with the Web Site.')
param appInsightsInstrumentationKey string
@description('Required. The endpoint of the AI Services resource to associate with the Web Site.')
param aiServicesEndpoint string
@description('Required. The preview version of the GPT model to use in the Web App.')
param gptModelVersionPreview string
@description('Required. The name of the GPT model to use in the Web App.')
param gptModelName string
@description('Required. The name of the AI Services resource to associate with the Web Site.')
param aiServicesResourceName string
@description('Required. The default host name of the Charts Function resource to use in the Web App.')
param chartsFunctionDefaultHostName string
@description('Required. The function name of the Charts Function resource to use in the Web App.')
param chartsFunctionFunctionName string
@description('Required. The React configuration to use in the Web App.')
param webAppAppConfigReact string
@description('Required. The Cosmos DB Sql database name to use in the Web App.')
param cosmosDbSqlDbName string
@description('Required. The Cosmos DB Sql database collection to use in the Web App.')
param cosmosDbSqlDbNameCollectionName string
@description('Required. The default host name of the Rag Function resource to use in the Web App.')
param ragFunctionDefaultHostName string
@description('Required. The name of the Rag Function resource to use in the Web App.')
param ragFunctionFunctionName string
@description('Required. The name of the Cosmos DB resource to use in the Web App.')
param cosmosDbResourceName string
@description('Required. Enable/Disable usage telemetry for module.')
param enableTelemetry bool

resource existingAIFoundryAIServices 'Microsoft.CognitiveServices/accounts@2024-10-01' existing = {
  name: aiFoundryAIServicesName
}

module avmWebsiteWebapp 'br/public:avm/res/web/site:0.13.3' = {
  name: deploymentName
  params: {
    name: webAppName
    tags: tags
    location: location
    enableTelemetry: enableTelemetry
    kind: 'app,linux,container'
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
      CHART_DASHBOARD_URL: 'https://${chartsFunctionDefaultHostName}/api/${chartsFunctionFunctionName}?data_type=charts'
      CHART_DASHBOARD_FILTERS_URL: 'https://${chartsFunctionDefaultHostName}/api/${chartsFunctionFunctionName}?data_type=filters'
      GRAPHRAG_URL: 'TBD'
      RAG_URL: 'https://${ragFunctionDefaultHostName}/api/${ragFunctionFunctionName}'
      REACT_APP_LAYOUT_CONFIG: webAppAppConfigReact
      AzureCosmosDB_ACCOUNT: cosmosDbResourceName
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

@description('The principal ID of the Web App resource.')
output webAppSystemAssignedPrincipalId string = avmWebsiteWebapp.outputs.?systemAssignedMIPrincipalId!

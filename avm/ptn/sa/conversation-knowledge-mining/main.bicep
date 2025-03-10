//TODO: standardize deployment names
//TODO: define parameters for customized configuration

// // ========== main.bicep ========== //
targetScope = 'resourceGroup'

metadata name = 'Conversation Knowledge Mining Solution Accelerator'
metadata description = '''This module deploys the [Conversation Knowledge Mining Solution Accelerator](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator).

**Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator product. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future.

This may result in breaking changes in upcoming versions when these features are implemented.
'''

// ========== Parameters ========== //
// PARAMETERS: names
@description('Required. The prefix to add in the default names given to all deployed Azure resources.')
@maxLength(12)
param solutionPrefix string
@description('Optional. The name of the AI Foundry AI Hub resource. It will override the default given name.')
@maxLength(90)
param aiFoundryAiHubResourceName string = ''
@description('Optional. The name of the AI Foundry AI Project resource. It will override the default given name.')
@maxLength(90)
param aiFoundryAiProjectResourceName string = ''
@description('Optional. The name of the AI Foundry AI Services Content Understanding resource. It will override the default given name.')
@maxLength(90)
param aiFoundryAiServicesContentUnderstandingResourceName string = ''
@description('Optional. The name of the AI Foundry AI Services resource. It will override the default given name.')
@maxLength(90)
param aiFoundryAiServicesResourceName string = ''
@description('Optional. The name of the AI Foundry Application Insights resource. It will override the default given name.')
@maxLength(90)
param aiFoundryApplicationInsightsResourceName string = ''
@description('Optional. The name of the AI Foundry Container Registry resource. It will override the default given name.')
@maxLength(50)
param aiFoundryContainerRegistryResourceName string = ''
@description('Optional. The name of the AI Foundry Search Service resource. It will override the default given name.')
@maxLength(60)
param aiFoundrySearchServiceResourceName string = ''
@description('Optional. The name of the AI Foundry Storage Account resource. It will override the default given name.')
@maxLength(24)
param aiFoundryStorageAccountResourceName string = ''
@description('Optional. The name of the Cosmos DB Account resource. It will override the default given name.')
@maxLength(50)
param cosmosDbAccountResourceName string = ''
@description('Optional. The name of the Function Charts resource. It will override the default given name.')
@maxLength(90)
param functionChartsResourceName string = ''
@description('Optional. The name of the Function RAG resource. It will override the default given name.')
@maxLength(90)
param functionRagResourceName string = ''
@description('Optional. The name of the Functions Managed Environment resource. It will override the default given name.')
@maxLength(90)
param functionsManagedEnvironmentResourceName string = ''
@description('Optional. The name of the Key Vault resource. It will override the default given name.')
@maxLength(24)
param keyVaultResourceName string = ''
@description('Optional. The name of the Log Analytics Workspace resource. It will override the default given name.')
@maxLength(63)
param logAnalyticsWorkspaceResourceName string = ''
@description('Optional. The name of the Managed Identity resource. It will override the default given name.')
@maxLength(128)
param managedIdentityResourceName string = ''
@description('Optional. The name of the Script Copy Data resource. It will override the default given name.')
@maxLength(90)
param scriptCopyDataResourceName string = ''
@description('Optional. The name of the Script Index Data resource. It will override the default given name.')
@maxLength(90)
param scriptIndexDataResourceName string = ''
@description('Optional. The name of the SQL Server resource. It will override the default given name.')
@maxLength(63)
param sqlServerResourceName string = ''
@description('Optional. The name of the Storage Account resource. It will override the default given name.')
@maxLength(24)
param storageAccountResourceName string = ''
@description('Optional. The name of the Web App resource.')
@maxLength(60)
param webAppResourceName string = ''
@description('Optional. The name of the Web App Server Farm resource. It will override the default given name.')
@maxLength(60)
param webAppServerFarmResourceName string = ''

// PARAMETERS: locations
//NOTE: allow for individual locations for each resource
@description('Required. Location for the AI Foundry Content Understanding service deployment.')
@allowed(['West US', 'Sweden Central', 'Australia East'])
@metadata({ azd: { type: 'location' } })
param aiFoundryAiServiceContentUnderstandingLocation string
@description('Optional. Location for the solution deployment. Defaulted to the resource group location.')
@metadata({ azd: { type: 'location' } })
param solutionLocation string = 'East US'
@description('Optional. Secondary location for databases creation.')
@metadata({ azd: { type: 'location' } })
param databasesLocation string = 'East US 2'
@description('Optional. The location for the Web App Server Farm. Defaulted to the solution location.')
@metadata({ azd: { type: 'location' } })
param webAppServerFarmLocation string = solutionLocation
@description('Optional. The location of the AI Foundry AI Services Project.')
@metadata({ azd: { type: 'location' } })
param aiFoundryAiServicesProjectLocation string = solutionLocation
@description('Optional. Location for the AI Foundry AI Hub resource deployment.')
@metadata({ azd: { type: 'location' } })
param aiFoundryAiHubLocation string = solutionLocation
@description('Optional. Location for the AI Foundry AI Service resource deployment.')
@metadata({ azd: { type: 'location' } })
param aiFoundryAiServiceLocation string = solutionLocation
@description('Optional. Location for the AI Foundry AI Project resource deployment.')
@metadata({ azd: { type: 'location' } })
param aiFoundryAiProjectLocation string = solutionLocation
@description('Optional. Location for the AI Foundry Application Insights resource deployment.')
@metadata({ azd: { type: 'location' } })
param aiFoundryApplicationInsightsLocation string = solutionLocation
@description('Optional. Location for the AI Foundry Container Registry resource deployment.')
@metadata({ azd: { type: 'location' } })
param aiFoundryContainerRegistryLocation string = solutionLocation
@description('Optional. Location for the AI Foundry Search Service resource deployment.')
@metadata({ azd: { type: 'location' } })
param aiFoundrySearchServiceLocation string = solutionLocation
@description('Optional. Location for the AI Foundry Storage Account resource deployment.')
@metadata({ azd: { type: 'location' } })
param aiFoundryStorageAccountLocation string = solutionLocation
@description('Optional. Location for the Cosmos DB Account resource deployment.')
@metadata({ azd: { type: 'location' } })
param cosmosDbAccountLocation string = databasesLocation
@description('Optional. Location for the Function Charts resource deployment.')
@metadata({ azd: { type: 'location' } })
param functionChartsLocation string = solutionLocation
@description('Optional. Location for the Function RAG resource deployment.')
@metadata({ azd: { type: 'location' } })
param functionRagLocation string = solutionLocation
@description('Optional. Location for the Functions Managed Environment resource deployment.')
@metadata({ azd: { type: 'location' } })
param functionsManagedEnvironmentLocation string = solutionLocation
@description('Optional. Location for the Key Vault resource deployment.')
@metadata({ azd: { type: 'location' } })
param keyVaultLocation string = solutionLocation
@description('Optional. Location for the Log Analytics Workspace resource deployment.')
@metadata({ azd: { type: 'location' } })
param logAnalyticsWorkspaceLocation string = solutionLocation
@description('Optional. Location for the Managed Identity resource deployment.')
@metadata({ azd: { type: 'location' } })
param managedIdentityLocation string = solutionLocation
@description('Optional. Location for the Script Copy Data resource deployment.')
@metadata({ azd: { type: 'location' } })
param scriptCopyDataLocation string = solutionLocation
@description('Optional. Location for the Script Index Data resource deployment.')
@metadata({ azd: { type: 'location' } })
param scriptIndexDataLocation string = solutionLocation
@description('Optional. Location for the SQL Server resource deployment.')
@metadata({ azd: { type: 'location' } })
param sqlServerLocation string = databasesLocation
@description('Optional. Location for the Storage Account resource deployment.')
@metadata({ azd: { type: 'location' } })
param storageAccountLocation string = solutionLocation
@description('Optional. Location for the Web App resource deployment.')
@metadata({ azd: { type: 'location' } })
param webAppLocation string = solutionLocation

// PARAMETERS: Web app configuration
@description('Optional. The SKU for the web app. If empty, aiFoundryAiServiceContentUnderstandingLocation will be used.')
param webAppServerFarmSku string = 'B2'

// PARAMETERS: models configuration
@description('Optional. GPT model deployment type.')
@allowed([
  'Standard'
  'GlobalStandard'
])
param aiFoundryAIServicesGptModelDeploymentType string = 'GlobalStandard'
@description('Optional. Name of the GPT model to deploy.')
@allowed([
  'gpt-4o-mini'
  'gpt-4o'
  'gpt-4'
])
param aiFoundryAIServicesGptModelName string = 'gpt-4o-mini'
@minValue(10)
@description('Optional. Capacity of the GPT deployment. You can increase this, but capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/en-us/azure/ai-services/openai/quotas-limits).')
// You can increase this, but capacity is limited per model/region, so you will get errors if you go over. // https://learn.microsoft.com/en-us/azure/ai-services/openai/quotas-limits
param aiFoundryAIServicesGptModelDeploymentCapacity int = 100
@description('Optional. Name of the Text Embedding model to deploy.')
@allowed([
  'text-embedding-ada-002'
])
param aiFoundryAiServicesTextEmbeddingModelName string = 'text-embedding-ada-002'
@minValue(10)
@description('Optional. Capacity of the Embedding Model deployment.')
param embeddingDeploymentCapacity int = 80

// PARAMETERS: Docker image configuration
@description('Optional. Docker image version to use for all deployed containers (functions and web app).')
param imageTag string = 'latest'

// PARAMETERS: Telemetry
@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ========== Variables ========== //
// VARIABLES: defaults
var varWorkloadNameFormat = '${solutionPrefix}-{0}' //${uniqueString(resourceGroup().id, solutionPrefix)}
var tags = {
  app: solutionPrefix
  location: solutionLocation
}
var deploymentNameFormat = 'deploy-{0}'

// NOTE: Update location to allow individual locations for each resource
// VARIABLES: calculated resource names

var varAiFoundryAiHubResourceName = empty(aiFoundryAiHubResourceName)
  ? format(varWorkloadNameFormat, 'aifd-aihb')
  : aiFoundryAiHubResourceName
var varAiFoundryAiProjectResourceName = empty(aiFoundryAiProjectResourceName)
  ? format(varWorkloadNameFormat, 'aifd-aipj')
  : aiFoundryAiProjectResourceName
var varAiFoundryAiServiceContentUnderstandingResourceName = empty(aiFoundryAiServicesContentUnderstandingResourceName)
  ? format(varWorkloadNameFormat, 'aifd-aisr-cu')
  : aiFoundryAiServicesContentUnderstandingResourceName
var varAiFoundryAiServiceResourceName = empty(aiFoundryAiServicesResourceName)
  ? format(varWorkloadNameFormat, 'aifd-aisr')
  : aiFoundryAiServicesResourceName
var varAiFoundryApplicationInsightsResourceName = empty(aiFoundryApplicationInsightsResourceName)
  ? format(varWorkloadNameFormat, 'aifd-appi')
  : aiFoundryApplicationInsightsResourceName
var varAiFoundryContainerRegistryResourceName = empty(aiFoundryContainerRegistryResourceName)
  ? replace(format(varWorkloadNameFormat, 'aifd-creg'), '-', '') //NOTE: ACR name should not contain hyphens
  : aiFoundryContainerRegistryResourceName
var varAiFoundrySearchServiceResourceName = empty(aiFoundrySearchServiceResourceName)
  ? format(varWorkloadNameFormat, 'aifd-srch')
  : aiFoundrySearchServiceResourceName
var varAiFoundryStorageAccountResourceName = empty(aiFoundryStorageAccountResourceName)
  ? replace(format(varWorkloadNameFormat, 'aifd-strg'), '-', '') //NOTE: SA name should not contain hyphens
  : aiFoundryStorageAccountResourceName
var varCosmosDbAccountResourceName = empty(cosmosDbAccountResourceName)
  ? format(varWorkloadNameFormat, 'cmdb')
  : cosmosDbAccountResourceName
var varFunctionChartsResourceName = empty(functionChartsResourceName)
  ? format(varWorkloadNameFormat, 'fchr-azfct')
  : functionChartsResourceName
var varFunctionRagResourceName = empty(functionRagResourceName)
  ? format(varWorkloadNameFormat, 'frag-azfct')
  : functionRagResourceName
var varFunctionsManagedEnvironmentResourceName = empty(functionsManagedEnvironmentResourceName)
  ? format(varWorkloadNameFormat, 'ftme')
  : functionsManagedEnvironmentResourceName
var varKeyVaultResourceName = empty(keyVaultResourceName)
  ? format(varWorkloadNameFormat, 'keyv') //NOTE: KV name max length is 24
  : keyVaultResourceName
var varLogAnalyticsWorkspaceResourceName = empty(logAnalyticsWorkspaceResourceName)
  ? format(varWorkloadNameFormat, 'laws')
  : logAnalyticsWorkspaceResourceName
var varManagedIdentityResourceName = empty(managedIdentityResourceName)
  ? format(varWorkloadNameFormat, 'mgid')
  : managedIdentityResourceName
var varScriptCopyDataResourceName = empty(scriptCopyDataResourceName)
  ? format(varWorkloadNameFormat, 'scrp-cpdt')
  : scriptCopyDataResourceName
var varScriptIndexDataResourceName = empty(scriptIndexDataResourceName)
  ? format(varWorkloadNameFormat, 'scrp-idxd')
  : scriptIndexDataResourceName
var varSqlServerResourceName = empty(sqlServerResourceName)
  ? format(varWorkloadNameFormat, 'sqls')
  : sqlServerResourceName
var varStorageAccountResourceName = empty(storageAccountResourceName)
  ? replace(format(varWorkloadNameFormat, 'strg'), '-', '') //NOTE: SA name should not contain hyphens
  : storageAccountResourceName
var varWebAppResourceName = empty(webAppResourceName) ? format(varWorkloadNameFormat, 'wapp-wapp') : webAppResourceName
var varWebAppServerFarmResourceName = empty(webAppServerFarmResourceName)
  ? format(varWorkloadNameFormat, 'waoo-srvf')
  : webAppServerFarmResourceName

// VARIABLES: key vault secrets names
var varKvSecretNameAdlsAccountKey = 'ADLS-ACCOUNT-KEY'
var varKvSecretNameAzureCosmosdbAccountKey = 'AZURE-COSMOSDB-ACCOUNT-KEY'
var varKvSecretNameAdlsAccountContainer = 'ADLS-ACCOUNT-CONTAINER'
var varKvSecretNameAdlsAccountName = 'ADLS-ACCOUNT-NAME'
var varKvSecretNameTenantId = 'TENANT-ID'
var varKvSecretNameAzureCosmosDbAccount = 'AZURE-COSMOSDB-ACCOUNT'
var varKvSecretNameAzureCosmosDbDatabase = 'AZURE-COSMOSDB-DATABASE'
var varKvSecretNameAzureCosmosDbConversationsContainer = 'AZURE-COSMOSDB-CONVERSATIONS-CONTAINER'
var varKvSecretNameAzureCosmosDbEnableFeedback = 'AZURE-COSMOSDB-ENABLE-FEEDBACK'
var varKvSecretNameSqlDbServer = 'SQLDB-SERVER'
var varKvSecretNameSqlDbDatabase = 'SQLDB-DATABASE'
var varKvSecretNameSqlDbUsername = 'SQLDB-USERNAME'
var varKvSecretNameSqlDbPassword = 'SQLDB-PASSWORD'

// VARIABLES: AI Model deployments
var varAiFoundryAiServiceGPTModelVersion = '2024-07-18'
var varAiFoundryAiServiceGPTModelVersionPreview = '2024-02-15-preview'
var varAiFoundryAiServiceTextEmbeddingModelVersion = '2'
var varAiFoundryAiServiceProjectConnectionString = '${toLower(replace(aiFoundryAiServicesProjectLocation, ' ', ''))}.api.azureml.ms;${subscription().subscriptionId};${resourceGroup().name};${varAiFoundryAiProjectResourceName}'
var varAiFoundryAIServicesModelDeployments = [
  {
    name: aiFoundryAIServicesGptModelName
    model: {
      name: aiFoundryAIServicesGptModelName
      format: 'OpenAI'
      version: varAiFoundryAiServiceGPTModelVersion //NOTE: This attribute is mandatory for AVM, but optional for ARM. Request AVM to make it optional
    }
    sku: {
      name: aiFoundryAIServicesGptModelDeploymentType
      capacity: aiFoundryAIServicesGptModelDeploymentCapacity
    }
    raiPolicyName: 'Microsoft.Default'
  }
  {
    name: aiFoundryAiServicesTextEmbeddingModelName
    model: {
      name: aiFoundryAiServicesTextEmbeddingModelName
      format: 'OpenAI'
      version: varAiFoundryAiServiceTextEmbeddingModelVersion //NOTE: This attribute is mandatory for AVM, but optional for ARM. Request AVM to make it optional
    }
    sku: {
      name: 'Standard'
      capacity: embeddingDeploymentCapacity
    }
    raiPolicyName: 'Microsoft.Default'
  }
]

// VARIABLES: CosmosDB
var varCosmosDbSqlDbName = 'db_conversation_history'
var varCosmosDbSqlDbCollName = 'conversations'
var varCosmosDbAccountSqlDbContainers = [
  {
    name: varCosmosDbSqlDbCollName
    id: varCosmosDbSqlDbCollName //NOT: Might not be needed
    partitionKey: '/userId'
  }
]

// VARIABLES: SQL Database
var varSQLDatabaseName = '${varSqlServerResourceName }-sql-db'
var varSQLServerAdministratorLogin = 'sqladmin' //NOTE: credentials should not be hardcoded
var varSQLServerAdministratorPassword = 'TestPassword_1234' //NOTE: credentials should not be hardcoded

// VARIABLES: Deployment scripts
var varCKMGithubBaseUrl = 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/main/'
var varStorageContainerName = 'data'

// VARIABLES: Function settings
var varChartsDockerImageName = 'DOCKER|kmcontainerreg.azurecr.io/km-charts-function:${imageTag}'
var varChartsFunctionFunctionName = 'get_metrics'
var varRAGDockerImageName = 'DOCKER|kmcontainerreg.azurecr.io/km-rag-function:${imageTag}'
var varRAGFunctionFunctionName = 'stream_openai_text'

// VARIABLES: Web App settings
var varWebAppImageName = 'DOCKER|kmcontainerreg.azurecr.io/km-app:${imageTag}'
var varWebAppAppConfigReact = '''{
  "appConfig": {
    "THREE_COLUMN": {
      "DASHBOARD": 50,
      "CHAT": 33,
      "CHATHISTORY": 17
    },
    "TWO_COLUMN": {
      "DASHBOARD_CHAT": {
        "DASHBOARD": 65,
        "CHAT": 35
      },
      "CHAT_CHATHISTORY": {
        "CHAT": 80,
        "CHATHISTORY": 20
      }
    }
  },
  "charts": [
    {
      "id": "SATISFIED",
      "name": "Satisfied",
      "type": "card",
      "layout": { "row": 1, "column": 1, "height": 11 }
    },
    {
      "id": "TOTAL_CALLS",
      "name": "Total Calls",
      "type": "card",
      "layout": { "row": 1, "column": 2, "span": 1 }
    },
    {
      "id": "AVG_HANDLING_TIME",
      "name": "Average Handling Time",
      "type": "card",
      "layout": { "row": 1, "column": 3, "span": 1 }
    },
    {
      "id": "SENTIMENT",
      "name": "Topics Overview",
      "type": "donutchart",
      "layout": { "row": 2, "column": 1, "width": 40, "height": 44.5 }
    },
    {
      "id": "AVG_HANDLING_TIME_BY_TOPIC",
      "name": "Average Handling Time By Topic",
      "type": "bar",
      "layout": { "row": 2, "column": 2, "row-span": 2, "width": 60 }
    },
    {
      "id": "TOPICS",
      "name": "Trending Topics",
      "type": "table",
      "layout": { "row": 3, "column": 1, "span": 2 }
    },
    {
      "id": "KEY_PHRASES",
      "name": "Key Phrases",
      "type": "wordcloud",
      "layout": { "row": 3, "column": 2, "height": 44.5 }
    }
  ]
}'''

// ========== Telemetry ========== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.ptn.sa-convknowledgemining.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, solutionLocation), 0, 4)}',
    64
  )
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

// ========== Managed Identity ========== //

// resource avmManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
//   name: varManagedIdentityResourceName
//   location: solutionLocation
//   tags: tags
// }

module avmManagedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: format(deploymentNameFormat, varManagedIdentityResourceName)
  params: {
    name: varManagedIdentityResourceName
    tags: tags
    location: managedIdentityLocation
    enableTelemetry: enableTelemetry
  }
}

// NOTE: This assignment should leverage AVM module [avm/res/resources/resource-group](https://azure.github.io/Azure-Verified-Modules/indexes/bicep/bicep-resource-modules/), but current target scope is resourceGroup
// TODO: Owner permissions to RG is an unsecure practice, fine grain permissions
module assignResourceGroupOwner 'modules/rbac-rg-owner.bicep' = {
  name: 'rbac-rg-owner'
  params: {
    managedIdentityResourceId: avmManagedIdentity.outputs.resourceId
    managedIdentityPrincipalId: avmManagedIdentity.outputs.principalId
  }
}

// ========== Key Vault ========== //
module avmKeyVault 'br/public:avm/res/key-vault/vault:0.11.2' = {
  name: format(deploymentNameFormat, varKeyVaultResourceName)
  params: {
    name: varKeyVaultResourceName
    tags: tags
    location: keyVaultLocation
    enableTelemetry: enableTelemetry
    sku: 'standard'
    createMode: 'default'
    enableVaultForDeployment: true
    enableVaultForDiskEncryption: true
    enableVaultForTemplateDeployment: true
    enableSoftDelete: true //NOTE: This must become a parameter
    softDeleteRetentionInDays: 7
    enablePurgeProtection: false //NOTE: Set to true on original
    publicNetworkAccess: 'Enabled'
    enableRbacAuthorization: true
    accessPolicies: [
      //NOTE: This should be moved to RBAC
      {
        objectId: avmManagedIdentity.outputs.principalId
        permissions: {
          //NOTE: Fine grain permissions for Production environment
          keys: ['all']
          secrets: ['all']
          certificates: ['all']
          storage: ['all']
        }
      }
    ]
    roleAssignments: [
      {
        principalId: avmManagedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '00482a5a-887f-4fb3-b363-3b7fe8e74483' //NOTE: Built-in role 'Key Vault Administrator'
      }
    ]
    secrets: [
      { name: varKvSecretNameAdlsAccountContainer, value: 'data' }
      { name: varKvSecretNameAdlsAccountName, value: varStorageAccountResourceName }
      { name: varKvSecretNameTenantId, value: subscription().tenantId }
      { name: varKvSecretNameAzureCosmosDbAccount, value: varCosmosDbAccountResourceName }
      { name: varKvSecretNameAzureCosmosDbDatabase, value: varCosmosDbSqlDbName }
      { name: varKvSecretNameAzureCosmosDbConversationsContainer, value: varCosmosDbSqlDbCollName }
      { name: varKvSecretNameAzureCosmosDbEnableFeedback, value: 'True' }
      {
        name: varKvSecretNameSqlDbServer
        value: '${varSqlServerResourceName}${environment().suffixes.sqlServerHostname}'
      } //value: '${varSqlServerResourceName}.database.windows.net'
      { name: varKvSecretNameSqlDbDatabase, value: varSQLDatabaseName }
      { name: varKvSecretNameSqlDbUsername, value: varSQLServerAdministratorLogin }
      { name: varKvSecretNameSqlDbPassword, value: varSQLServerAdministratorPassword }
      { name: 'AZURE-OPENAI-PREVIEW-API-VERSION', value: varAiFoundryAiServiceGPTModelVersionPreview }
      { name: 'AZURE-AI-PROJECT-CONN-STRING', value: varAiFoundryAiServiceProjectConnectionString }
      { name: 'AZURE-OPEN-AI-DEPLOYMENT-MODEL', value: varAiFoundryAIServicesModelDeployments[0].model.name }
      { name: 'AZURE-OPENAI-CU-VERSION', value: '?api-version=2024-12-01-preview' }
      { name: 'AZURE-SEARCH-ENDPOINT', value: 'https://${varAiFoundrySearchServiceResourceName}.search.windows.net' }
      { name: 'AZURE-SEARCH-SERVICE', value: varAiFoundrySearchServiceResourceName }
      { name: 'AZURE-SEARCH-INDEX', value: 'transcripts_index' }
      { name: 'COG-SERVICES-NAME', value: varAiFoundryAiServiceResourceName }
      { name: 'AZURE-SUBSCRIPTION-ID', value: subscription().subscriptionId }
      { name: 'AZURE-RESOURCE-GROUP', value: resourceGroup().name }
      { name: 'AZURE-LOCATION', value: solutionLocation }
    ]
  }
}

// ========== Log Analytics Workspace ========== //

// NOTE: Deploying this resource to use latest version of AVM Application Insights - Resource ID of the log analytics workspace which the
// data will be ingested to. This property is required to create an application with this API version.
// Applications from older versions will not have this property.
module avmLogAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.9.1' = {
  name: format(deploymentNameFormat, varLogAnalyticsWorkspaceResourceName)
  params: {
    name: varLogAnalyticsWorkspaceResourceName
    tags: tags
    location: logAnalyticsWorkspaceLocation
    enableTelemetry: enableTelemetry
    skuName: 'PerGB2018'
    dataRetention: 30
  }
}

// ========== AI Foundry ========== //

module moduleAIFoundry './modules/ai-foundry.bicep' = {
  //name: format(deploymentNameFormat, varAIFoundryDeploymentName)
  name: 'module-ai-foundry'
  params: {
    tags: tags
    aiHubLocation: aiFoundryAiHubLocation
    aiServiceLocation: aiFoundryAiServiceLocation
    aiServiceContentUnderstandingLocation: aiFoundryAiServiceContentUnderstandingLocation
    aiProjectLocation: aiFoundryAiProjectLocation
    applicationInsightsLocation: aiFoundryApplicationInsightsLocation
    containerRegistryLocation: aiFoundryContainerRegistryLocation
    searchServiceLocation: aiFoundrySearchServiceLocation
    storageAccountLocation: aiFoundryStorageAccountLocation
    enableTelemetry: enableTelemetry
    keyVault_name: varKeyVaultResourceName
    avm_operational_insights_workspace_resourceId: avmLogAnalyticsWorkspace.outputs.resourceId
    applicationInsights_name: varAiFoundryApplicationInsightsResourceName
    containerRegistry_name: varAiFoundryContainerRegistryResourceName
    aiServices_name: varAiFoundryAiServiceResourceName
    aiServices_cu_name: varAiFoundryAiServiceContentUnderstandingResourceName
    aiServices_deployments: varAiFoundryAIServicesModelDeployments
    searchService_name: varAiFoundrySearchServiceResourceName
    storageAccount_name: varAiFoundryStorageAccountResourceName
    machineLearningServicesWorkspaces_aihub_name: varAiFoundryAiHubResourceName
    machineLearningServicesWorkspaces_project_name: varAiFoundryAiProjectResourceName
    managedIdentityPrincipalId: avmManagedIdentity.outputs.principalId
  }
}

// ========== Storage Account ========== //

module avmStorageAccount 'br/public:avm/res/storage/storage-account:0.18.1' = {
  name: format(deploymentNameFormat, varStorageAccountResourceName)
  params: {
    name: varStorageAccountResourceName
    tags: tags
    location: storageAccountLocation
    enableTelemetry: enableTelemetry
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowCrossTenantReplication: false
    allowSharedKeyAccess: false
    requireInfrastructureEncryption: true
    enableHierarchicalNamespace: false
    largeFileSharesState: 'Disabled'
    enableNfsV3: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    blobServices: {
      corsRules: []
      automaticSnapshotPolicyEnabled: false
      deleteRetentionPolicyAllowPermanentDelete: false
      deleteRetentionPolicyDays: 7
      deleteRetentionPolicyEnabled: false
      containerDeleteRetentionPolicyAllowPermanentDelete: false
      containerDeleteRetentionPolicyDays: 7
      containerDeleteRetentionPolicyEnabled: false
      containers: [
        {
          name: 'data'
          publicAccess: 'None'
          defaultEncryptionScope: '$account-encryption-key'
          denyEncryptionScopeOverride: false
        }
      ]
    }
    roleAssignments: [
      {
        principalId: avmManagedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
      }
      {
        principalId: functionCharts.identity.principalId
        roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
      }
    ]
    secretsExportConfiguration: {
      keyVaultResourceId: avmKeyVault.outputs.resourceId
      accessKey1Name: varKvSecretNameAdlsAccountKey
    }
  }
}

// ========== Cosmos Database ========== //

module avmCosmosDB 'br/public:avm/res/document-db/database-account:0.11.0' = {
  name: format(deploymentNameFormat, varCosmosDbAccountResourceName)
  params: {
    name: varCosmosDbAccountResourceName
    tags: tags
    location: cosmosDbAccountLocation
    enableTelemetry: enableTelemetry
    defaultConsistencyLevel: 'Session'
    locations: [
      {
        locationName: cosmosDbAccountLocation
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
    automaticFailover: false
    enableMultipleWriteLocations: false
    disableLocalAuth: false
    capabilitiesToAdd: ['EnableServerless']
    serverVersion: '4.0'
    sqlDatabases: [
      {
        name: varCosmosDbSqlDbName
        containers: [
          for container in varCosmosDbAccountSqlDbContainers: {
            name: container.name
            paths: [container.partitionKey]
          }
        ]
      }
    ]
    secretsExportConfiguration: {
      keyVaultResourceId: avmKeyVault.outputs.resourceId
      primaryWriteKeySecretName: varKvSecretNameAzureCosmosdbAccountKey
    }
  }
}

// ========== SQL Database Server ========== //

module avmSQLServer 'br/public:avm/res/sql/server:0.12.2' = {
  name: format(deploymentNameFormat, varSqlServerResourceName)
  params: {
    name: varSqlServerResourceName
    tags: tags
    location: sqlServerLocation
    enableTelemetry: enableTelemetry
    administratorLogin: varSQLServerAdministratorLogin
    administratorLoginPassword: varSQLServerAdministratorPassword
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'

    firewallRules: [
      {
        name: 'AllowSpecificRange'
        startIpAddress: '0.0.0.0'
        endIpAddress: '0.0.0.0'
      }
    ]
    databases: [
      {
        name: varSQLDatabaseName
        sku: {
          name: 'GP_Gen5_2'
          tier: 'GeneralPurpose'
          family: 'Gen5'
          capacity: 2
        }
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        autoPauseDelay: 60
        minCapacity: '1'
        readScale: 'Disabled'
        zoneRedundant: false
      }
    ]
  }
}

//========== Deployment script to upload sample data ========== //

module avmDeploymentScriptCopyData 'br/public:avm/res/resources/deployment-script:0.5.1' = {
  name: format(deploymentNameFormat, varScriptCopyDataResourceName)
  params: {
    kind: 'AzureCLI'
    name: varScriptCopyDataResourceName
    tags: tags
    location: scriptCopyDataLocation
    enableTelemetry: enableTelemetry
    managedIdentities: {
      userAssignedResourceIds: [
        avmManagedIdentity.outputs.resourceId
      ]
    }
    azCliVersion: '2.50.0'
    primaryScriptUri: '${varCKMGithubBaseUrl}infra/scripts/copy_kb_files.sh'
    arguments: '${avmStorageAccount.outputs.name} ${varStorageContainerName} ${varCKMGithubBaseUrl}'
    timeout: 'PT1H'
    retentionInterval: 'PT1H'
    cleanupPreference: 'OnSuccess'
  }
  dependsOn: [
    #disable-next-line no-unnecessary-dependson
    moduleAIFoundry
  ]
}

//========== Deployment script to process and index data ========== //

module avmDeploymentScritptIndexData 'br/public:avm/res/resources/deployment-script:0.5.1' = {
  name: format(deploymentNameFormat, varScriptIndexDataResourceName)
  params: {
    kind: 'AzureCLI'
    name: varScriptIndexDataResourceName
    tags: tags
    location: scriptIndexDataLocation
    enableTelemetry: enableTelemetry
    managedIdentities: {
      userAssignedResourceIds: [
        avmManagedIdentity.outputs.resourceId
      ]
    }
    azCliVersion: '2.52.0'
    primaryScriptUri: '${varCKMGithubBaseUrl}infra/scripts/run_create_index_scripts.sh'
    arguments: '${varCKMGithubBaseUrl} ${avmKeyVault.outputs.name}'
    timeout: 'PT1H'
    retentionInterval: 'PT1H'
    cleanupPreference: 'OnSuccess'
  }
  dependsOn: [moduleAIFoundry, avmSQLServer, avmDeploymentScriptCopyData]
}

//========== Azure function: Managed Environment ========== //

module avmFunctionsManagedEnvironment 'br/public:avm/res/app/managed-environment:0.9.0' = {
  name: format(deploymentNameFormat, varFunctionsManagedEnvironmentResourceName)
  params: {
    name: varFunctionsManagedEnvironmentResourceName
    tags: tags
    location: functionsManagedEnvironmentLocation
    enableTelemetry: enableTelemetry
    zoneRedundant: false
    workloadProfiles: [
      {
        workloadProfileType: 'Consumption'
        name: 'Consumption'
      }
    ]
    peerTrafficEncryption: false
    logAnalyticsWorkspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId
  }
}

resource functionCharts 'Microsoft.Web/sites@2023-12-01' = {
  name: varFunctionChartsResourceName
  tags: tags
  location: functionChartsLocation
  kind: 'functionapp,linux,container,azurecontainerapps'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage_accountname'
          value: moduleAIFoundry.outputs.storageAccount_name
        }
        {
          name: 'SQLDB_DATABASE'
          value: varSQLDatabaseName
        }
        {
          name: 'SQLDB_PASSWORD'
          value: varSQLServerAdministratorPassword
        }
        {
          name: 'SQLDB_SERVER'
          value: avmSQLServer.outputs.fullyQualifiedDomainName //'${varSqlServerResourceName}.database.windows.net' CHECK THIS
        }
        {
          name: 'SQLDB_USERNAME'
          value: varSQLServerAdministratorLogin
        }
      ]
      linuxFxVersion: varChartsDockerImageName
      functionAppScaleLimit: 10
      minimumElasticInstanceCount: 0
      // use32BitWorkerProcess: false
      // ftpsState: 'FtpsOnly'
    }
    managedEnvironmentId: avmFunctionsManagedEnvironment.outputs.resourceId
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

// module avmStorageAccountCharts 'br/public:avm/res/storage/storage-account:0.17.3' = {
//   name: format(deploymentNameFormat, varChartsStorageAccountName)
//   params: {
//     name: varChartsStorageAccountName
//     location: solutionLocation
//     tags: tags
//     skuName: 'Standard_LRS'
//     kind: 'StorageV2'
//     accessTier: 'Hot'
//     roleAssignments: [
//       {
//         principalId: functionCharts.identity.principalId
//         roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
//       }
//     ]
//   }
// }

//========== Azure function: Rag ========== //

module moduleFunctionRAG 'modules/function-rag.bicep' = {
  name: 'module-function-rag'
  params: {
    ragFunctionName: varFunctionRagResourceName
    solutionLocation: functionRagLocation
    tags: tags
    ragStorageAccountName: moduleAIFoundry.outputs.storageAccount_name
    aiFoundryAIHubProjectConnectionString: varAiFoundryAiServiceProjectConnectionString
    AIFoundryAISearchServiceConnectionString: moduleAIFoundry.outputs.aiSearch_connectionString
    aiFoundryAIServicesName: moduleAIFoundry.outputs.aiServices_name
    aiFoundryOpenAIServicesEndpoint: moduleAIFoundry.outputs.aiServices_endpoint
    aiFoundrySearchServicesName: moduleAIFoundry.outputs.aiSearch_name
    functionsManagedEnvironmentResourceId: avmFunctionsManagedEnvironment.outputs.resourceId
    gptModelName: aiFoundryAIServicesGptModelName
    gptModelVersionPreview: varAiFoundryAiServiceGPTModelVersionPreview
    ragDockerImageName: varRAGDockerImageName
    sqlDatabaseName: varSQLDatabaseName
    sqlServerAdministratorLogin: varSQLServerAdministratorLogin
    sqlServerAdministratorPassword: varSQLServerAdministratorPassword
    sqlServerFullyQualifiedDomainName: avmSQLServer.outputs.fullyQualifiedDomainName
  }
}

// module avmStorageAccountFunctions 'br/public:avm/res/storage/storage-account:0.17.3' = {
//   name: format(deploymentNameFormat, varFunctionsStorageAccountName)
//   params: {
//     name: varFunctionsStorageAccountName
//     location: solutionLocation
//     tags: tags
//     skuName: 'Standard_LRS'
//     kind: 'StorageV2'
//     accessTier: 'Hot'
//     roleAssignments: [
//       // {
//       //   principalId: moduleFunctionRAG.outputs.principalId
//       //   roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
//       // }
//       {
//         principalId: functionCharts.identity.principalId
//         roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
//       }
//     ]
//   }
// }

// module avmStorageAccountRAG 'br/public:avm/res/storage/storage-account:0.17.3' = {
//   name: format(deploymentNameFormat, varRAGStorageAccountName)
//   params: {
//     name: varRAGStorageAccountName
//     location: solutionLocation
//     tags: tags
//     skuName: 'Standard_LRS'
//     kind: 'StorageV2'
//     accessTier: 'Hot'
//     roleAssignments: [
//       {
//         principalId: moduleFunctionRAG.outputs.principalId
//         roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
//       }
//     ]
//   }
// }

module rbacAiprojectAideveloper 'modules/rbac-aiproject-aideveloper.bicep' = {
  name: 'module-rbac-aiproject-aideveloper'
  params: {
    aiServicesProjectResourceName: moduleAIFoundry.outputs.aiHub_project_name
    identityPrincipalId: moduleFunctionRAG.outputs.principalId
    aiServicesProjectResourceId: moduleAIFoundry.outputs.aiHub_project_resourceId
    ragFunctionResourceId: moduleFunctionRAG.outputs.resourceId
  }
}

//========== CKM Webapp ========== //

module avmServerFarmWebapp 'br/public:avm/res/web/serverfarm:0.4.1' = {
  name: format(deploymentNameFormat, varWebAppServerFarmResourceName)
  params: {
    name: varWebAppServerFarmResourceName
    tags: tags
    location: webAppServerFarmLocation
    enableTelemetry: enableTelemetry
    skuName: webAppServerFarmSku
    reserved: true
    kind: 'linux'
  }
}

module moduleWebsiteWebapp 'modules/webapp.bicep' = {
  name: 'module-webapp'
  params: {
    deploymentName: format(deploymentNameFormat, varWebAppResourceName)
    webAppName: varWebAppResourceName
    tags: tags
    location: webAppLocation
    enableTelemetry: enableTelemetry
    serverFarmResourceId: avmServerFarmWebapp.outputs.resourceId
    appInsightsResourceId: moduleAIFoundry.outputs.appInsights_resourceId
    aiFoundryAIServicesName: moduleAIFoundry.outputs.aiServices_name
    webAppImageName: varWebAppImageName
    appInsightsInstrumentationKey: moduleAIFoundry.outputs.appInsights_instrumentationKey
    aiServicesEndpoint: moduleAIFoundry.outputs.aiServices_endpoint
    gptModelName: aiFoundryAIServicesGptModelName
    gptModelVersionPreview: varAiFoundryAiServiceGPTModelVersionPreview
    aiServicesResourceName: moduleAIFoundry.outputs.aiServices_name
    managedIdentityDefaultHostName: functionCharts.properties.defaultHostName
    chartsFunctionFunctionName: varChartsFunctionFunctionName
    webAppAppConfigReact: varWebAppAppConfigReact
    cosmosDbSqlDbName: varCosmosDbSqlDbName
    cosmosDbSqlDbNameCollectionName: varCosmosDbSqlDbCollName
    ragFunctionDefaultHostName: moduleFunctionRAG.outputs.defaultHostName
    ragFunctionFunctionName: varRAGFunctionFunctionName
    avmCosmosDbResourceName: avmCosmosDB.outputs.name
  }
}

module rbac 'modules/rbac-cosmosdb-contributor.bicep' = {
  name: 'module-rbac-cosmosdb-contributor'
  params: {
    cosmosDBAccountName: avmCosmosDB.outputs.name
    principalId: moduleWebsiteWebapp.outputs.webAppSystemAssignedPrincipalId
  }
}

@description('The resource group the resources were deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The url of the webapp where the deployed Conversation Knowledge Mining solution can be accessed.')
output webAppUrl string = '${varWebAppResourceName}.azurewebsites.net'
